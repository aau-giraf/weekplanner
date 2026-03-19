// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organisation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Organisation _$OrganisationFromJson(Map<String, dynamic> json) =>
    _Organisation(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$OrganisationToJson(_Organisation instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
