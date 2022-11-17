import 'package:quiver/iterables.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/exceptions/custom_exceptions.dart';

void main() {
  test('when start > stop', () {
    try {
      range(5, 3);
    } on ArgumentError catch (e) {
      expect(e.message, 'start must be less than stop');
      return;
    }
    throw ServerException('Test', 'Test');
  });
}
