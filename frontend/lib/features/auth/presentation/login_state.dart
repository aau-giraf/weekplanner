import 'package:equatable/equatable.dart';

/// State for the login form managed by [LoginCubit].
sealed class LoginState extends Equatable {
  /// Current email field value.
  final String email;

  /// Current password field value.
  final String password;

  /// Whether the user wants credentials remembered.
  final bool rememberMe;

  const LoginState({
    this.email = '',
    this.password = '',
    this.rememberMe = false,
  });

  @override
  List<Object?> get props => [email, password, rememberMe];
}

/// Initial idle state — the form is ready for input.
final class LoginInitial extends LoginState {
  const LoginInitial({
    super.email,
    super.password,
    super.rememberMe,
  });
}

/// A login request is in progress.
final class LoginLoading extends LoginState {
  const LoginLoading({
    required super.email,
    required super.password,
    required super.rememberMe,
  });
}

/// Login completed successfully.
final class LoginSuccess extends LoginState {
  const LoginSuccess({
    required super.email,
    required super.password,
    required super.rememberMe,
  });
}

/// Login failed with an error message.
final class LoginFailure extends LoginState {
  /// Human-readable error message.
  final String message;

  const LoginFailure({
    required this.message,
    required super.email,
    required super.password,
    required super.rememberMe,
  });

  @override
  List<Object?> get props => [message, ...super.props];
}
