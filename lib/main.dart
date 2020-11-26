import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/bootstrap.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/screens/login_screen.dart';
import 'package:weekplanner/providers/environment_provider.dart' as environment;
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/choose_citizen_screen.dart';

///navigator key allows for error messages from back end
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  // Register all dependencies for injector
  Bootstrap.register();
  WidgetsFlutterBinding.ensureInitialized();
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

/// Stores the last state of being logged in
bool lastState = false;

/// Stores if this is first time,
/// since this fixes a bug with logging in first time
bool first = true;
void _runApp() {
  runApp(MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Weekplanner',
      theme: ThemeData(fontFamily: 'Quicksand'),
      //debugShowCheckedModeBanner: false,
      home: StreamBuilder<bool>(
          initialData: false,
          stream: di
              .getDependency<AuthBloc>()
              .loggedIn
              .where((bool currentState) => lastState != currentState || first),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            lastState = snapshot.data;
            first = false;
            if (snapshot.data) {
              // In case logged in show ChooseCitizenScreen
              return ChooseCitizenScreen();
            } else {
              // Not loggedIn pop context to login screen.
              Routes.goHome(context);
              return LoginScreen();
            }
          })
    ));
}

bool get _isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}