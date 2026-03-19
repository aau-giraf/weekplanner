import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weekplanner/features/auth/data/repositories/auth_repository.dart';
import 'package:weekplanner/features/auth/presentation/view_models/login_view_model.dart';

@GenerateNiceMocks([MockSpec<AuthRepository>()])
import 'login_view_model_test.mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepo;
  late LoginViewModel vm;

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    vm = LoginViewModel(authRepository: mockAuthRepo);
  });

  group('LoginViewModel', () {
    test('initial state is correct', () {
      expect(vm.email, '');
      expect(vm.password, '');
      expect(vm.isLoading, false);
      expect(vm.error, null);
      expect(vm.rememberMe, false);
    });

    test('setEmail updates email and clears error', () {
      vm.setEmail('test@example.com');
      expect(vm.email, 'test@example.com');
    });

    test('setPassword updates password', () {
      vm.setPassword('secret');
      expect(vm.password, 'secret');
    });

    test('setRememberMe toggles remember me', () {
      vm.setRememberMe(true);
      expect(vm.rememberMe, true);
    });

    test('login returns false when fields are empty', () async {
      final result = await vm.login();
      expect(result, false);
      expect(vm.error, isNotNull);
    });

    test('login succeeds when repository login succeeds', () async {
      when(mockAuthRepo.login(any, any)).thenAnswer((_) async {});
      when(mockAuthRepo.clearSavedCredentials()).thenAnswer((_) async {});

      vm.setEmail('test@example.com');
      vm.setPassword('password');

      final result = await vm.login();
      expect(result, true);
      expect(vm.error, null);
      expect(vm.isLoading, false);

      verify(mockAuthRepo.login('test@example.com', 'password')).called(1);
    });

    test('login saves credentials when rememberMe is true', () async {
      when(mockAuthRepo.login(any, any)).thenAnswer((_) async {});
      when(mockAuthRepo.saveCredentials(any, any)).thenAnswer((_) async {});

      vm.setEmail('test@example.com');
      vm.setPassword('password');
      vm.setRememberMe(true);

      await vm.login();

      verify(mockAuthRepo.saveCredentials('test@example.com', 'password')).called(1);
    });

    test('login sets error on 401', () async {
      when(mockAuthRepo.login(any, any)).thenThrow(DioException(
        requestOptions: RequestOptions(),
        response: Response(
          requestOptions: RequestOptions(),
          statusCode: 401,
        ),
      ));

      vm.setEmail('test@example.com');
      vm.setPassword('wrong');

      final result = await vm.login();
      expect(result, false);
      expect(vm.error, contains('Forkert'));
    });

    test('login sets connection error on other DioException', () async {
      when(mockAuthRepo.login(any, any)).thenThrow(DioException(
        requestOptions: RequestOptions(),
      ));

      vm.setEmail('test@example.com');
      vm.setPassword('password');

      final result = await vm.login();
      expect(result, false);
      expect(vm.error, contains('forbindelse'));
    });
  });
}
