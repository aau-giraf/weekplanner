import 'package:flutter_test/flutter_test.dart';

import 'package:weekplanner/config/api_config.dart';

void main() {
  group('ApiConfig', () {
    test('load sets emulator defaults on mobile (no dart-define)', () async {
      // On non-web platform with no --dart-define overrides,
      // load() should fall back to Android emulator defaults.
      await ApiConfig.load();

      expect(ApiConfig.coreBaseUrl, 'http://10.0.2.2:8000');
      expect(ApiConfig.weekplannerBaseUrl, 'http://10.0.2.2:5171');
    });
  });
}
