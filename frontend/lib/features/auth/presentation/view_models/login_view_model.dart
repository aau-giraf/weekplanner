import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:weekplanner/features/auth/data/repositories/auth_repository.dart';

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
      _error = 'Udfyld venligst email og adgangskode';
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
    } on DioException catch (e) {
      _isLoading = false;
      if (e.response?.statusCode == 401) {
        _error = 'Forkert email eller adgangskode';
      } else {
        _error = 'Kunne ikke oprette forbindelse til serveren';
      }
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _error = 'Der opstod en uventet fejl';
      notifyListeners();
      return false;
    }
  }
}
