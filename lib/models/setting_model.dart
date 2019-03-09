import 'package:meta/meta.dart';
import 'package:weekplanner/models/theme_enum.dart';
import 'package:weekplanner/models/cancel_mark_enum.dart';
import 'package:weekplanner/models/complete_mark_enum.dart';
import 'package:weekplanner/models/default_timer_enum.dart';
import 'package:weekplanner/models/model.dart';
import 'package:weekplanner/models/orientation_enum.dart';
import 'package:weekplanner/models/weekday_color_model.dart';

class SettingModel implements Model{
  /// Preferred orientation of device/screen
  Orientation orientation;

  /// Preferred appearence of checked resources
  CompleteMark completeMark;

  /// Preferred appearence of cancelled resources
  CancelMark cancelMark;

  /// Preferred appearence of timer
  DefaultTimer defaultTimer;

  /// Number of seconds for timer
  int timerSeconds;

  /// Number of activities
  int activitiesCount;

  /// The preferred theme
  Theme theme;

  /// defines the number of days to display for a user in a weekschedule
  int nrOfDaysToDisplay;

  /// Flag for indicating whether or not greyscale is enabled
  bool greyscale;

  List<WeekdayColorModel> weekDayColors;

  SettingModel({
    @required this.orientation,
    @required this.completeMark,
    @required this.cancelMark,
    @required this.defaultTimer,
    this.timerSeconds,
    this.activitiesCount,
    @required this.theme,
    this.nrOfDaysToDisplay,
    this.greyscale,
    this.weekDayColors
  });

  SettingModel.fromJson(Map<String, dynamic> json){
    if (json == null) {
      throw FormatException("[SettingModel]: Cannot initialize from null");
    }

    this.orientation = Orientation.values[(json['orientation'] as int)-1];
    this.completeMark = CompleteMark.values[(json['completeMark'] as int) - 1];
    this.cancelMark = CancelMark.values[(json['cancelMark'] as int) -1];
    this.defaultTimer = DefaultTimer.values[(json['defaultTimer'] as int) - 1];
    this.timerSeconds = json['timerSeconds'];
    this.activitiesCount = json['activitiesCount'];
    this.theme = Theme.values[(json['theme'] as int) - 1];
    this.nrOfDaysToDisplay = json['nrOfDaysToDisplay'];
    this.greyscale = json['greyScale'];
    this.weekDayColors = (json['weekDayColors'] as List)
                          .map((value) => WeekdayColorModel.fromJson(value))
                          .toList();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
        "orientation": this.orientation.index + 1,
        "completeMark": this.completeMark.index + 1,
        "cancelMark": this.cancelMark.index + 1,
        "defaultTimer": this.defaultTimer.index + 1,
        "timerSeconds": this.timerSeconds,
        "activitiesCount": this.activitiesCount,
        "theme": this.theme.index + 1,
        "nrOfDaysToDisplay": this.nrOfDaysToDisplay,
        "greyScale": this.greyscale,
        "weekDayColors": this.weekDayColors.map((e) => e.toJson()).toList()
    };
  }


}