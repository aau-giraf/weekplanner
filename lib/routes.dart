import 'package:flutter/material.dart';
import 'package:weekplanner/screens/login_screen.dart';
import 'package:weekplanner/screens/settings_screen.dart';
import 'package:weekplanner/screens/weekplan_screen.dart';

class Routes {
  static final api = null;
  final routes = <String, WidgetBuilder> {
    '/weekplan': (BuildContext context) => new WeekplanScreen(),
    '/settings': (BuildContext context) => new SettingsScreen()
  };

  Routes() {
    runApp(new MaterialApp(
      title: 'Flutter App',
      routes: routes,
      home: new LoginScreen(),
    ));
  }
}
