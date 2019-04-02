import 'package:test_api/test_api.dart';
import 'package:weekplanner/providers/environment_provider.dart';
import 'package:async_test/async_test.dart';

void main() {
  const String debugEnvironments = '''
    {
      "SERVER_HOST": "http://web.giraf.cs.aau.dk:5000",
      "DEBUG": true,
      "USERNAME": "Graatand",
      "PASSWORD": "password"
    }
    ''';
  const String prodEnvironments = '''
    {
      "SERVER_HOST": "http://web.giraf.cs.aau.dk:5000",
      "DEBUG": false
    }
    ''';

  test('Should get SERVER_HOST from environment file (DEBUG)',
      async((DoneFn done) {
    Environment.setContent(debugEnvironments);
    if (Environment.getVar<String>('SERVER_HOST') ==
        'http://web.giraf.cs.aau.dk:5000') {
      done();
    }
  }));

  test('Should get SERVER_HOST from environment file (PRODUCTION)',
      async((DoneFn done) {
    Environment.setContent(prodEnvironments);
    if (Environment.getVar<String>('SERVER_HOST') ==
        'http://web.giraf.cs.aau.dk:5000') {
      done();
    }
  }));

  test('Should get DEBUG from environment file (PRODUCTION)',
      async((DoneFn done) {
    Environment.setContent(prodEnvironments);
    if (Environment.getVar<bool>('DEBUG') == false) {
      done();
    }
  }));

  test('Should get USERNAME from environment file (PRODUCTION)',
      async((DoneFn done) {
    Environment.setContent(debugEnvironments);
    if (Environment.getVar<String>('USERNAME') == 'Graatand') {
      done();
    }
  }));

  test('Should get PASSWORD from environment file (PRODUCTION)',
      async((DoneFn done) {
    Environment.setContent(debugEnvironments);
    if (Environment.getVar<String>('PASSWORD') == 'password') {
      done();
    }
  }));
}
