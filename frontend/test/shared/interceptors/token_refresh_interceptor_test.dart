import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weekplanner/shared/interceptors/token_refresh_interceptor.dart';

import '../../helpers/jwt_test_helper.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

/// An [HttpClientAdapter] that returns canned responses based on a callback.
class _FakeAdapter implements HttpClientAdapter {
  final Future<ResponseBody> Function(RequestOptions options) handler;

  _FakeAdapter(this.handler);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) => handler(options);

  @override
  void close({bool force = false}) {}
}

void main() {
  late MockFlutterSecureStorage mockStorage;
  late Dio refreshDio;
  late Dio coreDio;
  late Dio activityDio;
  late TokenRefreshInterceptor interceptor;
  late bool tokenRefreshedCalled;
  late bool refreshFailedCalled;
  late String? lastRefreshedToken;

  ResponseBody jsonResponse(int statusCode, Map<String, dynamic> data) {
    return ResponseBody.fromString(
      json.encode(data),
      statusCode,
      headers: {
        'content-type': ['application/json; charset=utf-8'],
      },
    );
  }

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    refreshDio = Dio(BaseOptions(baseUrl: 'http://core:8000'));
    coreDio = Dio(BaseOptions(baseUrl: 'http://core:8000'));
    activityDio = Dio(BaseOptions(baseUrl: 'http://activity:5171'));

    tokenRefreshedCalled = false;
    refreshFailedCalled = false;
    lastRefreshedToken = null;

    interceptor = TokenRefreshInterceptor(
      refreshDio: refreshDio,
      storage: mockStorage,
      protectedDios: [coreDio, activityDio],
      onTokenRefreshed: (token) {
        tokenRefreshedCalled = true;
        lastRefreshedToken = token;
      },
      onRefreshFailed: () {
        refreshFailedCalled = true;
      },
    );

    coreDio.interceptors.add(interceptor);
    activityDio.interceptors.add(interceptor);
  });

  group('TokenRefreshInterceptor', () {
    test('passes through non-401 errors', () async {
      coreDio.httpClientAdapter = _FakeAdapter((_) async {
        return jsonResponse(500, {'error': 'server error'});
      });

      expect(
        () => coreDio.get('/api/v1/organizations'),
        throwsA(isA<DioException>().having(
          (e) => e.response?.statusCode,
          'statusCode',
          500,
        )),
      );

      expect(tokenRefreshedCalled, false);
      expect(refreshFailedCalled, false);
    });

    test('refreshes token and retries on 401', () async {
      final newToken = createValidJwt();
      var coreCallCount = 0;

      // Core Dio: first call → 401, retry → 200.
      coreDio.httpClientAdapter = _FakeAdapter((options) async {
        coreCallCount++;
        if (coreCallCount == 1) {
          return jsonResponse(401, {'detail': 'unauthorized'});
        }
        return jsonResponse(200, {'ok': true});
      });

      // Refresh Dio: return new access token.
      refreshDio.httpClientAdapter = _FakeAdapter((_) async {
        return jsonResponse(200, {'access': newToken});
      });

      when(() => mockStorage.read(key: 'refresh_token'))
          .thenAnswer((_) async => 'valid-refresh-token');
      when(() => mockStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async {});

      final response = await coreDio.get('/api/v1/organizations');

      expect(response.statusCode, 200);
      expect(tokenRefreshedCalled, true);
      expect(lastRefreshedToken, newToken);
      expect(refreshFailedCalled, false);

      // Headers updated on both Dio instances.
      expect(
        coreDio.options.headers['Authorization'],
        'Bearer $newToken',
      );
      expect(
        activityDio.options.headers['Authorization'],
        'Bearer $newToken',
      );
    });

    test('calls onRefreshFailed when no refresh token in storage', () async {
      coreDio.httpClientAdapter = _FakeAdapter((_) async {
        return jsonResponse(401, {'detail': 'unauthorized'});
      });

      when(() => mockStorage.read(key: 'refresh_token'))
          .thenAnswer((_) async => null);

      await expectLater(
        () => coreDio.get('/api/v1/organizations'),
        throwsA(isA<DioException>()),
      );

      expect(refreshFailedCalled, true);
      expect(tokenRefreshedCalled, false);
    });

    test('calls onRefreshFailed when refresh endpoint returns 401', () async {
      coreDio.httpClientAdapter = _FakeAdapter((_) async {
        return jsonResponse(401, {'detail': 'unauthorized'});
      });

      refreshDio.httpClientAdapter = _FakeAdapter((_) async {
        return jsonResponse(401, {'detail': 'refresh token expired'});
      });

      when(() => mockStorage.read(key: 'refresh_token'))
          .thenAnswer((_) async => 'expired-refresh-token');

      await expectLater(
        () => coreDio.get('/api/v1/organizations'),
        throwsA(isA<DioException>()),
      );

      expect(refreshFailedCalled, true);
      expect(tokenRefreshedCalled, false);
    });

    test('concurrent 401s only refresh once', () async {
      final newToken = createValidJwt();
      var refreshCallCount = 0;

      // Both Dio instances: first call → 401, retry → 200.
      var coreCallCount = 0;
      coreDio.httpClientAdapter = _FakeAdapter((_) async {
        coreCallCount++;
        if (coreCallCount == 1) {
          return jsonResponse(401, {'detail': 'unauthorized'});
        }
        return jsonResponse(200, {'data': 'core'});
      });

      var activityCallCount = 0;
      activityDio.httpClientAdapter = _FakeAdapter((_) async {
        activityCallCount++;
        if (activityCallCount == 1) {
          return jsonResponse(401, {'detail': 'unauthorized'});
        }
        return jsonResponse(200, {'data': 'activity'});
      });

      refreshDio.httpClientAdapter = _FakeAdapter((_) async {
        refreshCallCount++;
        // Small delay to simulate network.
        await Future<void>.delayed(const Duration(milliseconds: 10));
        return jsonResponse(200, {'access': newToken});
      });

      when(() => mockStorage.read(key: 'refresh_token'))
          .thenAnswer((_) async => 'valid-refresh-token');
      when(() => mockStorage.write(
            key: any(named: 'key'),
            value: any(named: 'value'),
          )).thenAnswer((_) async {});

      final results = await Future.wait([
        coreDio.get('/api/v1/organizations'),
        activityDio.get('/weekplan/1'),
      ]);

      expect(results[0].statusCode, 200);
      expect(results[1].statusCode, 200);
      expect(refreshCallCount, 1);
    });
  });
}
