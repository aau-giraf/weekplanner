import 'package:flutter/material.dart';
import 'package:weekplanner/globals.dart';
import 'package:weekplanner/screens/login_screen.dart';
import 'package:weekplanner/screens/weekplan_screen.dart';

void main() {
  runApp(StreamBuilder(
      initialData: false,
      stream: Globals.authBloc.loggedIn,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.data) {
          return MaterialApp(
            title: 'Flutter App',
            home: WeekplanScreen(),
          );
        } else {
          return MaterialApp(
            title: 'Flutter App',
            home: LoginScreen(),
          );
        }
      }));
}
