import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/bootstrap.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/providers/environment_provider.dart' as environment;
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/choose_citizen_screen.dart';
import 'package:weekplanner/screens/login_screen.dart';

void main() {
  /// Register all dependencies for injector
  Bootstrap.register();

  if (_isInDebugMode) {
    /// If in DEBUG mode
    environment.setFile('assets/environments.json').whenComplete(() {
      _runApp();
    });
  } else {
    /// Else Production
    environment.setFile('assets/environments.prod.json').whenComplete(() {
      _runApp();
    });
  }
}

void _runApp() {
  runApp(MaterialApp(
      title: 'Weekplanner',
      home: StreamBuilder<bool>(
          initialData: false,
          stream: di.getDependency<AuthBloc>().loggedIn,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data) {
              /// In case logged in show ChooseCitizenScreen
              return ChooseCitizenScreen();
            } else {
              /// Not loggedIn pop context to login screen.
              Routes.goHome(context);
              return LoginScreen();
            }
          })));
}

bool get _isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}
