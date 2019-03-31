import 'package:weekplanner/providers/persistence/persistence.dart';

/// Mocking for the Persistence Provider
class PersistenceMock implements Persistence {
  String _token;

  @override
  Future<String> getToken() async {
    return _token;
  }

  @override
  Future<void> removeToken() async {
    _token = null;
  }

  @override
  Future<void> setToken(String token) async {
    _token = token;
  }

}