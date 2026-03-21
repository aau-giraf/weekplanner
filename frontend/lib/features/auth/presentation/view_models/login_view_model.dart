import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:weekplanner/features/auth/data/repositories/auth_repository.dart';
import 'package:weekplanner/shared/presentation/async_command.dart';

final _log = Logger('LoginViewModel');

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final AsyncCommand _loginCommand = AsyncCommand();

  LoginViewModel({required AuthRepository authRepository})
      : _authRepository = authRepository {
    _loginCommand.addListener(notifyListeners);
  }

  String _email = '';
  String _password = '';
  bool _rememberMe = false;
  String? _error;

  String get email => _email;
  String get password => _password;
  bool get rememberMe => _rememberMe;
  bool get isLoading => _loginCommand.isRunning;
  String? get error => _error;

  void setEmail(String value) {
    _email = value;
    _error = null;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    _error = null;
    notifyListeners();
  }

  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  Future<bool> login() async {
    if (_email.isEmpty || _password.isEmpty) {
      _error = 'Udfyld venligst brugernavn og adgangskode';
      notifyListeners();
      return false;
    }

    _error = null;
    notifyListeners();

    final success = await _loginCommand.run<bool>(
      () async {
        await _authRepository.login(_email, _password);
        if (_rememberMe) {
          await _authRepository.saveCredentials(_email, _password);
        } else {
          await _authRepository.clearSavedCredentials();
        }
        return true;
      },
      onError: (error, stackTrace) {
        if (error is DioException) {
          if (error.response?.statusCode == 401) {
            _log.warning('Login failed: invalid credentials', error, stackTrace);
            _error = 'Forkert brugernavn eller adgangskode';
          } else {
            _log.severe('Login failed: server error', error, stackTrace);
            _error = 'Kunne ikke oprette forbindelse til serveren';
          }
          return;
        }

        _log.severe('Login failed: unexpected error', error, stackTrace);
        _error = 'Der opstod en uventet fejl';
      },
    );

    return success ?? false;
  }

  @override
  void dispose() {
    _loginCommand.removeListener(notifyListeners);
    _loginCommand.dispose();
    super.dispose();
  }
}
