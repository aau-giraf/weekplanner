import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Runtime API configuration.
///
/// On web: reads from `config.json` at the web root (edit `web/config.json`
/// to change endpoints — no recompile needed).
/// On mobile: uses `--dart-define` overrides or falls back to emulator-friendly
/// defaults.
///
/// Call [ApiConfig.load] once before accessing [coreBaseUrl] or
/// [weekplannerBaseUrl].
class ApiConfig {
  static String _coreBaseUrl = '';
  static String _weekplannerBaseUrl = '';

  static String get coreBaseUrl => _coreBaseUrl;
  static String get weekplannerBaseUrl => _weekplannerBaseUrl;

  /// Load configuration. Must be called once at startup (in main).
  static Future<void> load() async {
    if (kIsWeb) {
      await _loadWebConfig();
    } else {
      _loadMobileConfig();
    }
  }

  static Future<void> _loadWebConfig() async {
    try {
      // Dio is already a dependency — use it to fetch the config served
      // alongside the app at the web root.
      final response = await Dio().get<String>('config.json');
      final config = jsonDecode(response.data!) as Map<String, dynamic>;
      _coreBaseUrl = config['coreBaseUrl'] as String? ?? 'http://localhost:8000';
      _weekplannerBaseUrl =
          config['weekplannerBaseUrl'] as String? ?? 'http://localhost:5171';
    } catch (_) {
      _coreBaseUrl = 'http://localhost:8000';
      _weekplannerBaseUrl = 'http://localhost:5171';
    }
  }

  static void _loadMobileConfig() {
    const coreEnv = String.fromEnvironment('CORE_BASE_URL');
    const wpEnv = String.fromEnvironment('WEEKPLANNER_BASE_URL');
    _coreBaseUrl =
        coreEnv.isNotEmpty ? coreEnv : 'http://10.0.2.2:8000';
    _weekplannerBaseUrl =
        wpEnv.isNotEmpty ? wpEnv : 'http://10.0.2.2:5171';
  }
}
