import 'package:freezed_annotation/freezed_annotation.dart';

part 'pictogram.freezed.dart';
part 'pictogram.g.dart';

@freezed
abstract class Pictogram with _$Pictogram {
  const factory Pictogram({
    required int id,
    required String title,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'organization_id') int? organizationId,
  }) = _Pictogram;

  factory Pictogram.fromJson(Map<String, dynamic> json) => _$PictogramFromJson(json);
}
