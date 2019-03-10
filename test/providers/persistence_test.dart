import 'package:flutter/services.dart';
import 'package:test_api/test_api.dart';
import 'package:weekplanner/providers/peristence/persistence.dart';
import 'package:weekplanner/providers/peristence/persistence_client.dart';

void main() {
  test("Should store token", () async {
    const MethodChannel('plugins.flutter.io/shared_preferences')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return <String, dynamic>{}; // set initial values here if desired
      }

      if (methodCall.method == 'setString') {
        // pass here
        return null;
      }
      fail("Should call setString");
    });

    const token = "Test Token";

    Persistence persistence = PersistenceClient();
    await persistence.setToken(token);
  });

  test("Should get token", () async {
    const MethodChannel('plugins.flutter.io/shared_preferences')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return <String, dynamic>{}; // set initial values here if desired
      }

      if (methodCall.method == 'getString') {
        // pass here
        return null;
      }
      fail("Should call setString");
    });

    Persistence persistence = PersistenceClient();
    await persistence.getToken();
  });
}
