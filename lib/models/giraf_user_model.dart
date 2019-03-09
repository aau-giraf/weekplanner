import 'package:weekplanner/models/model.dart';
import 'package:weekplanner/models/role_enum.dart';

class GirafUser implements Model{
  String id;
  Role role;
  String roleName;
  String username;
  String screenName;
  int department; // This is actually a long from the .Net server, will that cause problems ? (try with mInt).

  GirafUser({
    this.id,
    this.role,
    this.roleName,
    this.username,
    this.screenName,
    this.department
  });

  GirafUser.fromJson(Map<String, dynamic> json){
    this.id = json['id'];
    this.role = Role.values[json['role']];
    this.roleName = json['roleName'];
    this.username = json['username'];
    this.screenName = json['screenName'];
    this.department = json['department'];
  }

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