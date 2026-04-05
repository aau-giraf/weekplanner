import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';

import 'package:weekplanner/shared/utils/date_utils.dart';

part 'activity.freezed.dart';
part 'activity.g.dart';

@freezed
abstract class Activity with _$Activity {
  const factory Activity({
    required int activityId,
    @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) required DateTime date,
    @JsonKey(fromJson: _nullableTimeFromJson, toJson: _nullableTimeToJson)
    TimeValue? startTime,
    @JsonKey(fromJson: _nullableTimeFromJson, toJson: _nullableTimeToJson)
    TimeValue? endTime,
    String? title,
    @Default(0) int sortOrder,
    @Default(false) bool isCompleted,
    int? pictogramId,
    int? selectedOptionIndex,
    @Default([]) List<ActivityOption> options,
  }) = _Activity;

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);
}

@freezed
abstract class ActivityOption with _$ActivityOption {
  const factory ActivityOption({
    required int id,
    String? title,
    int? pictogramId,
    @Default(0) int sortOrder,
  }) = _ActivityOption;

  factory ActivityOption.fromJson(Map<String, dynamic> json) =>
      _$ActivityOptionFromJson(json);
}

final _log = Logger('Activity');

TimeValue? _nullableTimeFromJson(String? s) {
  if (s == null) return null;
  final parsed = parseTimeValue(s);
  if (parsed == null) {
    _log.warning('Unparseable time value: "$s"');
  }
  return parsed;
}
String? _nullableTimeToJson(TimeValue? t) =>
    t != null ? formatTimeValueForApi(t) : null;

DateTime _dateFromJson(String s) => DateTime.parse(s);
String _dateToJson(DateTime d) => GirafDateUtils.formatQueryDate(d);
