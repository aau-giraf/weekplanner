import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';
import 'package:weekplanner/shared/services/auth_service.dart';

final _log = Logger('TokenRefreshInterceptor');

/// Dio interceptor that transparently refreshes expired access tokens.
///
/// When a 401 response is received, the interceptor:
/// 1. Reads the refresh token from secure storage
/// 2. Calls the giraf-core token refresh endpoint
/// 3. Updates all protected Dio instances with the new access token
/// 4. Retries the original request
///
/// Concurrent 401s are serialized: only one refresh attempt runs at a time,
/// and other requests wait for its result.
class TokenRefreshInterceptor extends Interceptor {
  final Dio _refreshDio;
  final FlutterSecureStorage _storage;
  final List<Dio> _protectedDios;
  final void Function(String token)? onTokenRefreshed;
  final void Function()? onRefreshFailed;

  static const _refreshPath = '/api/v1/token/refresh';
  static const _retryHeader = 'x-token-retry';

  bool _isRefreshing = false;
  Completer<String?>? _refreshCompleter;

  TokenRefreshInterceptor({
    required Dio refreshDio,
    required FlutterSecureStorage storage,
    required List<Dio> protectedDios,
    this.onTokenRefreshed,
    this.onRefreshFailed,
  })  : _refreshDio = refreshDio,
        _storage = storage,
        _protectedDios = protectedDios;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // Don't intercept the refresh endpoint itself to avoid infinite loops.
    if (err.requestOptions.path.contains(_refreshPath)) {
      return handler.next(err);
    }

    // Don't intercept retried requests (already refreshed).
    if (err.requestOptions.headers[_retryHeader] == 'true') {
      return handler.next(err);
    }

    // If another request is already refreshing, wait for its result.
    if (_isRefreshing) {
      _log.fine('Refresh already in progress, waiting…');
      final newToken = await _refreshCompleter!.future;
      if (newToken != null) {
        try {
          return handler.resolve(await _retry(err.requestOptions, newToken));
        } catch (_) {
          return handler.next(err);
        }
      }
      return handler.next(err);
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<String?>();

    try {
      final refreshToken = await _storage.read(key: AuthService.refreshTokenKey);
      if (refreshToken == null) {
        _log.warning('No refresh token in storage');
        _refreshCompleter!.complete(null);
        onRefreshFailed?.call();
        return handler.next(err);
      }

      _log.info('Access token expired, attempting refresh…');
      final response = await _refreshDio.post(
        _refreshPath,
        data: {'refresh': refreshToken},
      );
      final newAccessToken =
          (response.data as Map<String, dynamic>)['access'] as String;

      // Persist the new access token.
      await _storage.write(key: AuthService.accessTokenKey, value: newAccessToken);

      // Update all protected Dio instances.
      for (final dio in _protectedDios) {
        dio.options.headers['Authorization'] = 'Bearer $newAccessToken';
      }

      _log.info('Token refreshed successfully');
      _refreshCompleter!.complete(newAccessToken);
      onTokenRefreshed?.call(newAccessToken);

      // Retry the original request with the new token.
      return handler.resolve(await _retry(err.requestOptions, newAccessToken));
    } on DioException catch (e) {
      _log.warning('Token refresh failed: ${e.message}');
      _refreshCompleter!.complete(null);
      onRefreshFailed?.call();
      return handler.next(err);
    } catch (e, stackTrace) {
      _log.severe('Unexpected error during token refresh', e, stackTrace);
      _refreshCompleter!.complete(null);
      onRefreshFailed?.call();
      return handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }

  /// Retry a failed request with a new access token.
  ///
  /// Finds the matching protected [Dio] instance by base URL and retries
  /// through it. A retry header prevents this interceptor from re-triggering.
  Future<Response<dynamic>> _retry(
    RequestOptions requestOptions,
    String newToken,
  ) async {
    requestOptions.headers['Authorization'] = 'Bearer $newToken';
    requestOptions.headers[_retryHeader] = 'true';

    // Find the Dio that owns this request based on base URL.
    final uri = requestOptions.uri.toString();
    final dio = _protectedDios.firstWhere(
      (d) => uri.startsWith(d.options.baseUrl),
      orElse: () {
        _log.warning('No matching Dio for $uri, using first');
        return _protectedDios.first;
      },
    );
    return dio.fetch(requestOptions);
  }
}
