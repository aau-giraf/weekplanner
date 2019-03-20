import 'package:meta/meta.dart';
import 'package:weekplanner/models/model.dart';

class UsernameModel implements Model {
  /// The user's name
  String name;

  /// The user's role
  String role;

  /// The user's ID
  String id;

  /// Default constructor
  UsernameModel({@required this.name, @required this.role, @required this.id});

  /// Create object from JSON mapping
  UsernameModel.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw new FormatException(
          "[UsernameModel]: Cannot instantiate from null");
    }

    id = json['userId'];
    name = json['userName'];
    role = json['userRole'];
  }

  @override
  Map<String, dynamic> toJson() =>
      {'userId': id, 'userName': name, 'userRole': role};
}
