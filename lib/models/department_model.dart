import 'package:meta/meta.dart';
import 'package:weekplanner/models/model.dart';
import 'package:weekplanner/models/username_model.dart';

class DepartmentModel implements Model {
  /// The id of the department.
  int id;

  /// The name of the department.
  String name;

  /// A list of the user names of all members of the department.
  List<UsernameModel> members = [];

  /// A list of ids of all resources owned by the department.
  List<int> resources = [];

  DepartmentModel({
    @required this.id,
    @required this.name,
    @required this.members,
    @required this.resources,
  });

  DepartmentModel.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw new FormatException(
          "[DepartmentModel]: Cannot instantiate from null");
    }

    id = json['id'];
    name = json['name'];
    members = (json['members'] as List)
        .map((value) => UsernameModel.fromJson(value))
        .toList();
    resources = (json['resources'] as List).map((item) => item as int).toList();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'members': members.map((member) => member.toJson()).toList(),
      'resources': resources
    };
  }
}
