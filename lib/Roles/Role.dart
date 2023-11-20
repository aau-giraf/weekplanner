import 'package:flutter/cupertino.dart';
import 'package:weekplanner/screens/login_screen.dart';

abstract class UserRole {

}

class SuperUser implements UserRole {

}

class Guardian implements UserRole {

}

class Trustee implements UserRole {

}

class Citizen implements UserRole {

}
//to get the current usertype, use (userRole.runtimeType)
class User {
  UserRole userRole;

  User(this.userRole);

}
