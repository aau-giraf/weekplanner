import 'dart:convert';
import 'package:flutter/services.dart';

// ignore: avoid_classes_with_only_static_members
class Environment {
  static String _file = '';
  static String _content = '';
  static dynamic _jsonDecoded;

  static T getVar<T>(String variableName) {
    return _jsonDecoded[variableName];
  }

  static Future<void> setFile(String fileLocation) async {
    _file = fileLocation;
    _content = await rootBundle.loadString(_file);
    _jsonDecoded = jsonDecode(_content);
  }

  static void setContent(String content) {
    _content = content;
    _jsonDecoded = jsonDecode(_content);
  }
}
