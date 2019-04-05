import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/bootstrap.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/screens/login_screen.dart';
import 'package:weekplanner/providers/environment_provider.dart' as environment;
import 'package:weekplanner/screens/choose_citizen_screen.dart';


void main() {
  // Register all dependencies for injector
  Bootstrap.register();

  if (_isInDebugMode) {
    // If in DEBUG mode
    environment.setFile('assets/environments.json').whenComplete(() {
      _runApp();
    });
  } else {
    // Else Production
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
          builder: (_, AsyncSnapshot<bool> snapshot) =>
              // In case we're logged in show WeekPlanner, otherwise, show login
              snapshot.data ? ChooseCitizenScreen() : LoginScreen())));
}

bool get _isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}
