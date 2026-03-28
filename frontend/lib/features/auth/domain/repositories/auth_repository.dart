import 'package:fpdart/fpdart.dart';

import 'package:weekplanner/core/errors/auth_failure.dart';
import 'package:weekplanner/shared/models/auth_tokens.dart';

/// Contract for authentication data operations.
abstract class AuthRepository {
  Future<Either<AuthFailure, AuthTokens>> login(String email, String password);
  Future<Either<AuthFailure, String>> tryGetStoredToken();
  Future<Either<AuthFailure, AuthTokens>> tryAutoLogin();
  Future<Either<AuthFailure, String>> tryRefreshToken();
  Future<Either<AuthFailure, Unit>> logout();
  Future<Either<AuthFailure, Unit>> saveCredentials(
    String email,
    String password,
  );
  Future<Either<AuthFailure, Unit>> clearSavedCredentials();
}
