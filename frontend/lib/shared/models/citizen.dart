import 'package:freezed_annotation/freezed_annotation.dart';

part 'citizen.freezed.dart';
part 'citizen.g.dart';

@freezed
abstract class Citizen with _$Citizen {
  const factory Citizen({
    required int id,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
  }) = _Citizen;

  factory Citizen.fromJson(Map<String, dynamic> json) => _$CitizenFromJson(json);
}
