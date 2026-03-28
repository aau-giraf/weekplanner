import 'package:fpdart/fpdart.dart';

import 'package:weekplanner/core/errors/auth_failure.dart';
import 'package:weekplanner/shared/models/auth_tokens.dart';

/// Contract for authentication data operations.
abstract interface class AuthRepository {
  /// Authenticate with [email] and [password].
  Future<Either<AuthFailure, AuthTokens>> login(String email, String password);

  /// Try to retrieve a stored, non-expired access token.
  Future<Either<AuthFailure, String>> tryGetStoredToken();

  /// Try to auto-login using saved credentials.
  Future<Either<AuthFailure, AuthTokens>> tryAutoLogin();

  /// Try to refresh the access token using the stored refresh token.
  Future<Either<AuthFailure, String>> tryRefreshToken();

  /// Clear stored tokens.
  Future<Either<AuthFailure, Unit>> logout();

  /// Persist credentials for auto-login.
  Future<Either<AuthFailure, Unit>> saveCredentials(
    String email,
    String password,
  );

  /// Remove persisted credentials.
  Future<Either<AuthFailure, Unit>> clearSavedCredentials();
}
