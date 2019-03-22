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
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/pictogram_image.dart';

class WeekplanScreen extends StatelessWidget {
  final SettingsBloc settingsBloc;
  final WeekplanBloc weekplanBloc;
  final List<Widget> myList = <Widget>[
    new Card(child: Image.asset('assets/read.jpg')),
  ];

  WeekplanScreen({Key key})
      : settingsBloc = di.getDependency<SettingsBloc>(),
        weekplanBloc = di.getDependency<WeekplanBloc>(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    weekplanBloc.getWeek1();
    return Scaffold(
      appBar: GirafAppBar(
        title: 'Ugeplan',
      ),
      body: StreamBuilder<WeekModel>(
        stream: this.weekplanBloc.week,
        initialData: null,
        builder: (BuildContext context, AsyncSnapshot<WeekModel> snapshot) {
          if (snapshot.hasData) {
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
  List<List<int>> weekColors = [
    [8, 160, 69],
    [84, 13, 110],
    [247, 127, 0],
    [0, 71, 119],
    [249, 200, 14],
    [219, 43, 57],
    [255, 255, 255]
  ];
  List<Widget> weekDays = List<Widget>();
  for (var i = 0; i < weekModel.days.length; i++) {
    weekDays.add(new Expanded(
        child: Card(
            color: Color.fromARGB(
                255, weekColors[i][0], weekColors[i][1], weekColors[i][2]),
            child: Day(weekModel.days[i].day,
                weekModel.days[i].activities))));
  }
  return new Row(children: weekDays);
}

Column Day(Weekday day, List<ActivityModel> myList) {
  return Column(
    children: <Widget>[
      translateWeekDay(day),
      Expanded(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            if (myList.isEmpty || myList == null) {
              return Text("No Pictograms");
            }

            return PictogramImage(
                pictogram: myList[index].pictogram,
                onPressed: () =>
                    //TODO : redirect to ShowActivity when it is implemented
                    Routes.push(context, WeekplanScreen()));
          },
          itemCount: myList.length,
        ),
      ),
    ],
  );
}

Text translateWeekDay(Weekday day) {
  String translation;
  switch (day) {
        case Weekday.Monday:
          translation = 'Mandag';
          break;
        case Weekday.Tuesday:
          translation = 'Tirsdag';
          break;
        case Weekday.Wednesday:
          translation = 'Onsdag';
          break;
        case Weekday.Thursday:
          translation = 'Torsdag';
          break;
        case Weekday.Friday:
          translation = 'Fredag';
          break;
        case Weekday.Saturday:
          translation = 'Lørdag';
          break;
        case Weekday.Sunday:
          translation = 'Søndag';
          break;
        default:
          translation = '';
          break;
      }
  return Text(translation, style: TextStyle(fontWeight: FontWeight.bold));
}
