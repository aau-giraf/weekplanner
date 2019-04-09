import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:weekplanner/blocs/weekplan_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/activity_model.dart';
import 'package:weekplanner/models/enums/activity_state_enum.dart';
import 'package:weekplanner/models/enums/weekday_enum.dart';
import 'package:weekplanner/models/pictogram_model.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/screens/pictogram_search_screen.dart';
import 'package:weekplanner/widgets/pictogram_image.dart';

const Color buttonColor = Color(0xA0FFFFFF);

/// <summary>
/// The WeekplandScreen is used to display a week
/// and all the activities that occur in it.
/// </summary>
class WeekplanScreen extends StatelessWidget {
  /// <summary>
  /// WeekplanScreen constructor
  /// </summary>
  /// <param name="key">Key of the widget</param>
  /// <param name="week">Week that should be shown on the weekplan</param>
  WeekplanScreen({Key key, WeekModel week}) : super(key: key) {
    weekplanBloc.setWeek(week);
  }

  /// The WeekplanBloc that contains the currently chosen week
  final WeekplanBloc weekplanBloc = di.getDependency<WeekplanBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GirafAppBar(
        title: 'Ugeplan',
      ),
      body: StreamBuilder<WeekModel>(
        stream: weekplanBloc.week,
        initialData: null,
        builder: (BuildContext context, AsyncSnapshot<WeekModel> snapshot) {
          if (snapshot.hasData) {
            return _buildWeeks(snapshot.data, context);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }


  Row _buildWeeks(WeekModel weekModel, BuildContext context) {
    const List<int> weekColors = <int>[
      0xFF08A045,
      0xFF540D6E,
      0xFFF77F00,
      0xFF004777,
      0xFFF9C80E,
      0xFFDB2B39,
      0xFFFFFFFF
    ];
    final List<Widget> weekDays = <Widget>[];
    for (int i = 0; i < weekModel.days.length; i++) {
      weekDays.add(Expanded(
          child: Card(
              color: Color(weekColors[i]),
              child: _day(weekModel.days[i].day, weekModel.days[i].activities,
                  context))));
    }
    return Row(children: weekDays);
  }

  Column _day(
      Weekday day, List<ActivityModel> activities, BuildContext context) {
    return Column(
      children: <Widget>[
        _translateWeekDay(day),
        Expanded(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return PictogramImage(
                  pictogram: activities[index].pictogram,
                  onPressed: () => null);
            },
            itemCount: activities.length,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: ButtonTheme(
            child: SizedBox(
              width: double.infinity,
              child: RaisedButton(
                  child: Image.asset('assets/icons/add.png'),
                  color: buttonColor,
                  onPressed: () async {
                    PictogramModel newActivity =
                        await Routes.push(context, PictogramSearch());
                    if (newActivity != null) {
                      weekplanBloc.addActivity(ActivityModel(
                          id: newActivity.id,
                          pictogram: newActivity,
                          order: activities.length,
                          state: ActivityState.Active,
                          isChoiceBoard: false),
                      day.index);
                    }
                  }),
            ),
          ),
        )
      ],
    );
  }

  Card _translateWeekDay(Weekday day) {
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
    return Card(
        key: Key(translation),
        color: buttonColor,
        child: ListTile(
            title: Text(
          translation,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        )));
  }
}
