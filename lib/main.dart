import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/bootstrap.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/activity_model.dart';
import 'package:weekplanner/models/enums/access_level_enum.dart';
import 'package:weekplanner/models/enums/activity_state_enum.dart';
import 'package:weekplanner/models/enums/weekday_enum.dart';
import 'package:weekplanner/models/giraf_user_model.dart';
import 'package:weekplanner/models/pictogram_model.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/models/weekday_model.dart';
import 'package:weekplanner/screens/login_screen.dart';
import 'package:weekplanner/screens/show_activity_screen.dart';
import 'package:weekplanner/screens/weekplan_screen.dart';

void main() {
  // Register all dependencies for injector
  Bootstrap.register();
  final List<ActivityModel> dayActivities = [ActivityModel(
    id: 477, 
    order: 0, 
    pictogram: PictogramModel(
      id: 7972,
      lastEdit: null,
      title: 'test',
      accessLevel: AccessLevel.PUBLIC,
      imageUrl: null,
      imageHash: null), 
    state: ActivityState.Normal,
    isChoiceBoard: false)];
  final List<WeekdayModel> weekModelDays = [WeekdayModel(
    day: Weekday.Tuesday, 
    activities: dayActivities)];

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
                    WeekModel(
                      name: 'Uge 22 - Lise',
                      weekNumber: 22,
                      weekYear: 2018,
                      thumbnail: PictogramModel(
                        id: 1737,
                        lastEdit: null,
                        title: 'test',
                        accessLevel: AccessLevel.PUBLIC,
                        imageUrl: null,
                        imageHash: null
                      ),
                      days: weekModelDays
                    ),
                    ActivityModel(
                      id: 461,
                      pictogram: PictogramModel(
                          id: 3975,
                          lastEdit: null,
                          title: 'test',
                          accessLevel: AccessLevel.PUBLIC,
                          imageUrl: null,
                          imageHash: null),
                      isChoiceBoard: false,
                      order: 1,
                      state: ActivityState.Normal),
                      GirafUserModel(
                        id: '57e7f7ce-6db0-4d0e-9519-ea927dd09760'
                      ))
                  : LoginScreen())));
}
