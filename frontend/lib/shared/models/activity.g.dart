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
  selectedOptionIndex: (json['selectedOptionIndex'] as num?)?.toInt(),
  options:
      (json['options'] as List<dynamic>?)
          ?.map((e) => ActivityOption.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
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
  'selectedOptionIndex': instance.selectedOptionIndex,
  'options': instance.options,
};

_ActivityOption _$ActivityOptionFromJson(Map<String, dynamic> json) =>
    _ActivityOption(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String?,
      pictogramId: (json['pictogramId'] as num?)?.toInt(),
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ActivityOptionToJson(_ActivityOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'pictogramId': instance.pictogramId,
      'sortOrder': instance.sortOrder,
    };
