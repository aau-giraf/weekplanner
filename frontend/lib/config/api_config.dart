import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  static const String _coreEnv =
      String.fromEnvironment('CORE_BASE_URL');
  static const String _weekplannerEnv =
      String.fromEnvironment('WEEKPLANNER_BASE_URL');

  static String get coreBaseUrl =>
      _coreEnv.isNotEmpty ? _coreEnv : _defaultHost(8000);
  static String get weekplannerBaseUrl =>
      _weekplannerEnv.isNotEmpty ? _weekplannerEnv : _defaultHost(5171);

  /// On web, localhost is reachable directly.
  /// On Android emulator, 10.0.2.2 maps to the host machine's localhost.
  static String _defaultHost(int port) =>
      kIsWeb ? 'http://localhost:$port' : 'http://10.0.2.2:$port';
}
