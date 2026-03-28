import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weekplanner/shared/services/token_consumer.dart';
import 'package:weekplanner/shared/services/token_manager.dart';

class MockTokenConsumer extends Mock implements TokenConsumer {}

void main() {
  group('TokenManager', () {
    test('setToken calls setAuthToken on all consumers', () {
      final consumer1 = MockTokenConsumer();
      final consumer2 = MockTokenConsumer();
      final manager = TokenManager(consumers: [consumer1, consumer2]);

      manager.setToken('test-token');

      verify(() => consumer1.setAuthToken('test-token')).called(1);
      verify(() => consumer2.setAuthToken('test-token')).called(1);
    });

    test('clearToken calls clearAuthToken on all consumers', () {
      final consumer1 = MockTokenConsumer();
      final consumer2 = MockTokenConsumer();
      final manager = TokenManager(consumers: [consumer1, consumer2]);

      manager.clearToken();

      verify(() => consumer1.clearAuthToken()).called(1);
      verify(() => consumer2.clearAuthToken()).called(1);
    });

    test('works with empty consumer list', () {
      final manager = TokenManager(consumers: []);

      // Should not throw
      manager.setToken('test-token');
      manager.clearToken();
    });
  });
}
