import 'package:api_client/models/settings_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/models/citizen.dart';

void main() {

  final Map<String, dynamic> json = <String, dynamic>{
    'userName': 'testname',
    'userRole': 'testrole',
    'userId': 'testId',
    'settings': {
      'orientation': 1,
      'completeMark': 1,
      'cancelMark': 1,
      'defaultTimer': 1,
      'timerSeconds': 1,
      'activitiesCount': 1,
      'theme': 1,
      'nrOfDaysToDisplay': 1,
      'greyScale': false,
      'weekDayColors': null
    }
  };

  test('When json is null, should throw error', () {
    const Map<String, dynamic> json = null;
    expect(() => Citizen.fromJson(json), throwsFormatException);
  });

  test('Can create Citizen from JSON', () {

    final Citizen model = Citizen.fromJson(json);

    expect(model.id, json['userId']);
    expect(model.name, json['userName']);
    expect(model.role, json['userRole']);
    expect(model.settingsModel.toJson(), equals(json['settings']));

  });

  test('Can convert to JSON', () {
    final Citizen model = Citizen(
      SettingsModel.fromJson(json['settings']), 'testname', 'testrole', 'testId'
    );

    final actualJson = model.toJson();

    expect(actualJson, equals(json));
  });

}