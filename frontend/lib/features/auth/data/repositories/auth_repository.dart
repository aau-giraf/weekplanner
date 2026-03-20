import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:weekplanner/shared/services/auth_service.dart';
import 'package:weekplanner/shared/services/activity_api_service.dart';
import 'package:weekplanner/shared/services/core_api_service.dart';
import 'package:weekplanner/shared/utils/jwt_decode.dart';

final _log = Logger('AuthRepository');

enum AuthState { unknown, authenticated, unauthenticated }

class AuthRepository extends ChangeNotifier {
  final AuthService _authService;
  final CoreApiService _coreApiService;
  final ActivityApiService _activityApiService;

  AuthState _state = AuthState.unknown;
  String? _accessToken;
  String? _userId;
  Map<String, String> _orgRoles = {};

  AuthRepository({
    required AuthService authService,
    required CoreApiService coreApiService,
    required ActivityApiService activityApiService,
  })  : _authService = authService,
        _coreApiService = coreApiService,
        _activityApiService = activityApiService;

  AuthState get state => _state;
  String? get accessToken => _accessToken;
  String? get userId => _userId;
  Map<String, String> get orgRoles => _orgRoles;
  bool get isAuthenticated => _state == AuthState.authenticated;

  /// Try to restore session from stored token.
  Future<void> tryRestoreSession() async {
    final token = await _authService.getStoredAccessToken();
    if (token != null && !JwtDecode.isExpired(token)) {
      _setAuthenticated(token);
    } else {
      // Try auto-login with saved credentials
      final creds = await _authService.getSavedCredentials();
      if (creds.email != null && creds.password != null) {
        try {
          await login(creds.email!, creds.password!);
          return;
        } catch (e, stackTrace) {
          _log.warning('Auto-login failed', e, stackTrace);
        }
      }
      _state = AuthState.unauthenticated;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    final tokens = await _authService.login(email, password);
    _setAuthenticated(tokens.access);
  }

  Future<void> logout() async {
    await _authService.logout();
    _coreApiService.clearAuthToken();
    _activityApiService.clearAuthToken();
    _accessToken = null;
    _userId = null;
    _orgRoles = {};
    _state = AuthState.unauthenticated;
    notifyListeners();
  }

  Future<void> saveCredentials(String email, String password) =>
      _authService.saveCredentials(email, password);

  Future<void> clearSavedCredentials() => _authService.clearSavedCredentials();

  void _setAuthenticated(String token) {
    _accessToken = token;
    _userId = JwtDecode.getUserId(token);
    _orgRoles = JwtDecode.getOrgRoles(token);
    _coreApiService.setAuthToken(token);
    _activityApiService.setAuthToken(token);
    _state = AuthState.authenticated;
    notifyListeners();
  }
}
