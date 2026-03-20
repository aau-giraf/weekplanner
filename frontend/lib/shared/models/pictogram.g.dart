// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pictogram.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Pictogram _$PictogramFromJson(Map<String, dynamic> json) => _Pictogram(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  imageUrl: json['image_url'] as String?,
  organizationId: (json['organization_id'] as num?)?.toInt(),
);

Map<String, dynamic> _$PictogramToJson(_Pictogram instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image_url': instance.imageUrl,
      'organization_id': instance.organizationId,
    };
