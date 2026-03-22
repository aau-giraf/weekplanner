/// Typed failures for authentication operations.
sealed class AuthFailure {
  /// Human-readable error message.
  final String message;

  const AuthFailure(this.message);
}

/// Login failed due to invalid email or password.
final class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure()
      : super('Forkert brugernavn eller adgangskode');
}

/// The server could not be reached.
final class ServerFailure extends AuthFailure {
  const ServerFailure() : super('Kunne ikke oprette forbindelse til serveren');
}

/// An unexpected error occurred.
final class UnexpectedFailure extends AuthFailure {
  const UnexpectedFailure(
      [super.message = 'Der opstod en uventet fejl']);
}
