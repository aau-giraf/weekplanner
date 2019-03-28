import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/blocs/user_info_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import '../widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/bootstrap.dart';
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
          body:
            new Row(
              children: <Widget>[
                StreamBuilder<GirafTheme>(
                  stream: this.settingsBloc.theme,
                  initialData: GirafTheme.AndroidBlue,
                  builder: (BuildContext context, AsyncSnapshot<GirafTheme> snapshot){
                    return Text(snapshot.data.toString());
                  },
                ),
                Expanded(
                  child: Card(
                    color: Color(0xFF007700),
                    child: Day('Mandag', myList)
                  )
                ),
                Expanded(
                  child: Card(
                    color: Color(0xFF800080),
                    child: Day('Tirsdag', myList)
                  )
                ),
                Expanded(
                  child: Card(
                    color: Color(0xFFFF8500),
                    child: Day('Onsdag', myList)
                  )
                ),
                Expanded(
                  child: Card(
                    color: Color(0xFF0000FF),
                    child: Day('Torsdag', myList)
                  )
                ),
                Expanded(
                  child: Card(
                    color: Color(0xFFFFDD00),

                    child: Day('Fredag', myList)
                  )
                ),
                Expanded(
                  child: Card(
                    color: Color(0xFFFF0000),

                    child: Day('Lørdag', myList)
                  )
                ),
                Expanded(
                  child: Card(
                    color: Color(0xFFFFFFFF),

                    child: Day('Søndag', myList)
                  )
                ),
              ],
            )

        );

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
            StreamBuilder<Tuple2<String, int>>(
              stream: userInfoBloc.dayOfWeekAndUsermode,
              initialData: const Tuple2<String, int>('Guardian', 0),
              builder: (BuildContext context,
                        AsyncSnapshot<Tuple2<String, int>> snapshot) {
                return Visibility(
                  key: const Key('visibilityMon'),
                  visible: snapshot.data.item1 == 'Guardian' ||
                           snapshot.data.item2 == 1,
                  child: Expanded(
                      child: Card(
                          color: const Color(0xFF007700),
                          child: _day('Mandag', myList))),
                );
              },
            ),
            StreamBuilder<Tuple2<String, int>>(
              stream: userInfoBloc.dayOfWeekAndUsermode,
              initialData: const Tuple2<String, int>('Guardian', 0),
              builder: (BuildContext context,
                        AsyncSnapshot<Tuple2<String, int>> snapshot) {
                return Visibility(
                  key: const Key('visibilityTue'),
                  visible: snapshot.data.item1 == 'Guardian' ||
                           snapshot.data.item2 == 2,
                  child: Expanded(
                      child: Card(
                          color: const Color(0xFF800080),
                          child: _day('Tirsdag', myList))),
                );
              },
            ),
            StreamBuilder<Tuple2<String, int>>(
              stream: userInfoBloc.dayOfWeekAndUsermode,
              initialData: const Tuple2<String, int>('Guardian', 0),
              builder: (BuildContext context,
                        AsyncSnapshot<Tuple2<String, int>> snapshot) {
                return Visibility(
                  key: const Key('visibilityWed'),
                  visible: snapshot.data.item1 == 'Guardian' ||
                           snapshot.data.item2 == 3,
                  child: Expanded(
                      child: Card(
                          color: const Color(0xFFFF8500),
                          child: _day('Onsdag', myList))),
                );
              },
            ),
            StreamBuilder<Tuple2<String, int>>(
              stream: userInfoBloc.dayOfWeekAndUsermode,
              initialData: const Tuple2<String, int>('Guardian', 0),
              builder: (BuildContext context,
                        AsyncSnapshot<Tuple2<String, int>> snapshot) {
                return Visibility(
                  key: const Key('visibilityThu'),
                  visible: snapshot.data.item1 == 'Guardian' ||
                           snapshot.data.item2 == 4,
                  child: Expanded(
                      child: Card(
                          color: const Color(0xFF0000FF),
                          child: _day('Torsdag', myList))),
                );
              },
            ),

            StreamBuilder<Tuple2<String, int>>(
              stream: userInfoBloc.dayOfWeekAndUsermode,
              initialData: const Tuple2<String, int>('Guardian', 0),
              builder: (BuildContext context,
                        AsyncSnapshot<Tuple2<String, int>> snapshot) {
                return Visibility(
                  key: const Key('visibilityFri'),
                  visible: snapshot.data.item1 == 'Guardian' ||
                           snapshot.data.item2 == 5,
                  child: Expanded(
                      child: Card(
                          color: const Color(0xFFFFDD00),
                          child: _day('Fredag', myList))),
                );
              },
            ),

            StreamBuilder<Tuple2<String, int>>(
              stream: userInfoBloc.dayOfWeekAndUsermode,
              initialData: const Tuple2<String, int>('Guardian', 0),
              builder: (BuildContext context,
                        AsyncSnapshot<Tuple2<String, int>> snapshot) {
                return Visibility(
                  key: const Key('visibilitySat'),
                  visible: snapshot.data.item1 == 'Guardian' ||
                           snapshot.data.item2 == 6,
                  child: Expanded(
                      child: Card(
                          color: const Color(0xFFFF0000),
                          child: _day('Lørdag', myList))),
                );
              },
            ),

            StreamBuilder<Tuple2<String, int>>(
              stream: userInfoBloc.dayOfWeekAndUsermode,
              initialData: const Tuple2<String, int>('Guardian', 0),
              builder: (BuildContext context,
                        AsyncSnapshot<Tuple2<String, int>> snapshot) {
                return Visibility(
                  key: const Key('visibilitySun'),
                  visible: snapshot.data.item1 == 'Guardian' ||
                           snapshot.data.item2 == 7,
                  child: Expanded(
                      child: Card(
                          color: const Color(0xFFFFFFFF),
                          child: _day('Søndag', myList))),
                );
              },
            ),
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
