import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:weekplanner/config/api_config.dart';

class AuthTokens {
  final String access;
  final String refresh;
  final Map<String, String> orgRoles;

  const AuthTokens({
    required this.access,
    required this.refresh,
    required this.orgRoles,
  });
}

class AuthService {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';
  static const _emailKey = 'saved_email';
  static const _passwordKey = 'saved_password';

  AuthService({Dio? dio, FlutterSecureStorage? storage})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiConfig.coreBaseUrl)),
        _storage = storage ?? const FlutterSecureStorage();

  Future<AuthTokens> login(String email, String password) async {
    final response = await _dio.post(
      '/token/pair',
      data: {'email': email, 'password': password},
    );
    final data = response.data as Map<String, dynamic>;
    final tokens = AuthTokens(
      access: data['access'] as String,
      refresh: data['refresh'] as String,
      orgRoles: (data['org_roles'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v.toString())) ??
          {},
    );
    await _storage.write(key: _accessKey, value: tokens.access);
    await _storage.write(key: _refreshKey, value: tokens.refresh);
    return tokens;
  }

  Future<void> logout() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }

  Future<String?> getStoredAccessToken() => _storage.read(key: _accessKey);
  Future<String?> getStoredRefreshToken() => _storage.read(key: _refreshKey);

  Future<void> saveCredentials(String email, String password) async {
    await _storage.write(key: _emailKey, value: email);
    await _storage.write(key: _passwordKey, value: password);
  }

  Future<({String? email, String? password})> getSavedCredentials() async {
    final email = await _storage.read(key: _emailKey);
    final password = await _storage.read(key: _passwordKey);
    return (email: email, password: password);
  }

  Future<void> clearSavedCredentials() async {
    await _storage.delete(key: _emailKey);
    await _storage.delete(key: _passwordKey);
  }
}
