import 'package:flutter/material.dart';

class Routes {
  static Future<T> pushReplacement<T extends Object, TO extends Object>(
      BuildContext context, Route<T> newRoute,
      {TO result}) {
    return Navigator.of(context)
        .pushReplacement<T, TO>(newRoute, result: result);
  }

  static Future<T> push<T extends Object>(BuildContext context, Widget widget) {
    return Navigator.of(context)
        .push<T>(MaterialPageRoute(builder: (context) => widget));
  }

  static bool pop<T extends Object>(BuildContext context, [T result]) {
    return Navigator.of(context).pop<T>(result);
  }
}