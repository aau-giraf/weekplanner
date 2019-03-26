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

class WeekplanScreen extends StatelessWidget {
  final String title;
  final List<String> pictograms = ['assets/read.jpg', 'assets/read.jpg'];

  final ToolbarBloc toolbarBloc;
  final SettingsBloc settingsBloc;
  final UserInfoBloc userInfoBloc;

  final List<Widget> myList = <Widget>[
    new Card(child: Image.asset('assets/read.jpg')),
  ];

  WeekplanScreen({Key key, this.title})
      : settingsBloc = di.getDependency<SettingsBloc>(),
        userInfoBloc = di.getDependency<UserInfoBloc>(),
        toolbarBloc = di.getDependency<ToolbarBloc>(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GirafAppBar(
          title: 'Ugeplan',
        ),
        body: new Row(
          children: <Widget>[
            StreamBuilder<GirafTheme>(
              stream: this.settingsBloc.theme,
              initialData: GirafTheme.AndroidBlue,
              builder:
                  (BuildContext context, AsyncSnapshot<GirafTheme> snapshot) {
                return Text(snapshot.data.toString());
              },
            ),
            StreamBuilder<Tuple2<String, int>>(
              stream: this.userInfoBloc.dayOfWeekAndUsermode,
              initialData: Tuple2<String, int>('Guardian', 0),
              builder: (BuildContext context, AsyncSnapshot<Tuple2<String, int>> snapshot) {
                return Visibility(
                  key: Key('visibilityMon'),
                  visible: snapshot.data.item1 == 'Guardian' || snapshot.data.item2 == 1,
                  child: Expanded(
                      child: Card(
                          color: Color(0xFF007700),
                          child: Day('Mandag', myList))),
                );
              },
            ),
            StreamBuilder<Tuple2<String, int>>(
              stream: this.userInfoBloc.dayOfWeekAndUsermode,
              initialData: Tuple2<String, int>('Guardian', 0),
              builder: (BuildContext context, AsyncSnapshot<Tuple2<String, int>> snapshot) {
                return Visibility(
                  key: Key('visibilityTue'),
                  visible: snapshot.data.item1 == 'Guardian' || snapshot.data.item2 == 2,
                  child: Expanded(
                      child: Card(
                          color: Color(0xFF800080),
                          child: Day('Tirsdag', myList))),
                );
              },
            ),
            StreamBuilder<Tuple2<String, int>>(
              stream: this.userInfoBloc.dayOfWeekAndUsermode,
              initialData: Tuple2<String, int>('Guardian', 0),
              builder: (BuildContext context, AsyncSnapshot<Tuple2<String, int>> snapshot) {
                return Visibility(
                  key: Key('visibilityWed'),
                  visible: snapshot.data.item1 == 'Guardian' || snapshot.data.item2 == 3,
                  child: Expanded(
                      child: Card(
                          color: Color(0xFFFF8500),
                          child: Day('Onsdag', myList))),
                );
              },
            ),
            StreamBuilder<Tuple2<String, int>>(
              stream: this.userInfoBloc.dayOfWeekAndUsermode,
              initialData: Tuple2<String, int>('Guardian', 0),
              builder: (BuildContext context, AsyncSnapshot<Tuple2<String, int>> snapshot) {
                return Visibility(
                  key: Key('visibilityThu'),
                  visible: snapshot.data.item1 == 'Guardian' || snapshot.data.item2 == 4,
                  child: Expanded(
                      child: Card(
                          color: Color(0xFF0000FF),
                          child: Day('Torsdag', myList))),
                );
              },
            ),

            StreamBuilder<Tuple2<String, int>>(
              stream: this.userInfoBloc.dayOfWeekAndUsermode,
              initialData: Tuple2<String, int>('Guardian', 0),
              builder: (BuildContext context, AsyncSnapshot<Tuple2<String, int>> snapshot) {
                return Visibility(
                  key: Key('visibilityFri'),
                  visible: snapshot.data.item1 == 'Guardian' || snapshot.data.item2 == 5,
                  child: Expanded(
                      child: Card(
                          color: Color(0xFFFFDD00),
                          child: Day('Fredag', myList))),
                );
              },
            ),

            StreamBuilder<Tuple2<String, int>>(
              stream: this.userInfoBloc.dayOfWeekAndUsermode,
              initialData: Tuple2<String, int>('Guardian', 0),
              builder: (BuildContext context, AsyncSnapshot<Tuple2<String, int>> snapshot) {
                return Visibility(
                  key: Key('visibilitySat'),
                  visible: snapshot.data.item1 == 'Guardian' || snapshot.data.item2 == 6,
                  child: Expanded(
                      child: Card(
                          color: Color(0xFFFF0000),
                          child: Day('Lørdag', myList))),
                );
              },
            ),

            StreamBuilder<Tuple2<String, int>>(
              stream: this.userInfoBloc.dayOfWeekAndUsermode,
              initialData: Tuple2<String, int>('Guardian', 0),
              builder: (BuildContext context, AsyncSnapshot<Tuple2<String, int>> snapshot) {
                return Visibility(
                  key: Key('visibilitySun'),
                  visible: snapshot.data.item1 == 'Guardian' || snapshot.data.item2 == 7,
                  child: Expanded(
                      child: Card(
                          color: Color(0xFFFFFFFF),
                          child: Day('Søndag', myList))),
                );
              },
            ),
          ],
        ));
  }
}

Column Day(String day, List<Widget> myList) {
  return Column(
    children: <Widget>[
      Text(day, style: TextStyle(fontWeight: FontWeight.bold)),
      Expanded(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return myList[index];
            return Card(
              color: Colors.white,
              child: IconButton(icon: Image.asset('assets/read.jpg')),
            );
          },
          itemCount: myList.length,
        ),
      ),
    ],
  );
}
