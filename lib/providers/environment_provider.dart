import 'dart:io';

import 'package:flutter/services.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'dart:convert';

class Environment {
  static String _file = "";
  static String _content = "";
  static T getVar<T>(String variableName) {
    return jsonDecode(_content)[variableName] as T;
  }

  static Future setFile(String fileLocation) async {
    _file = fileLocation;
    _content = await rootBundle.loadString(_file);
  }

  static setContent(String content) {
    _content = content;
  }
}
