// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'citizen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Citizen _$CitizenFromJson(Map<String, dynamic> json) => _Citizen(
  id: (json['id'] as num).toInt(),
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
);

Map<String, dynamic> _$CitizenToJson(_Citizen instance) => <String, dynamic>{
  'id': instance.id,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
};
