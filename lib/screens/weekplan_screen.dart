import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/blocs/weekplan_bloc.dart';
import 'package:weekplanner/bootstrap.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/activity_model.dart';
import 'package:weekplanner/models/enums/giraf_theme_enum.dart';
import 'package:weekplanner/models/enums/weekday_enum.dart';
import 'package:weekplanner/models/week_model.dart';
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
        body:
            StreamBuilder<WeekModel>(
              stream: this.weekplanBloc.week,
              initialData: null,
              builder:
                  (BuildContext context, AsyncSnapshot<WeekModel> snapshot) {
                    if(snapshot.hasData) {
                      return buildWeeks(snapshot.data);
                    } else {
                      return Text("Data not ready");
                    }
              },
            ),
    );
  }
}


Row buildWeeks(WeekModel weekModel) {
  List<List<int>> weekColors = [[8,160,69],[84,13,110], [247,127,0], [0,71,119], [249,200,14], [219,43,57], [255,255,255]];
  List<Widget> weekDays = List<Widget>();
  for (var i = 0; i < weekModel.days.length; i++) {
    weekDays.add(new Expanded(
                child: Card(
                    color: Color.fromARGB(255, weekColors[i][0],weekColors[i][1],weekColors[i][2]), child: Day(weekModel.days[i].day.toString(), weekModel.days[i].activities))));
  }
  return new Row(
    children: weekDays);
}

Column Day(String day, List<ActivityModel> myList) {
  return Column(
    children: <Widget>[
      Text(day, style: TextStyle(fontWeight: FontWeight.bold)),
      Expanded(
        child: 
        ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            if(myList.isEmpty || myList == null) {
              return Text("No Pictograms");
            }
            else
            return Text(myList[index].pictogram.imageUrl);
            
          },
          itemCount: myList.length,
        ),
      ),
    ],
  );
}
