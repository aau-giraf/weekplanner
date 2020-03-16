import 'package:api_client/models/settings_model.dart';
import 'package:api_client/models/username_model.dart';

/// Class for Citizen
class Citizen implements UsernameModel {

  /// Citizen from json
  Citizen.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw const FormatException(
          '[Citizen]: Cannot instantiate from null');
    }

    id = json['userId'];
    name = json['userName'];
    role = json['userRole'];
    settingsModel = SettingsModel.fromJson(json['settings']);
  }

  /// Create a citizen from the username model
  Citizen.fromUserNameModel(UsernameModel model) {
    name = model.name;
    role = model.role;
    id = model.id;
    settingsModel = null;
  }

  @override
  Map<String, dynamic> toJson() =>
      <String, dynamic>{
        'userId': id,
        'userName': name,
        'userRole': role,
        'settings': settingsModel.toJson()
  };

  @override
  Type get runtimeType {

  }

  @override
  dynamic noSuchMethod(Invocation invocation) {

  }

  /// Settings model
  SettingsModel settingsModel;

  @override
  String name;

  @override
  String role;

  @override
  String id;

  /// Default constructor
  Citizen(this.settingsModel, this.name, this.role, this.id);

}

