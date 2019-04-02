import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/blocs/user_info_bloc.dart';
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
        userInfoBloc = di.getDependency<UserInfoBloc>(),
        toolbarBloc = di.getDependency<ToolbarBloc>(),
        super(key: key);

  /// Contains the functionality of the toolbar.
  final ToolbarBloc toolbarBloc;

  /// Contains the functionality of the SettingsScreen.
  final SettingsBloc settingsBloc;

  /// Contains the functionality of changing the weekplan.
  final UserInfoBloc userInfoBloc;


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
              builder: (BuildContext context,
                        AsyncSnapshot<GirafTheme> snapshot) {
                return Text(snapshot.data.toString());
              },
            ),
            _dayWidget('visibilityMon', 1, 0xFF007700, 'Mandag'),
            _dayWidget('visibilityTue', 2, 0xFF800080, 'Tirsdag'),
            _dayWidget('visibilityWed', 3, 0xFFFF8500, 'Onsdag'),
            _dayWidget('visibilityThu', 4, 0xFF0000FF, 'Torsdag'),
            _dayWidget('visibilityFri', 5, 0xFFFFDD00, 'Fredag'),
            _dayWidget('visibilitySat', 6, 0xFFFF0000, 'Lørdag'),
            _dayWidget('visibilitySun', 7, 0xFFFFFFFF, 'Søndag'),
          ],
        ));
  }

  /// Returns the widget representing a day in the weekplanner
  StreamBuilder<Tuple2<String, int>> _dayWidget
        (String key, int dayNumber, int color, String day){
    return StreamBuilder<Tuple2<String, int>>(
      stream: userInfoBloc.dayOfWeekAndUsermode,
      initialData: const Tuple2<String, int>('Guardian', 0),
      builder: (BuildContext context,
                AsyncSnapshot<Tuple2<String, int>> snapshot) {
      return Visibility(
        key: Key(key),
        visible: snapshot.data.item1 == 'Guardian' ||
                 snapshot.data.item2 == dayNumber,
        child: Expanded(
          child: Card(
            color: Color(color),
            child: _day(day, tasksList))),
      );
      }
    );
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

