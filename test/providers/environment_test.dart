import 'package:flutter_test/flutter_test.dart';
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
    // Parses the variables from the 'debugEnvironments' string.
    environment.setContent(debugEnvironments);

    // Compare the loaded environment variable "SERVER_HOST" from
    // the DEBUG environment to an expected value.
    // If "SERVER_HOST" wasn't loaded or did not have the expected value,
    // the test fails. Otherwise the test succeeds.
    expect(environment.getVar<String>('SERVER_HOST'),
        equals('http://web.giraf.cs.aau.dk:5000'));
  });

  test('Should get SERVER_HOST from environment file (PRODUCTION)', () {
    // Parses the variables from the 'prodEnvironments' string.
    environment.setContent(prodEnvironments);

    // Compare the loaded environment variable "SERVER_HOST" from
    // the PRODUCTION environment to an expected value.
    // This test does the same as the test above, just ausing the PRODUCTION
    // environment instead of the DEBUG environment.
    expect(environment.getVar<String>('SERVER_HOST'),
        equals('http://web.giraf.cs.aau.dk:5000'));
  });

  test('Should get DEBUG from environment file (PRODUCTION)', () {
    // Parses the variables from the 'prodEnvironments' string.
    environment.setContent(prodEnvironments);

    expect(environment.getVar<bool>('DEBUG'), equals(false));
  });

  test('Should get USERNAME from environment file (DEBUG)', () {
    // Parses the variables from the 'debugEnvironments' string.
    environment.setContent(debugEnvironments);

    expect(environment.getVar<String>('USERNAME'), equals('Graatand'));
  });

  test('Should get PASSWORD from environment file (DEBUG)', () {
    // Parses the variables from the 'debugEnvironments' string.
    environment.setContent(debugEnvironments);

    expect(environment.getVar<String>('PASSWORD'), equals('password'));
  });
}
