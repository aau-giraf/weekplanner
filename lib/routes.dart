import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/globals.dart';
import 'package:weekplanner/route_builder.dart';

import 'package:weekplanner/screens/login_screen.dart';
import 'package:weekplanner/screens/pictogram_search_screen.dart';
import 'package:weekplanner/screens/settings_screen.dart';
import 'package:weekplanner/screens/weekplan_screen.dart';
import 'package:weekplanner/screens/new_weekplan_screen.dart';
import 'package:weekplanner/widgets/bloc_provider_tree_widget.dart';
import 'package:weekplanner/providers/bloc_provider.dart';


class Routes {
  final routes = <String, WidgetBuilder>{
    '/login': RouteBuilder.build(LoginScreen(), [
      BlocProvider<AuthBloc>(bloc: Globals.authBloc)
    ]),
    '/weekplan': RouteBuilder.build(WeekplanScreen(), [
      BlocProvider<SettingsBloc>(bloc: Globals.settingsBloc)
    ]),
    '/settings': RouteBuilder.build(SettingsScreen(), [
      BlocProvider<SettingsBloc>(bloc: Globals.settingsBloc)
    ]),
    '/pictogram/search': RouteBuilder.build(PictogramSearch(), []),
    '/select_weekplan/new_weekplan': RouteBuilder.build(NewWeekplanScreen(), []),
  };

  Routes() {
    runApp(new MaterialApp(
      title: 'Weekplanner',
      routes: routes,
      home: BlocProviderTree(
        blocProviders: [
          BlocProvider<AuthBloc>(bloc: Globals.authBloc)
        ],
        child: new LoginScreen()
      )
    ));
  }
}
