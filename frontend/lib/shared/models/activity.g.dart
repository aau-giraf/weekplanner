// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Activity _$ActivityFromJson(Map<String, dynamic> json) => _Activity(
  activityId: (json['activityId'] as num).toInt(),
  date: _dateFromJson(json['date'] as String),
  startTime: _timeFromJson(json['startTime'] as String),
  endTime: _timeFromJson(json['endTime'] as String),
  isCompleted: json['isCompleted'] as bool? ?? false,
  pictogramId: (json['pictogramId'] as num?)?.toInt(),
);

Map<String, dynamic> _$ActivityToJson(_Activity instance) => <String, dynamic>{
  'activityId': instance.activityId,
  'date': _dateToJson(instance.date),
  'startTime': _timeToJson(instance.startTime),
  'endTime': _timeToJson(instance.endTime),
  'isCompleted': instance.isCompleted,
  'pictogramId': instance.pictogramId,
};
