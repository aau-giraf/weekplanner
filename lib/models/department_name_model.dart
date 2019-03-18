import 'package:weekplanner/models/model.dart';

class DepartmentNameModel implements Model {
  /// The id of the department.
  int id;

  /// The name of the department.
  String name;

  DepartmentNameModel({this.id, this.name});

  DepartmentNameModel.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw new FormatException(
          "[DepartmentNameModel]: Cannot instantiate from null");
    }

    id = json['id'];
    name = json['name'];
  }

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
