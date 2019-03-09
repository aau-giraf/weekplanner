import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Throws when JSON is null", () {
    Map<String, dynamic> json = null; // ignore: avoid_init_to_null
    expect(() => WeekdayModel.fromJson(json), throwsFormatException);
  });
}