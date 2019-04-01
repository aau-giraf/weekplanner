import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/enums/giraf_theme_enum.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import '../widgets/giraf_app_bar_widget.dart';



/// Screen containing all days with tasks.
class WeekplanScreen extends StatelessWidget {

  /// Screen showing all days, title being title of the screen.
  WeekplanScreen({Key key})
      : settingsBloc = di.getDependency<SettingsBloc>(),
        toolbarBloc = di.getDependency<ToolbarBloc>(),
        super(key: key);

  /// Contains the functionality of the toolbar.
  final ToolbarBloc toolbarBloc;

  /// Contains the functionality of the SettingsScreen.
  final SettingsBloc settingsBloc;


  /// Contains the tasks.
  final List<Widget> tasksList = <Widget>[
    Card(child: Image.asset('assets/read.jpg')),
  ];


  /// Contains the pictograms.
  final List<String> pictograms = <String>[
    'assets/read.jpg',
    'assets/read.jpg'
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GirafAppBar(
          title: 'Ugeplan',
        ),
        body: Row(
          children: <Widget>[
            StreamBuilder<GirafTheme>(
              stream: settingsBloc.theme,
              initialData: GirafTheme.AndroidBlue,
              builder:
                  (BuildContext context, AsyncSnapshot<GirafTheme> snapshot) {
                return Text(snapshot.data.toString());
              },
            ),
            Expanded(
                child: Card(
                    color: const Color(0xFF007700),
                    child: _day('Mandag', tasksList))),
            Expanded(
                child: Card(
                    color: const Color(0xFF800080),
                    child: _day('Tirsdag', tasksList))),
            Expanded(
                child: Card(
                    color: const Color(0xFFFF8500),
                    child: _day('Onsdag', tasksList))),
            Expanded(
                child: Card(
                    color: const Color(0xFF0000FF),
                    child: _day('Torsdag', tasksList))),
            Expanded(
                child: Card(
                    color: const Color(0xFFFFDD00),
                    child: _day('Fredag', tasksList))),
            Expanded(
                child: Card(
                    color: const Color(0xFFFF0000),
                    child: _day('Lørdag', tasksList))),
            Expanded(
                child: Card(
                    color: const Color(0xFFFFFFFF),
                    child: _day('Søndag', tasksList))),
          ],
        ));
  }
}

Column _day(String day, List<Widget> tasksList) {
  return Column(
    children: <Widget>[
      Text(day, style: TextStyle(fontWeight: FontWeight.bold)),
      Expanded(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return tasksList[index];
          },
          itemCount: tasksList.length,
        ),
      ),
    ],
  );
}
