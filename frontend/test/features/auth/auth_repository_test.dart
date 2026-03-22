import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weekplanner/core/errors/auth_failure.dart';
import 'package:weekplanner/features/auth/data/repositories/auth_repository.dart';
import 'package:weekplanner/shared/services/auth_service.dart';

import '../../helpers/jwt_test_helper.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockAuthService mockAuthService;
  late AuthRepository repo;

  setUp(() {
    mockAuthService = MockAuthService();
    repo = AuthRepository(authService: mockAuthService);
  });

  group('login', () {
    test('returns Right with tokens on success', () async {
      final token = createValidJwt();
      when(() => mockAuthService.login(any(), any())).thenAnswer(
        (_) async =>
            AuthTokens(access: token, refresh: 'refresh', orgRoles: {}),
      );

      final result = await repo.login('test@test.com', 'pass');

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (tokens) => expect(tokens.access, token),
      );
    });

    test('returns InvalidCredentialsFailure on 401', () async {
      when(() => mockAuthService.login(any(), any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          response: Response(requestOptions: RequestOptions(), statusCode: 401),
        ),
      );

      final result = await repo.login('test@test.com', 'wrong');

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<InvalidCredentialsFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns ServerFailure on other DioException', () async {
      when(() => mockAuthService.login(any(), any())).thenThrow(
        DioException(requestOptions: RequestOptions()),
      );

      final result = await repo.login('test@test.com', 'pass');

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns UnexpectedFailure on non-Dio exception', () async {
      when(() => mockAuthService.login(any(), any()))
          .thenThrow(Exception('boom'));

      final result = await repo.login('test@test.com', 'pass');

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<UnexpectedFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  group('tryGetStoredToken', () {
    test('returns Right with valid stored token', () async {
      final token = createValidJwt();
      when(() => mockAuthService.getStoredAccessToken())
          .thenAnswer((_) async => token);

      final result = await repo.tryGetStoredToken();

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (t) => expect(t, token),
      );
    });

    test('returns Left when no stored token', () async {
      when(() => mockAuthService.getStoredAccessToken())
          .thenAnswer((_) async => null);

      final result = await repo.tryGetStoredToken();

      expect(result.isLeft(), true);
    });

    test('returns Left when stored token is expired', () async {
      final expired = createExpiredJwt();
      when(() => mockAuthService.getStoredAccessToken())
          .thenAnswer((_) async => expired);

      final result = await repo.tryGetStoredToken();

      expect(result.isLeft(), true);
    });
  });

  group('tryAutoLogin', () {
    test('returns Right when saved credentials are valid', () async {
      final token = createValidJwt();
      when(() => mockAuthService.getSavedCredentials())
          .thenAnswer((_) async => (email: 'a@b.com', password: 'pass'));
      when(() => mockAuthService.login(any(), any())).thenAnswer(
        (_) async =>
            AuthTokens(access: token, refresh: 'refresh', orgRoles: {}),
      );

      final result = await repo.tryAutoLogin();

      expect(result.isRight(), true);
    });

    test('returns Left when no saved credentials', () async {
      when(() => mockAuthService.getSavedCredentials())
          .thenAnswer((_) async => (email: null, password: null));

      final result = await repo.tryAutoLogin();

      expect(result.isLeft(), true);
    });
  });

  group('logout', () {
    test('returns Right on success', () async {
      when(() => mockAuthService.logout()).thenAnswer((_) async {});

      final result = await repo.logout();

      expect(result, const Right<AuthFailure, Unit>(unit));
      verify(() => mockAuthService.logout()).called(1);
    });
  });

  group('saveCredentials', () {
    test('returns Right on success', () async {
      when(() => mockAuthService.saveCredentials(any(), any()))
          .thenAnswer((_) async {});

      final result = await repo.saveCredentials('a@b.com', 'pass');

      expect(result, const Right<AuthFailure, Unit>(unit));
    });
  });

  group('clearSavedCredentials', () {
    test('returns Right on success', () async {
      when(() => mockAuthService.clearSavedCredentials())
          .thenAnswer((_) async {});

      final result = await repo.clearSavedCredentials();

      expect(result, const Right<AuthFailure, Unit>(unit));
    });
  });
}
