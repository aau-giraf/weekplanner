import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/exceptions/custom_exceptions.dart';

void main() {
  void throwServerException() {
    throw ServerException('Test', 'Test');
  }

  void throwEditWeekplanButtonException() {
    throw EditWeekPlanButtonException('Test', 'Test');
  }

  void throwOrientationException() {
    throw OrientationException('Test', 'Test');
  }

  test('Should throw ServerException', () {
    expect(throwServerException, throwsA(isA<ServerException>()));
  });

  test('Should throw EditWeekplanButtonException', () {
    expect(throwEditWeekplanButtonException,
        throwsA(isA<EditWeekPlanButtonException>()));
  });

  test('Should throw OrientationException', () {
    expect(throwOrientationException, throwsA(isA<OrientationException>()));
  });
}
