import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logging/logging.dart';

import 'package:weekplanner/core/errors/auth_failure.dart';
import 'package:weekplanner/shared/services/auth_service.dart';
import 'package:weekplanner/shared/utils/jwt_decode.dart';

final _log = Logger('AuthRepository');

/// Pure data layer for authentication operations.
///
/// All methods return [Either] to communicate success or typed failure.
/// No state management — that responsibility belongs to [AuthCubit].
class AuthRepository {
  final AuthService _authService;

  AuthRepository({required AuthService authService})
      : _authService = authService;

  /// Authenticate with email and password.
  Future<Either<AuthFailure, AuthTokens>> login(
    String email,
    String password,
  ) async {
    try {
      final tokens = await _authService.login(email, password);
      return Right(tokens);
    } on DioException catch (e, stackTrace) {
      return Left(_mapDioError(e, stackTrace));
    } catch (e, stackTrace) {
      _log.severe('Unexpected login error', e, stackTrace);
      return Left(const UnexpectedFailure());
    }
  }

  /// Try to retrieve a stored, non-expired access token.
  Future<Either<AuthFailure, String>> tryGetStoredToken() async {
    try {
      final token = await _authService.getStoredAccessToken();
      if (token != null && !JwtDecode.isExpired(token)) {
        return Right(token);
      }
      return Left(UnexpectedFailure('No valid stored token'));
    } catch (e, stackTrace) {
      _log.warning('Failed to retrieve stored token', e, stackTrace);
      return Left(const UnexpectedFailure());
    }
  }

  /// Try to auto-login using saved credentials.
  Future<Either<AuthFailure, AuthTokens>> tryAutoLogin() async {
    try {
      final creds = await _authService.getSavedCredentials();
      if (creds.email == null || creds.password == null) {
        return Left(UnexpectedFailure('No saved credentials'));
      }
      return login(creds.email!, creds.password!);
    } catch (e, stackTrace) {
      _log.warning('Auto-login failed', e, stackTrace);
      return Left(const UnexpectedFailure());
    }
  }

  /// Try to refresh the access token using the stored refresh token.
  Future<Either<AuthFailure, String>> tryRefreshToken() async {
    try {
      final refreshToken = await _authService.getStoredRefreshToken();
      if (refreshToken == null) {
        return Left(UnexpectedFailure('No refresh token'));
      }
      final newAccess =
          await _authService.refreshAccessToken(refreshToken);
      return Right(newAccess);
    } on DioException catch (e, stackTrace) {
      return Left(_mapDioError(e, stackTrace));
    } catch (e, stackTrace) {
      _log.warning('Token refresh failed', e, stackTrace);
      return Left(const UnexpectedFailure());
    }
  }

  /// Clear stored tokens.
  Future<Either<AuthFailure, Unit>> logout() async {
    try {
      await _authService.logout();
      return const Right(unit);
    } catch (e, stackTrace) {
      _log.severe('Logout failed', e, stackTrace);
      return Left(const UnexpectedFailure());
    }
  }

  /// Persist credentials for auto-login.
  Future<Either<AuthFailure, Unit>> saveCredentials(
    String email,
    String password,
  ) async {
    try {
      await _authService.saveCredentials(email, password);
      return const Right(unit);
    } catch (e, stackTrace) {
      _log.warning('Failed to save credentials', e, stackTrace);
      return Left(const UnexpectedFailure());
    }
  }

  /// Remove persisted credentials.
  Future<Either<AuthFailure, Unit>> clearSavedCredentials() async {
    try {
      await _authService.clearSavedCredentials();
      return const Right(unit);
    } catch (e, stackTrace) {
      _log.warning('Failed to clear credentials', e, stackTrace);
      return Left(const UnexpectedFailure());
    }
  }

  AuthFailure _mapDioError(DioException e, StackTrace stackTrace) {
    if (e.response?.statusCode == 401) {
      _log.warning('Login failed: invalid credentials', e, stackTrace);
      return const InvalidCredentialsFailure();
    }
    _log.severe('Login failed: server error', e, stackTrace);
    return const ServerFailure();
  }
}
