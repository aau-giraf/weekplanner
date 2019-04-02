import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/bootstrap.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/activity_model.dart';
import 'package:weekplanner/models/enums/activity_state_enum.dart';
import 'package:weekplanner/models/pictogram_model.dart';
import 'package:weekplanner/screens/login_screen.dart';
import 'package:weekplanner/screens/show_activity_screen.dart';
import 'package:weekplanner/screens/weekplan_screen.dart';

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
              //snapshot.data ? WeekplanScreen() : LoginScreen())));
              snapshot.data
                  ? ShowActivityScreen(
                    null,
                    ActivityModel(
                      id: 461,
                      pictogram: PictogramModel(
                          id: 3975,
                          lastEdit: null,
                          title: 'test',
                          accessLevel: null,
                          imageUrl: null,
                          imageHash: null),
                      isChoiceBoard: false,
                      order: 1,
                      state: ActivityState.Normal),
                      null)
                  : LoginScreen())));
}
