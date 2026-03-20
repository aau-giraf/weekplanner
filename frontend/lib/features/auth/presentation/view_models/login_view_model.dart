import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:weekplanner/features/auth/data/repositories/auth_repository.dart';

final _log = Logger('LoginViewModel');

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  LoginViewModel({required AuthRepository authRepository})
      : _authRepository = authRepository;

  String _email = '';
  String _password = '';
  bool _rememberMe = false;
  bool _isLoading = false;
  String? _error;

  String get email => _email;
  String get password => _password;
  bool get rememberMe => _rememberMe;
  bool get isLoading => _isLoading;
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

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authRepository.login(_email, _password);
      if (_rememberMe) {
        await _authRepository.saveCredentials(_email, _password);
      } else {
        await _authRepository.clearSavedCredentials();
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } on DioException catch (e, stackTrace) {
      _isLoading = false;
      if (e.response?.statusCode == 401) {
        _log.warning('Login failed: invalid credentials', e, stackTrace);
        _error = 'Forkert brugernavn eller adgangskode';
      } else {
        _log.severe('Login failed: server error', e, stackTrace);
        _error = 'Kunne ikke oprette forbindelse til serveren';
      }
      notifyListeners();
      return false;
    } catch (e, stackTrace) {
      _isLoading = false;
      _log.severe('Login failed: unexpected error', e, stackTrace);
      _error = 'Der opstod en uventet fejl';
      notifyListeners();
      return false;
    }
  }
}
