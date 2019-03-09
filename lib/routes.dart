import 'package:flutter/material.dart';
import 'screens/login.dart';

class Routes {
  static final api = null;
  final routes = <String, WidgetBuilder> {
    '/login': (BuildContext context) => new Login()
  };

  Routes() {
    runApp(new MaterialApp(
      title: 'Flutter App',
      routes: routes,
      home: new Login(),
    ));
  }
}
