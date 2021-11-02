import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/bootstrap.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/screens/login_screen.dart';
import 'package:weekplanner/providers/environment_provider.dart' as environment;
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/choose_citizen_screen.dart';

void main() {
  // Register all dependencies for injector
  Bootstrap.register();
  WidgetsFlutterBinding.ensureInitialized();
  /***
   * The weekplanner will by default run towards the dev-enviroment
   * Use the "environments.local.json" for running against your local web-api
   * For IOS users: change the SERVER_HOST in the environment.local file to "http://localhost:5000"
   */
  environment.setFile('assets/environments.dev.json').whenComplete(() {
    _runApp();
  });
}

/// Stores the last state of being logged in
bool lastState = false;

/// Stores if this is first time,
/// since this fixes a bug with logging in first time
bool first = true;
void _runApp() {
  runApp(MaterialApp(
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
          })));
}
