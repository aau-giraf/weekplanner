import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/blocs/weekplan_bloc.dart';
import 'package:weekplanner/bootstrap.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/enums/giraf_theme_enum.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

class WeekplanScreen extends StatelessWidget {
  final String title;
  final SettingsBloc settingsBloc;
  final WeekplanBloc weekplanBloc;
  final List<Widget> myList = <Widget>[
    new Card(child: Image.asset('assets/read.jpg')),
  ];

  WeekplanScreen({Key key, this.title})
      : settingsBloc = di.getDependency<SettingsBloc>(),
        weekplanBloc = di.getDependency<WeekplanBloc>(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    weekplanBloc.getCharlie();
    weekplanBloc.getWeeks();
    weekplanBloc.getWeek1();
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
            Expanded(
                child: Card(
                    color: Color(0xFF007700), child: Day('Mandag', myList))),
            Expanded(
                child: Card(
                    color: Color(0xFF800080), child: Day('Tirsdag', myList))),
            Expanded(
                child: Card(
                    color: Color(0xFFFF8500), child: Day('Onsdag', myList))),
            Expanded(
                child: Card(
                    color: Color(0xFF0000FF), child: Day('Torsdag', myList))),
            Expanded(
                child: Card(
                    color: Color(0xFFFFDD00), child: Day('Fredag', myList))),
            Expanded(
                child: Card(
                    color: Color(0xFFFF0000), child: Day('Lørdag', myList))),
            Expanded(
                child: Card(
                    color: Color(0xFFFFFFFF), child: Day('Søndag', myList))),
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
