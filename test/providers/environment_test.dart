import 'package:test_api/test_api.dart';
import 'package:weekplanner/providers/environment_provider.dart' as environment;

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
    environment.setContent(debugEnvironments);
    expect(environment.getVar<String>('SERVER_HOST'),
        equals('http://web.giraf.cs.aau.dk:5000'));
  });

  test('Should get SERVER_HOST from environment file (PRODUCTION)', () {
    environment.setContent(prodEnvironments);
    expect(environment.getVar<String>('SERVER_HOST'),
        equals('http://web.giraf.cs.aau.dk:5000'));
  });

  test('Should get DEBUG from environment file (PRODUCTION)', () {
    environment.setContent(prodEnvironments);
    expect(environment.getVar<bool>('DEBUG'), equals(false));
  });

  test('Should get USERNAME from environment file (PRODUCTION)', () {
    environment.setContent(debugEnvironments);
    expect(environment.getVar<String>('USERNAME'), equals('Graatand'));
  });

  test('Should get PASSWORD from environment file (PRODUCTION)', () {
    environment.setContent(debugEnvironments);
    expect(environment.getVar<String>('PASSWORD'), equals('password'));
  });
}
