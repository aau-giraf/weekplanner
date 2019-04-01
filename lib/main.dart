import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/bootstrap.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/giraf_user_model.dart';
import 'package:weekplanner/screens/login_screen.dart';
import 'package:weekplanner/screens/weekplan_screen.dart';
import 'package:weekplanner/screens/weekplan_selector_screen.dart';

void main() {
  // Register all dependencies for injector
  Bootstrap.register();

  runApp(MaterialApp(
      title: 'Weekplanner',
      home: StreamBuilder<bool>(
          initialData: false,
          stream: di.getDependency<AuthBloc>().loggedIn,
          builder: (_, AsyncSnapshot<bool> snapshot) =>
              // In case we're logged in show WeekPlanner, otherwise, show login
          snapshot.data ? WeekplanSelectorScreen(GirafUserModel(id: '6c64ebec-e889-4748-ab59-80de7e9d56b9')) : LoginScreen())));
}
