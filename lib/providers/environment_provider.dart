import 'dart:convert';
import 'package:flutter/services.dart';

// ignore: avoid_classes_with_only_static_members
class Environment {
  static String _file = '';
  static String _content = '';
  static T getVar<T>(String variableName) {
    return jsonDecode(_content)[variableName];
  }

  static Future<void> setFile(String fileLocation) async {
    _file = fileLocation;
    _content = await rootBundle.loadString(_file);
  }

  static void setContent(String content) {
    _content = content;
  }
}
