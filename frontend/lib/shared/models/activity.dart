import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:weekplanner/shared/utils/date_utils.dart';

part 'activity.freezed.dart';
part 'activity.g.dart';

@freezed
abstract class Activity with _$Activity {
  const factory Activity({
    required int activityId,
    @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) required DateTime date,
    @JsonKey(fromJson: _timeFromJson, toJson: _timeToJson)
    required TimeValue startTime,
    @JsonKey(fromJson: _timeFromJson, toJson: _timeToJson)
    required TimeValue endTime,
    @Default(false) bool isCompleted,
    int? pictogramId,
  }) = _Activity;

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);
}

TimeValue _timeFromJson(String s) => parseTimeValue(s) ?? (hour: 0, minute: 0);
String _timeToJson(TimeValue t) => formatTimeValueForApi(t);

DateTime _dateFromJson(String s) => DateTime.parse(s);
String _dateToJson(DateTime d) => GirafDateUtils.formatQueryDate(d);
