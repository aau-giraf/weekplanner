import 'package:freezed_annotation/freezed_annotation.dart';

part 'organisation.freezed.dart';
part 'organisation.g.dart';

@freezed
abstract class Organisation with _$Organisation {
  const factory Organisation({
    required int id,
    required String name,
  }) = _Organisation;

  factory Organisation.fromJson(Map<String, dynamic> json) => _$OrganisationFromJson(json);
}
