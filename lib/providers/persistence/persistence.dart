/// Persistence for application.
abstract class Persistence {
  /// Get the currently stored token
  ///
  /// returns `null` if not set
  Future<String> getToken();

  /// Sets the token to be used
  Future<void> setToken(String token);

  /// Removes the currently used token, i.e sets token to `null`
  Future<void> removeToken();
}
