// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Activity _$ActivityFromJson(Map<String, dynamic> json) => _Activity(
  activityId: (json['activityId'] as num).toInt(),
  date: _dateFromJson(json['date'] as String),
  startTime: _nullableTimeFromJson(json['startTime'] as String?),
  endTime: _nullableTimeFromJson(json['endTime'] as String?),
  title: json['title'] as String?,
  sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
  isCompleted: json['isCompleted'] as bool? ?? false,
  pictogramId: (json['pictogramId'] as num?)?.toInt(),
);

Map<String, dynamic> _$ActivityToJson(_Activity instance) => <String, dynamic>{
  'activityId': instance.activityId,
  'date': _dateToJson(instance.date),
  'startTime': _nullableTimeToJson(instance.startTime),
  'endTime': _nullableTimeToJson(instance.endTime),
  'title': instance.title,
  'sortOrder': instance.sortOrder,
  'isCompleted': instance.isCompleted,
  'pictogramId': instance.pictogramId,
};
