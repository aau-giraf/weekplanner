import 'package:flutter/material.dart';

/// Wrapper for Navigation class
class Routes {
  /// Push the given route onto the navigator that most tightly encloses the
  /// given context.
  static Future<T> push<T extends Object>(BuildContext context, Widget widget) {
    return Navigator.of(context)
        .push<T>(MaterialPageRoute(builder: (context) => widget));
  }

  /// Pop the top-most route off the navigator that most tightly encloses the
  /// given context.
  static bool pop<T extends Object>(BuildContext context, [T result]) {
    return Navigator.of(context).pop<T>(result);
  }
}