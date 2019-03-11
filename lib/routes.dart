import 'package:flutter/material.dart';
import 'package:weekplanner/providers/api/api.dart';
import 'screens/login.dart';

class Routes {
  static final api = new Api("http://web.giraf.cs.aau.dk:5050");
  final routes = <String, WidgetBuilder> {
    '/login': (BuildContext context) => new Login(api)
  };

  Routes() {
    runApp(new MaterialApp(
      title: 'Flutter App',
      routes: routes,
      home: new Login(api),
    ));
  }
}
