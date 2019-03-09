import 'package:weekplanner/models/model.dart';
import 'package:weekplanner/models/role_enum.dart';

class GirafUser implements Model {

  /// The id of the user
  String id;

  /// The role of the user
  Role role;

  /// The name of the role
  String roleName;

  /// The username
  String username;

  /// The users desired "screen name", i.e. how th app should address the user.
  String screenName;

  /// The id of the users department
  int department; // This is actually a long from the .Net server, will that cause problems ? (try with mInt).

  /// Constructor for instantiate a user inside the app.
  GirafUser({
    this.id,
    this.role,
    this.roleName,
    this.username,
    this.screenName,
    this.department
  });

  /// Constructor for instantiate a user from the backend response.
  GirafUser.fromJson(Map<String, dynamic> json){
    this.id = json['id'];
    this.role = Role.values[json['role']];
    this.roleName = json['roleName'];
    this.username = json['username'];
    this.screenName = json['screenName'];
    this.department = json['department'];
  }

  /// Converts the user object to json, inorder to send it to the backend.
  @override
  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "role": this.role.index,
      "roleName": this.roleName,
      "username": this.username,
      "screenName": this.screenName,
      "department": this.department
    };
  }
}