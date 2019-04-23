import 'package:flutter/material.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/enums/weekday_enum.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/enums/activity_state_enum.dart';
import 'package:api_client/models/username_model.dart';
import 'package:weekplanner/blocs/weekplan_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/show_activity_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/pictogram_image.dart';

/// <summary>
/// The WeekplanScreen is used to display a week
/// and all the activities that occur in it.
/// </summary>
class WeekplanScreen extends StatelessWidget {
  /// <summary>
  /// WeekplanScreen constructor
  /// </summary>
  /// <param name="key">Key of the widget</param>
  /// <param name="week">Week that should be shown on the weekplan</param>
  /// <param name="user">owner of the weekplan</param>
  WeekplanScreen(this._week, this._user, {Key key}) : super(key: key) {
    weekplanBloc.setWeek(_week);
  }

  /// The WeekplanBloc that contains the currently chosen week
  final WeekplanBloc weekplanBloc = di.getDependency<WeekplanBloc>();
  final UsernameModel _user;
  final WeekModel _week;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GirafAppBar(
        title: 'Ugeplan'
      ),
      body: StreamBuilder<WeekModel>(
        stream: weekplanBloc.week,
        initialData: null,
        builder: (BuildContext context, AsyncSnapshot<WeekModel> snapshot) {
          if (snapshot.hasData) {
            return _buildWeeks(snapshot.data);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Row _buildWeeks(WeekModel weekModel) {
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
              child:
                  _day(weekModel.days[i].day, weekModel.days[i].activities))));
    }
    return Row(children: weekDays);
  }

  Column _day(Weekday day, List<ActivityModel> activities) {
    return Column(
      children: <Widget>[
        _translateWeekDay(day),
        Expanded(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              if (activities[index].state == ActivityState.Completed) {
                return GestureDetector(
                  onTap: () => Routes.push(context,
                      ShowActivityScreen(_week, activities[index], _user)),
                  child: Card(
                    child: FittedBox(
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: PictogramImage(
                              pictogram: activities[index].pictogram,
                              onPressed: null,
                            ),
                          ),
                          Icon(
                            Icons.check,
                            key: const Key('IconComplete'),
                            color: Colors.green,
                            size: MediaQuery.of(context).size.width,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }

              return PictogramImage(
                  pictogram: activities[index].pictogram,
                  key: Key(
                      day.index.toString() + activities[index].id.toString()),
                  onPressed: () => Routes.push(context,
                      ShowActivityScreen(_week, activities[index], _user)));
            },
            itemCount: activities.length,
          ),
        ),
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
    const Color color = Color(0xA0FFFFFF);
    return Card(
        key: Key(translation),
        color: color,
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
