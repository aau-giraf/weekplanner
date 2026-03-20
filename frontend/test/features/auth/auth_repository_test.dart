import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weekplanner/features/auth/data/repositories/auth_repository.dart';
import 'package:weekplanner/shared/services/activity_api_service.dart';
import 'package:weekplanner/shared/services/auth_service.dart';
import 'package:weekplanner/shared/services/core_api_service.dart';

@GenerateNiceMocks([
  MockSpec<AuthService>(),
  MockSpec<CoreApiService>(),
  MockSpec<ActivityApiService>(),
])
import 'auth_repository_test.mocks.dart';

String _createValidJwt() {
  final header = base64Url.encode(utf8.encode('{"alg":"HS256","typ":"JWT"}'));
  final payload = base64Url.encode(utf8.encode(json.encode({
    'user_id': '42',
    'org_roles': {'1': 'admin'},
    'exp': DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000,
  })));
  return '$header.$payload.sig';
}

void main() {
  late MockAuthService mockAuthService;
  late MockCoreApiService mockCoreApi;
  late MockActivityApiService mockActivityApi;
  late AuthRepository repo;

  setUp(() {
    mockAuthService = MockAuthService();
    mockCoreApi = MockCoreApiService();
    mockActivityApi = MockActivityApiService();
    repo = AuthRepository(
      authService: mockAuthService,
      coreApiService: mockCoreApi,
      activityApiService: mockActivityApi,
    );
  });

  group('AuthRepository', () {
    test('initial state is unknown', () {
      expect(repo.state, AuthState.unknown);
      expect(repo.isAuthenticated, false);
    });

    test('login sets state to authenticated', () async {
      final token = _createValidJwt();
      when(mockAuthService.login(any, any)).thenAnswer(
        (_) async => AuthTokens(access: token, refresh: 'refresh', orgRoles: {'1': 'admin'}),
      );

      await repo.login('test@test.com', 'pass');

      expect(repo.state, AuthState.authenticated);
      expect(repo.isAuthenticated, true);
      expect(repo.userId, '42');
      expect(repo.orgRoles, {'1': 'admin'});
      verify(mockCoreApi.setAuthToken(token)).called(1);
      verify(mockActivityApi.setAuthToken(token)).called(1);
    });

    test('logout clears state', () async {
      // First login
      final token = _createValidJwt();
      when(mockAuthService.login(any, any)).thenAnswer(
        (_) async => AuthTokens(access: token, refresh: 'refresh', orgRoles: {}),
      );
      await repo.login('test@test.com', 'pass');

      // Then logout
      when(mockAuthService.logout()).thenAnswer((_) async {});
      await repo.logout();

      expect(repo.state, AuthState.unauthenticated);
      expect(repo.isAuthenticated, false);
      expect(repo.userId, null);
      verify(mockCoreApi.clearAuthToken()).called(1);
      verify(mockActivityApi.clearAuthToken()).called(1);
    });

    test('tryRestoreSession restores from valid stored token', () async {
      final token = _createValidJwt();
      when(mockAuthService.getStoredAccessToken()).thenAnswer((_) async => token);

      await repo.tryRestoreSession();

      expect(repo.state, AuthState.authenticated);
      expect(repo.userId, '42');
    });

    test('tryRestoreSession falls back to unauthenticated with no credentials', () async {
      when(mockAuthService.getStoredAccessToken()).thenAnswer((_) async => null);
      when(mockAuthService.getSavedCredentials())
          .thenAnswer((_) async => (email: null, password: null));

      await repo.tryRestoreSession();

      expect(repo.state, AuthState.unauthenticated);
    });

    test('notifies listeners on state change', () async {
      int notifyCount = 0;
      repo.addListener(() => notifyCount++);

      final token = _createValidJwt();
      when(mockAuthService.login(any, any)).thenAnswer(
        (_) async => AuthTokens(access: token, refresh: 'refresh', orgRoles: {}),
      );
      await repo.login('test@test.com', 'pass');

      expect(notifyCount, greaterThan(0));
    });
  });
}
