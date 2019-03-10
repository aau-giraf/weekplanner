import 'package:test_api/test_api.dart';
import 'package:weekplanner/models/giraf_theme_enum.dart';
import 'package:weekplanner/models/cancel_mark_enum.dart';
import 'package:weekplanner/models/complete_mark_enum.dart';
import 'package:weekplanner/models/default_timer_enum.dart';
import 'package:weekplanner/models/orientation_enum.dart';
import 'package:weekplanner/models/setting_model.dart';

void main(){
  Map<String, dynamic> response = {
    "orientation": 1,
    "completeMark": 2,
    "cancelMark": 2,
    "defaultTimer": 2,
    "timerSeconds": 900,
    "activitiesCount": null,
    "theme": 1,
    "nrOfDaysToDisplay": 7,
    "greyScale": false,
    "weekDayColors": [
      {
        "hexColor": "#067700",
        "day": 1
      },
      {
        "hexColor": "#8c1086",
        "day": 2
      },
      {
        "hexColor": "#ff7f00",
        "day": 3
      },
      {
        "hexColor": "#0017ff",
        "day": 4
      },
      {
        "hexColor": "#ffdd00",
        "day": 5
      },
      {
        "hexColor": "#ff0102",
        "day": 6
      },
      {
        "hexColor": "#ffffff",
        "day": 7
      }
    ]
  };

  test('Can instantiate from JSON', (){
    SettingModel settings = SettingModel.fromJson(response);

    expect(settings.orientation, Orientation.values[(response['orientation'] as int) -1]);
    expect(settings.completeMark, CompleteMark.values[(response['completeMark'] as int) - 1]);
    expect(settings.cancelMark, CancelMark.values[(response['cancelMark'] as int) - 1]);
    expect(settings.defaultTimer, DefaultTimer.values[(response['defaultTimer'] as int) - 1]);
    expect(settings.timerSeconds, response['timerSeconds']);
    expect(settings.activitiesCount, response['activitiesCount']);
    expect(settings.theme, GirafTheme.values[(response['theme'] as int) - 1]);
    expect(settings.greyscale, false);
    expect(settings.weekDayColors.length, 7);
    expect(settings.weekDayColors[0].toJson(), response['weekDayColors'][0]);
    expect(settings.weekDayColors[1].toJson(), response['weekDayColors'][1]);
    expect(settings.weekDayColors[2].toJson(), response['weekDayColors'][2]);
    expect(settings.weekDayColors[3].toJson(), response['weekDayColors'][3]);
    expect(settings.weekDayColors[4].toJson(), response['weekDayColors'][4]);
    expect(settings.weekDayColors[5].toJson(), response['weekDayColors'][5]);
    expect(settings.weekDayColors[6].toJson(), response['weekDayColors'][6]);
  });

  test('Will throw exception when JSON is null', (){
    expect(() => SettingModel.fromJson(null), throwsFormatException);
  });

  test('Can serialize into JSON', (){
    SettingModel settings = SettingModel.fromJson(response);

    expect(settings.toJson(), response);
  });
}