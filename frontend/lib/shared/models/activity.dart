import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity.freezed.dart';
part 'activity.g.dart';

@freezed
abstract class Activity with _$Activity {
  const factory Activity({
    @JsonKey(name: 'activity_id') required int activityId,
    required String date,
    @JsonKey(name: 'start_time') required String startTime,
    @JsonKey(name: 'end_time') required String endTime,
    @JsonKey(name: 'is_completed') @Default(false) bool isCompleted,
    @JsonKey(name: 'pictogram_id') int? pictogramId,
    @JsonKey(name: 'citizen_id') int? citizenId,
    @JsonKey(name: 'grade_id') int? gradeId,
    String? title,
  }) = _Activity;

  factory Activity.fromJson(Map<String, dynamic> json) => _$ActivityFromJson(json);
}
