import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/bootstrap.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/providers/environment_provider.dart';
import 'package:weekplanner/screens/choose_citizen_screen.dart';
import 'package:weekplanner/screens/login_screen.dart';

Future<void> main() async {
  // Register all dependencies for injector
  await Bootstrap.register();

  if (_isInDebugMode) {
    // If in DEBUG mode
    await Environment.setFile('assets/environments.json');
  } else {
    // Else Production
    await Environment.setFile('assets/environments.prod.json');
  }

  runApp(MaterialApp(
      title: 'Weekplanner',
      home: StreamBuilder<bool>(
          initialData: false,
          stream: di.getDependency<AuthBloc>().loggedIn,
          builder: (_, AsyncSnapshot<bool> snapshot) =>
              // In case logged in show ChooseCitizenScreen, otherwise login
              snapshot.data ? ChooseCitizenScreen() : LoginScreen())));
}

bool get _isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}
