import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/models/giraf_user_model.dart';
import 'package:weekplanner/providers/api/api.dart';
import 'package:weekplanner/providers/api/user_api.dart';
import 'package:weekplanner/widgets/bloc_provider_tree_widget.dart';
import '../widgets/giraf_app_bar_widget.dart';

class WeekplanScreen extends StatelessWidget {
  SettingsBloc settingsBloc;
  final Api api;

  List<Widget> myList = <Widget>[];

  WeekplanScreen({Key key, this.api}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    settingsBloc = BlocProviderTree.of<SettingsBloc>(context);
    return Scaffold(
        appBar: GirafAppBar(
          title: 'Ugeplan',
        ),
        body: new Row(
          children: <Widget>[
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
          },
          itemCount: myList.length,
        ),
      ),
    ],
  );
}
