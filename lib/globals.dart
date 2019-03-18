import 'dart:async';
import 'dart:io';

import 'package:weekplanner/blocs/application_bloc.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/providers/api/api.dart';
import 'package:flutter/material.dart';

class Globals {
  static final api = new Api("http://" + ServerUrl + ":" + ServerPort);
  static final ApplicationBloc appBloc = ApplicationBloc(authBloc);
  static final AuthBloc authBloc = AuthBloc(api);
  static final SettingsBloc settingsBloc = SettingsBloc();
  // Used for showing debug features
  // such as AutoLogin button
  static bool get isInDebugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

  static final String ServerUrl = "web.giraf.cs.aau.dk";
  static final String ServerPort = "5000";

  static Future<bool> hasInternet() async {
    try {
      final result = await InternetAddress.lookup(ServerUrl);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return true;
      }
    } on SocketException catch (_) {
      print('not connected');
      return false;
    }
  }

  static void showLoadingScreen(BuildContext context, bool Dismissible,
      [void callback(), int timeoutMS]) {
    if (callback != null) {
      if (timeoutMS == null) {
        timeoutMS = 2000;
      }
      Timer(Duration(milliseconds: timeoutMS), callback);
    }
    showDialog(
        barrierDismissible: Dismissible,
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Transform.scale(
                scale: 2,
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Color.fromRGBO(255, 157, 0, 0.8)),
                )),
          );
        });
  }
}
