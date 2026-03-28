import 'package:weekplanner/shared/services/token_consumer.dart';

/// Distributes auth tokens to all registered [TokenConsumer]s.
///
/// Decouples [AuthCubit] from knowing which services need tokens.
/// New services only need to be added to the consumer list, satisfying OCP.
class TokenManager {
  final List<TokenConsumer> _consumers;

  TokenManager({required List<TokenConsumer> consumers})
      : _consumers = List.unmodifiable(consumers);

  /// Set the auth token on all registered consumers.
  void setToken(String token) {
    for (final consumer in _consumers) {
      consumer.setAuthToken(token);
    }
  }

  /// Clear the auth token from all registered consumers.
  void clearToken() {
    for (final consumer in _consumers) {
      consumer.clearAuthToken();
    }
  }
}
