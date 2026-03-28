import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weekplanner/core/errors/auth_failure.dart';
import 'package:weekplanner/features/auth/data/repositories/auth_repository.dart';
import 'package:weekplanner/features/auth/domain/auth_state.dart';
import 'package:weekplanner/features/auth/presentation/auth_cubit.dart';
import 'package:weekplanner/shared/services/activity_api_service.dart';
import 'package:weekplanner/shared/services/auth_service.dart';
import 'package:weekplanner/shared/services/core_api_service.dart';

import '../../helpers/jwt_test_helper.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockCoreApiService extends Mock implements CoreApiService {}

class MockActivityApiService extends Mock implements ActivityApiService {}

void main() {
  late MockAuthRepository mockRepo;
  late MockCoreApiService mockCoreApi;
  late MockActivityApiService mockActivityApi;

  setUp(() {
    mockRepo = MockAuthRepository();
    mockCoreApi = MockCoreApiService();
    mockActivityApi = MockActivityApiService();
  });

  AuthCubit buildCubit() => AuthCubit(
        repository: mockRepo,
        coreApiService: mockCoreApi,
        activityApiService: mockActivityApi,
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
        when(() => mockCoreApi.setAuthToken(any())).thenReturn(null);
        when(() => mockActivityApi.setAuthToken(any())).thenReturn(null);
      },
      build: buildCubit,
      act: (cubit) => cubit.tryRestoreSession(),
      expect: () => [isA<AuthAuthenticated>()],
      verify: (_) {
        verify(() => mockCoreApi.setAuthToken(any())).called(1);
        verify(() => mockActivityApi.setAuthToken(any())).called(1);
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
        when(() => mockCoreApi.setAuthToken(any())).thenReturn(null);
        when(() => mockActivityApi.setAuthToken(any())).thenReturn(null);
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
        when(() => mockCoreApi.setAuthToken(any())).thenReturn(null);
        when(() => mockActivityApi.setAuthToken(any())).thenReturn(null);
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
      'emits AuthAuthenticated and distributes token',
      setUp: () {
        when(() => mockCoreApi.setAuthToken(any())).thenReturn(null);
        when(() => mockActivityApi.setAuthToken(any())).thenReturn(null);
      },
      build: buildCubit,
      act: (cubit) => cubit.authenticated(createValidJwt()),
      expect: () => [
        isA<AuthAuthenticated>()
            .having((s) => s.userId, 'userId', '42')
            .having((s) => s.orgRoles, 'orgRoles', {'1': 'admin'}),
      ],
      verify: (_) {
        verify(() => mockCoreApi.setAuthToken(any())).called(1);
        verify(() => mockActivityApi.setAuthToken(any())).called(1);
      },
    );
  });

  group('logout', () {
    blocTest<AuthCubit, AuthState>(
      'emits AuthUnauthenticated and clears tokens',
      setUp: () {
        when(() => mockRepo.logout())
            .thenAnswer((_) async => const Right(unit));
        when(() => mockCoreApi.setAuthToken(any())).thenReturn(null);
        when(() => mockActivityApi.setAuthToken(any())).thenReturn(null);
        when(() => mockCoreApi.clearAuthToken()).thenReturn(null);
        when(() => mockActivityApi.clearAuthToken()).thenReturn(null);
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
        verify(() => mockCoreApi.clearAuthToken()).called(1);
        verify(() => mockActivityApi.clearAuthToken()).called(1);
      },
    );
  });
}
