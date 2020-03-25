import 'package:flutter/material.dart';

/// Custom colors for the GIRAF project. New colors can be added here.
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

  /// Color of transparent dark grey border
  static const Color transparentDarkGrey = Color.fromRGBO(112, 112, 112, 1);

  /// Yellow color for button default gradient
  static const Color gradientDefaultYellow = Color(0xFFFFCD59);
  /// Orange color for button default gradient
  static const Color gradientDefaultOrange = Color(0xFFFF9D00);
  /// Border color for button default gradient
  static const Color gradientDefaultBorder = Color(0xFF8A6E00);
  /// Yellow color for button pressed gradient
  static const Color gradientPressedYellow = Color(0xFFD4AD2F);
  /// Orange color for button pressed gradient
  static const Color gradientPressedOrange = Color(0xFFFF9D00);
  /// Border color for button pressed gradient
  static const Color gradientPressedBorder = Color(0xFF493700);
  /// Yellow color for button disabled gradient
  static const Color gradientDisabledYellow = Color(0x46FFCD59);
  /// Orange color for button disabled gradient
  static const Color gradientDisabledOrange = Color(0xA6FF9D00);
  /// Border color for button disabled gradient
  static const Color gradientDisabledBorder = Color(0xA68A6E00);

  /// Color for the loading spinner
  static const Color loadingColor = Color.fromRGBO(255, 157, 0, 0.8);

  /// Color for the notification widget
  static const Color transparentBlack = Color.fromRGBO(0, 0, 0, 1);

  /// Color of checkbox
  static const Color checkboxColor = Color.fromARGB(255, 255, 157, 0);

  /// Color of button used in pop up
  static const Color dialogButton = Color.fromRGBO(255, 157, 0, 100);

  /// Color of the border used in the activity widget
  static const Color blueBorderColor = Color.fromRGBO(35, 35, 35, 1);
}