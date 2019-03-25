import 'package:meta/meta.dart';
import 'package:weekplanner/models/model.dart';
import 'package:weekplanner/models/username_model.dart';

class DepartmentModel implements Model {
  DepartmentModel({
    @required this.id,
    @required this.name,
    @required this.members,
    @required this.resources,
  });

  DepartmentModel.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw const FormatException(
          '[DepartmentModel]: Cannot instantiate from null');
    }

    id = json['id'];
    name = json['name'];
    members = (json['members'] is List ? json['members'] : null)
        .map((Map<String, dynamic> value) => UsernameModel.fromJson(value))
        .toList();
    resources = (json['resources'] is List ? json['resources'] : null)
        .map((Map<String, dynamic>item) => item).toList();
  }

  /// The id of the department.
  int id;

  /// The name of the department.
  String name;

  /// A list of the user names of all members of the department.
  List<UsernameModel> members = <UsernameModel> [];

  /// A list of ids of all resources owned by the department.
  List<int> resources = <int> [];

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'members': members.map((UsernameModel member) => member.toJson()).toList(),
      'resources': resources
    };
  }
}
