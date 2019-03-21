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

  static void setFile(String FileLocation) async {
    _file = FileLocation;
    _content = await _getFileData(_file);
  }

  static Future<String> _getFileData(String path) async {
    return await rootBundle.loadString(path);
  }
}
