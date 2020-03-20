import 'package:flutter/material.dart';

/// Custom colors for the GIRAP project. New colors can be added here.
class GirafColors {
  GirafColors._();

  /// Color for the text in the login field
  static const Color loginFieldText = Color.fromRGBO(170, 170, 170, 1);
  /// Color for the login button
  static const Color loginButtonColor = Color.fromRGBO(48, 81, 118, 1);
  /// Color for the buttons
  static const Color buttonColor = Color(0xA0FFFFFF);
  /// The top color of the appbar
  static const Color appBarYellow = Color.fromRGBO(254, 215, 108, 1);
  /// The bottom color of the appbar
  static const Color appBarOrange = Color.fromRGBO(253, 187, 85, 1);

  /// Color of monday in the week planner
  static const Color mondayColor = Color(0xFF08A045);
  /// Color of tuesday in the week planner
  static const Color tuesdayColor = Color(0xFF540D6E);
  /// Color of wednesday in the week planner
  static const Color wednesdayColor = Color(0xFFF77F00);
  /// Color of thursday in the week planner
  static const Color thursdayColor = Color(0xFF004777);
  /// Color of friday in the week planner
  static const Color fridayColor = Color(0xFFF9C80E);
  /// Color of saturday in the week planner
  static const Color saturdayColor= Color(0xFFDB2B39);
  /// Color of sunday in the week planner
  static const Color sundayColor = Color(0xFFFFFFFF);

  /// Color of the shadows box when trying to move a card in the week planner
  static const Color dragShadow = Color.fromRGBO(200, 200, 200, 0.5);

  /// Dark blue color for border
  static const Color borderColor =Color.fromRGBO(35, 35, 35, 1.0);
}