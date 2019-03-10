import 'package:flutter/material.dart';
import 'package:weekplanner/screens/weekplan_screen.dart';

class Routes {
  static final api = null;
  final routes = <String, WidgetBuilder> {
    '/weekplan': (BuildContext context) => new Weekplan()
  };

  Routes() {
    runApp(new MaterialApp(
      title: 'Flutter App',
      routes: routes,
      home: new Weekplan(),
    ));
  }
}
