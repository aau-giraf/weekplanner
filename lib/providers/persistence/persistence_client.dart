import 'package:shared_preferences/shared_preferences.dart';
import 'package:weekplanner/providers/persistence/persistence.dart';

/// The key for which, in the SharedPreferences, the token is stored
const String tokenKey = 'token';

/// Provides persistence capabilities
class PersistenceClient implements Persistence {
  @override
  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  @override
  Future<void> setToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  @override
  Future<void> removeToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }
}
