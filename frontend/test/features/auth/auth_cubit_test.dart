import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weekplanner/core/errors/auth_failure.dart';
import 'package:weekplanner/features/auth/domain/repositories/auth_repository.dart';
import 'package:weekplanner/features/auth/domain/auth_state.dart';
import 'package:weekplanner/features/auth/presentation/auth_cubit.dart';
import 'package:weekplanner/shared/models/auth_tokens.dart';
import 'package:weekplanner/shared/services/token_manager.dart';

import '../../helpers/jwt_test_helper.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockTokenManager extends Mock implements TokenManager {}

void main() {
  late MockAuthRepository mockRepo;
  late MockTokenManager mockTokenManager;

  setUp(() {
    mockRepo = MockAuthRepository();
    mockTokenManager = MockTokenManager();
  });

  AuthCubit buildCubit() => AuthCubit(
        repository: mockRepo,
        tokenManager: mockTokenManager,
      );

  group('initial state', () {
    test('is AuthUnknown', () {
      final cubit = buildCubit();
      expect(cubit.state, const AuthUnknown());
      expect(cubit.isAuthenticated, false);
      cubit.close();
    });
  });

  group('tryRestoreSession', () {
    blocTest<AuthCubit, AuthState>(
      'emits AuthAuthenticated when stored token is valid',
      setUp: () {
        final token = createValidJwt();
        when(() => mockRepo.tryGetStoredToken())
            .thenAnswer((_) async => Right(token));
        when(() => mockTokenManager.setToken(any())).thenReturn(null);
      },
      build: buildCubit,
      act: (cubit) => cubit.tryRestoreSession(),
      expect: () => [isA<AuthAuthenticated>()],
      verify: (_) {
        verify(() => mockTokenManager.setToken(any())).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'uses refresh token when stored access token is expired',
      setUp: () {
        final token = createValidJwt();
        when(() => mockRepo.tryGetStoredToken())
            .thenAnswer((_) async => Left(UnexpectedFailure()));
        when(() => mockRepo.tryRefreshToken())
            .thenAnswer((_) async => Right(token));
        when(() => mockTokenManager.setToken(any())).thenReturn(null);
      },
      build: buildCubit,
      act: (cubit) => cubit.tryRestoreSession(),
      expect: () => [isA<AuthAuthenticated>()],
      verify: (_) {
        verifyNever(() => mockRepo.tryAutoLogin());
      },
    );

    blocTest<AuthCubit, AuthState>(
      'falls back to auto-login when stored token and refresh both fail',
      setUp: () {
        final token = createValidJwt();
        when(() => mockRepo.tryGetStoredToken())
            .thenAnswer((_) async => Left(UnexpectedFailure()));
        when(() => mockRepo.tryRefreshToken())
            .thenAnswer((_) async => Left(UnexpectedFailure()));
        when(() => mockRepo.tryAutoLogin()).thenAnswer(
          (_) async => Right(
              AuthTokens(access: token, refresh: 'refresh', orgRoles: {})),
        );
        when(() => mockTokenManager.setToken(any())).thenReturn(null);
      },
      build: buildCubit,
      act: (cubit) => cubit.tryRestoreSession(),
      expect: () => [isA<AuthAuthenticated>()],
    );

    blocTest<AuthCubit, AuthState>(
      'emits AuthUnauthenticated when all three restore paths fail',
      setUp: () {
        when(() => mockRepo.tryGetStoredToken())
            .thenAnswer((_) async => Left(UnexpectedFailure()));
        when(() => mockRepo.tryRefreshToken())
            .thenAnswer((_) async => Left(UnexpectedFailure()));
        when(() => mockRepo.tryAutoLogin())
            .thenAnswer((_) async => Left(UnexpectedFailure()));
      },
      build: buildCubit,
      act: (cubit) => cubit.tryRestoreSession(),
      expect: () => [const AuthUnauthenticated()],
    );
  });

  group('authenticated', () {
    blocTest<AuthCubit, AuthState>(
      'emits AuthAuthenticated and distributes token via TokenManager',
      setUp: () {
        when(() => mockTokenManager.setToken(any())).thenReturn(null);
      },
      build: buildCubit,
      act: (cubit) => cubit.authenticated(createValidJwt()),
      expect: () => [
        isA<AuthAuthenticated>()
            .having((s) => s.userId, 'userId', '42')
            .having((s) => s.orgRoles, 'orgRoles', {'1': 'admin'}),
      ],
      verify: (_) {
        verify(() => mockTokenManager.setToken(any())).called(1);
      },
    );
  });

  group('logout', () {
    blocTest<AuthCubit, AuthState>(
      'emits AuthUnauthenticated and clears tokens via TokenManager',
      setUp: () {
        when(() => mockRepo.logout())
            .thenAnswer((_) async => const Right(unit));
        when(() => mockTokenManager.setToken(any())).thenReturn(null);
        when(() => mockTokenManager.clearToken()).thenReturn(null);
      },
      build: buildCubit,
      seed: () {
        final token = createValidJwt();
        return AuthAuthenticated(
          accessToken: token,
          userId: '42',
          orgRoles: const {'1': 'admin'},
        );
      },
      act: (cubit) => cubit.logout(),
      expect: () => [const AuthUnauthenticated()],
      verify: (_) {
        verify(() => mockRepo.logout()).called(1);
        verify(() => mockTokenManager.clearToken()).called(1);
      },
    );
  });
}
