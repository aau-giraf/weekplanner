import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/models/activity_model.dart';
import 'package:weekplanner/models/weekday_enum.dart';
import 'package:weekplanner/models/weekday_model.dart';

void main() {
  test("Throws when JSON is null", () {
    Map<String, dynamic> json = null; // ignore: avoid_init_to_null
    expect(() => WeekdayModel.fromJson(json), throwsFormatException);
  });

  test("Can create from JSON map", () {
    Map<String, dynamic> pictogramJson = {
      "id": 39,
      "lastEdit": "2018-05-17T10:58:41.241292",
      "title": "cat4",
      "accessLevel": 1,
      "imageUrl": "/v1/pictogram/39/image/raw",
      "imageHash": "RijAegW2HQR9zaAn8CIUHw=="
    };

    Map<String, dynamic> activityJson = {
      "pictogram": pictogramJson,
      "order": 0,
      "state": 1,
      "id": 1044,
      "isChoiceBoard": false
    };

    Map<String, dynamic> json = {
      "day": 1,
      "activities": [activityJson]
    };

    WeekdayModel model = WeekdayModel.fromJson(json);
    expect(model.day, Weekday.Monday);
    expect(model.activities.length, 1);
    expect(model.activities[0].toJson(),
        ActivityModel.fromJson(activityJson).toJson());
  });

  test("Can convert to JSON map", () {
    Map<String, dynamic> pictogramJson = {
      "id": 39,
      "lastEdit": "2018-05-17T10:58:41.241292",
      "title": "cat4",
      "accessLevel": 1,
      "imageUrl": "/v1/pictogram/39/image/raw",
      "imageHash": "RijAegW2HQR9zaAn8CIUHw=="
    };

    Map<String, dynamic> activityJson = {
      "pictogram": pictogramJson,
      "order": 0,
      "state": 1,
      "id": 1044,
      "isChoiceBoard": false
    };

    Map<String, dynamic> json = {
      "day": 1,
      "activities": [activityJson]
    };

    WeekdayModel model = WeekdayModel.fromJson(json);

    expect(model.toJson(), json);
  });
}
