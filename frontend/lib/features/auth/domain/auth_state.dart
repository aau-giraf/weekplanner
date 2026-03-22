import 'package:equatable/equatable.dart';

/// Authentication state managed by [AuthCubit].
sealed class AuthState extends Equatable {
  const AuthState();
}

/// Initial state before session restore has completed.
final class AuthUnknown extends AuthState {
  const AuthUnknown();

  @override
  List<Object?> get props => [];
}

/// The user is authenticated with a valid token.
final class AuthAuthenticated extends AuthState {
  /// The JWT access token.
  final String accessToken;

  /// The user ID extracted from the JWT.
  final String userId;

  /// Organisation ID → role mapping from the JWT.
  final Map<String, String> orgRoles;

  const AuthAuthenticated({
    required this.accessToken,
    required this.userId,
    required this.orgRoles,
  });

  @override
  List<Object?> get props => [accessToken, userId, orgRoles];
}

/// The user is not authenticated.
final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();

  @override
  List<Object?> get props => [];
}
