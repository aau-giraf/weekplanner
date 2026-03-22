import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weekplanner/core/errors/auth_failure.dart';
import 'package:weekplanner/features/auth/data/repositories/auth_repository.dart';
import 'package:weekplanner/features/auth/domain/auth_state.dart';
import 'package:weekplanner/features/auth/presentation/auth_cubit.dart';
import 'package:weekplanner/features/auth/presentation/login_cubit.dart';
import 'package:weekplanner/features/auth/presentation/login_state.dart';
import 'package:weekplanner/shared/services/auth_service.dart';

import '../../helpers/jwt_test_helper.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

void main() {
  late MockAuthRepository mockRepo;
  late MockAuthCubit mockAuthCubit;

  setUp(() {
    mockRepo = MockAuthRepository();
    mockAuthCubit = MockAuthCubit();
  });

  LoginCubit buildCubit() => LoginCubit(
        authRepository: mockRepo,
        authCubit: mockAuthCubit,
      );

  group('emailChanged', () {
    blocTest<LoginCubit, LoginState>(
      'emits LoginInitial with updated email',
      build: buildCubit,
      act: (cubit) => cubit.emailChanged('test@example.com'),
      expect: () => [
        const LoginInitial(email: 'test@example.com'),
      ],
    );
  });

  group('passwordChanged', () {
    blocTest<LoginCubit, LoginState>(
      'emits LoginInitial with updated password',
      build: buildCubit,
      act: (cubit) => cubit.passwordChanged('secret'),
      expect: () => [
        const LoginInitial(password: 'secret'),
      ],
    );
  });

  group('rememberMeChanged', () {
    blocTest<LoginCubit, LoginState>(
      'emits LoginInitial with updated rememberMe',
      build: buildCubit,
      act: (cubit) => cubit.rememberMeChanged(true),
      expect: () => [
        const LoginInitial(rememberMe: true),
      ],
    );
  });

  group('loginSubmitted', () {
    blocTest<LoginCubit, LoginState>(
      'emits LoginFailure when email is empty',
      build: buildCubit,
      seed: () => const LoginInitial(password: 'pass'),
      act: (cubit) => cubit.loginSubmitted(),
      expect: () => [
        isA<LoginFailure>().having(
          (s) => s.message,
          'message',
          contains('Udfyld'),
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits LoginFailure when password is empty',
      build: buildCubit,
      seed: () => const LoginInitial(email: 'test@example.com'),
      act: (cubit) => cubit.loginSubmitted(),
      expect: () => [
        isA<LoginFailure>().having(
          (s) => s.message,
          'message',
          contains('Udfyld'),
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits [LoginLoading, LoginSuccess] on successful login',
      setUp: () {
        final token = createValidJwt();
        when(() => mockRepo.login(any(), any())).thenAnswer(
          (_) async => Right(
              AuthTokens(access: token, refresh: 'refresh', orgRoles: {})),
        );
        when(() => mockRepo.clearSavedCredentials())
            .thenAnswer((_) async => const Right(unit));
        when(() => mockAuthCubit.authenticated(any())).thenReturn(null);
      },
      build: buildCubit,
      seed: () => const LoginInitial(
        email: 'test@example.com',
        password: 'password',
      ),
      act: (cubit) => cubit.loginSubmitted(),
      expect: () => [
        isA<LoginLoading>(),
        isA<LoginSuccess>(),
      ],
      verify: (_) {
        verify(() => mockRepo.login('test@example.com', 'password')).called(1);
        verify(() => mockAuthCubit.authenticated(any())).called(1);
        verify(() => mockRepo.clearSavedCredentials()).called(1);
      },
    );

    blocTest<LoginCubit, LoginState>(
      'saves credentials when rememberMe is true',
      setUp: () {
        final token = createValidJwt();
        when(() => mockRepo.login(any(), any())).thenAnswer(
          (_) async => Right(
              AuthTokens(access: token, refresh: 'refresh', orgRoles: {})),
        );
        when(() => mockRepo.saveCredentials(any(), any()))
            .thenAnswer((_) async => const Right(unit));
        when(() => mockAuthCubit.authenticated(any())).thenReturn(null);
      },
      build: buildCubit,
      seed: () => const LoginInitial(
        email: 'test@example.com',
        password: 'password',
        rememberMe: true,
      ),
      act: (cubit) => cubit.loginSubmitted(),
      expect: () => [
        isA<LoginLoading>(),
        isA<LoginSuccess>(),
      ],
      verify: (_) {
        verify(() =>
                mockRepo.saveCredentials('test@example.com', 'password'))
            .called(1);
      },
    );

    blocTest<LoginCubit, LoginState>(
      'emits LoginFailure with credential error on InvalidCredentialsFailure',
      setUp: () {
        when(() => mockRepo.login(any(), any())).thenAnswer(
          (_) async => Left(const InvalidCredentialsFailure()),
        );
      },
      build: buildCubit,
      seed: () => const LoginInitial(
        email: 'test@example.com',
        password: 'wrong',
      ),
      act: (cubit) => cubit.loginSubmitted(),
      expect: () => [
        isA<LoginLoading>(),
        isA<LoginFailure>().having(
          (s) => s.message,
          'message',
          contains('Forkert'),
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits LoginFailure with server error on ServerFailure',
      setUp: () {
        when(() => mockRepo.login(any(), any())).thenAnswer(
          (_) async => Left(const ServerFailure()),
        );
      },
      build: buildCubit,
      seed: () => const LoginInitial(
        email: 'test@example.com',
        password: 'password',
      ),
      act: (cubit) => cubit.loginSubmitted(),
      expect: () => [
        isA<LoginLoading>(),
        isA<LoginFailure>().having(
          (s) => s.message,
          'message',
          contains('forbindelse'),
        ),
      ],
    );
  });
}
