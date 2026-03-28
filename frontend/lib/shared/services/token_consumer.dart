/// Contract for any service that needs an auth token.
abstract interface class TokenConsumer {
  /// Apply the given JWT [token] for authenticated requests.
  void setAuthToken(String token);

  /// Remove the current auth token.
  void clearAuthToken();
}
