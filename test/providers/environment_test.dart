import 'package:test_api/test_api.dart';
import 'package:weekplanner/providers/environment_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:async_test/async_test.dart';

class MockEnvironment extends Mock implements Environment {}

void main() {
  setUp(() {});

  test("Should get SERVER_HOST from environment file (DEBUG)",
      async((DoneFn done) {
    Environment.setFile("assets/environments.json");
    expect(
        Environment.getVar("SERVER_HOST"), "http://web.giraf.cs.aau.dk:5000");
  }));

  test("Should get SERVER_HOST from environment file (PRODUCTION)",
      async((DoneFn done) {
    Environment.setFile("assets/environments.prod.json");
    expect(
        Environment.getVar("SERVER_HOST"), "http://web.giraf.cs.aau.dk:5000");
  }));

  test(
      "Should get DEBUG from environment file and it should be FALSE (PRODUCTION)",
      async((DoneFn done) {
    Environment.setFile("assets/environments.prod.json");
    expect(Environment.getVar("DEBUG"), false);
  }));

  test(
      "Should get USERNAME from environment file and it should be 'Graatand' (PRODUCTION)",
      async((DoneFn done) {
    Environment.setFile("assets/environments.json");
    expect(Environment.getVar("USERNAME"), "Graatand");
  }));

  test(
      "Should get PASSWORD from environment file and it should be 'password' (PRODUCTION)",
      async((DoneFn done) {
    Environment.setFile("assets/environments.json");
    expect(Environment.getVar("PASSWORD"), "password");
  }));
}
