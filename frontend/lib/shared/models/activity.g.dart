// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Activity _$ActivityFromJson(Map<String, dynamic> json) => _Activity(
  activityId: (json['activity_id'] as num).toInt(),
  date: json['date'] as String,
  startTime: json['start_time'] as String,
  endTime: json['end_time'] as String,
  isCompleted: json['is_completed'] as bool? ?? false,
  pictogramId: (json['pictogram_id'] as num?)?.toInt(),
  citizenId: (json['citizen_id'] as num?)?.toInt(),
  gradeId: (json['grade_id'] as num?)?.toInt(),
  title: json['title'] as String?,
);

Map<String, dynamic> _$ActivityToJson(_Activity instance) => <String, dynamic>{
  'activity_id': instance.activityId,
  'date': instance.date,
  'start_time': instance.startTime,
  'end_time': instance.endTime,
  'is_completed': instance.isCompleted,
  'pictogram_id': instance.pictogramId,
  'citizen_id': instance.citizenId,
  'grade_id': instance.gradeId,
  'title': instance.title,
};
