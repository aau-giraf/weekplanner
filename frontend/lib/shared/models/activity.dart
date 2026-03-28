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

final _log = Logger('Activity');

TimeValue _timeFromJson(String s) {
  final parsed = parseTimeValue(s);
  if (parsed == null) {
    _log.warning('Unparseable time value: "$s", defaulting to 00:00');
  }
  return parsed ?? (hour: 0, minute: 0);
}
String _timeToJson(TimeValue t) => formatTimeValueForApi(t);

DateTime _dateFromJson(String s) => DateTime.parse(s);
String _dateToJson(DateTime d) => GirafDateUtils.formatQueryDate(d);
