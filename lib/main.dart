import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/bootstrap.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/providers/environment_provider.dart';
import 'package:weekplanner/screens/login_screen.dart';
import 'package:weekplanner/screens/weekplan_screen.dart';
import 'package:weekplanner/screens/choose_citizen_screen.dart';

void main() async {
  // Register all dependencies for injector
  await Bootstrap.register();

  if (_isInDebugMode) {
    // If in DEBUG mode
    await EnvironmentProvider.setFile("assets/environments.json");
  } else {
    // Else Production
    await EnvironmentProvider.setFile("assets/environments.prod.json");
  }

  runApp(MaterialApp(
      title: "Weekplanner",
      home: StreamBuilder(
          initialData: false,
          stream: di.getDependency<AuthBloc>().loggedIn,
          builder: (_, AsyncSnapshot<bool> snapshot) => LoginScreen())));
}

bool get _isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}
