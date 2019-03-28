import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/enums/giraf_theme_enum.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

class WeekplanScreen extends StatelessWidget {
  WeekplanScreen({Key key, this.title})
      : settingsBloc = di.getDependency<SettingsBloc>(),
        super(key: key);

  final String title;
  final List<String> pictograms = <String>[
    'assets/read.jpg',
    'assets/read.jpg'
  ];

  final SettingsBloc settingsBloc;

  final List<Widget> myList = <Widget>[
    Card(child: Image.asset('assets/read.jpg')),
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
                    child: _day('Mandag', myList))),
            Expanded(
                child: Card(
                    color: const Color(0xFF800080),
                    child: _day('Tirsdag', myList))),
            Expanded(
                child: Card(
                    color: const Color(0xFFFF8500),
                    child: _day('Onsdag', myList))),
            Expanded(
                child: Card(
                    color: const Color(0xFF0000FF),
                    child: _day('Torsdag', myList))),
            Expanded(
                child: Card(
                    color: const Color(0xFFFFDD00),
                    child: _day('Fredag', myList))),
            Expanded(
                child: Card(
                    color: const Color(0xFFFF0000),
                    child: _day('Lørdag', myList))),
            Expanded(
                child: Card(
                    color: const Color(0xFFFFFFFF),
                    child: _day('Søndag', myList))),
          ],
        ));
  }
}

Column _day(String day, List<Widget> myList) {
  return Column(
    children: <Widget>[
      Text(day, style: TextStyle(fontWeight: FontWeight.bold)),
      Expanded(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return myList[index];
          },
          itemCount: myList.length,
        ),
      ),
    ],
  );
}
