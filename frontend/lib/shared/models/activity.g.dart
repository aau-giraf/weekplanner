// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Activity _$ActivityFromJson(Map<String, dynamic> json) => _Activity(
  activityId: (json['activityId'] as num).toInt(),
  date: json['date'] as String,
  startTime: json['startTime'] as String,
  endTime: json['endTime'] as String,
  isCompleted: json['isCompleted'] as bool? ?? false,
  pictogramId: (json['pictogramId'] as num?)?.toInt(),
);

Map<String, dynamic> _$ActivityToJson(_Activity instance) => <String, dynamic>{
  'activityId': instance.activityId,
  'date': instance.date,
  'startTime': instance.startTime,
  'endTime': instance.endTime,
  'isCompleted': instance.isCompleted,
  'pictogramId': instance.pictogramId,
};
