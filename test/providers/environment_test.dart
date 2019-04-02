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

  test('Should get SERVER_HOST from environment file (DEBUG)', () {
    Environment.setContent(debugEnvironments);
    expect(Environment.getVar<String>('SERVER_HOST'),
        equals('http://web.giraf.cs.aau.dk:5000'));
  });

  test('Should get SERVER_HOST from environment file (PRODUCTION)', () {
    Environment.setContent(prodEnvironments);
    expect(Environment.getVar<String>('SERVER_HOST'),
        equals('http://web.giraf.cs.aau.dk:5000'));
  });

  test('Should get DEBUG from environment file (PRODUCTION)', () {
    Environment.setContent(prodEnvironments);
    expect(Environment.getVar<bool>('DEBUG'), equals(false));
  });

  test('Should get USERNAME from environment file (PRODUCTION)', () {
    Environment.setContent(debugEnvironments);
    expect(Environment.getVar<String>('USERNAME'), equals('Graatand'));
  });

  test('Should get PASSWORD from environment file (PRODUCTION)', () {
    Environment.setContent(debugEnvironments);
    expect(Environment.getVar<String>('PASSWORD'), equals('password'));
  });
}
