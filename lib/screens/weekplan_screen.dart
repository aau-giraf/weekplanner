import 'package:flutter/material.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/enums/activity_state_enum.dart';
import 'package:api_client/models/enums/weekday_enum.dart';
import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/weekplan_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';
import 'package:weekplanner/models/enums/weekplan_mode.dart';
import 'package:weekplanner/models/user_week_model.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/show_activity_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/screens/pictogram_search_screen.dart';
import 'package:api_client/models/pictogram_model.dart';

/// Color of the add buttons
const Color buttonColor = Color(0xA0FFFFFF);

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
    weekplanBloc.setWeek(_week, _user);
  }

  /// The WeekplanBloc that contains the currently chosen week
  final WeekplanBloc weekplanBloc = di.getDependency<WeekplanBloc>();
  final AuthBloc authBloc = di.getDependency<AuthBloc>();
  final UsernameModel _user;
  final WeekModel _week;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<WeekplanMode>(
        stream: authBloc.mode,
        builder: (BuildContext context,
            AsyncSnapshot<WeekplanMode> weekModeSnapshot) {
          return Scaffold(
            appBar: GirafAppBar(
                title: 'Ugeplan',
                appBarIcons: (weekModeSnapshot.data == WeekplanMode.guardian)
                    ? <AppBarIcon>[
                        AppBarIcon.changeToCitizen,
                        AppBarIcon.settings,
                        AppBarIcon.logout,
                      ]
                    : <AppBarIcon>[AppBarIcon.changeToGuardian]),
            body: StreamBuilder<UserWeekModel>(
              stream: weekplanBloc.userWeek,
              initialData: null,
              builder: (BuildContext context,
                  AsyncSnapshot<UserWeekModel> snapshot) {
                if (snapshot.hasData) {
                  return _buildWeeks(snapshot.data.week, context);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          );
        });
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
                          height: MediaQuery.of(context).size.width,
                          child: FittedBox(
                            child: _getPictogram(activities[index]),
                          ),
                        ),
                        (activities[index].state == ActivityState.Completed)
                            ? Icon(
                                Icons.check,
                                key: const Key('IconComplete'),
                                size: MediaQuery.of(context).size.width,
                                color: Colors.green,
                              )
                            : null,
                      ].where((Widget w) => w != null).toList(),
                    ),
                  ),
                ),
              );
            },
            itemCount: activities.length,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: ButtonTheme(
            child: SizedBox(
              width: double.infinity,
              child: StreamBuilder<WeekplanMode>(
                  stream: authBloc.mode,
                  builder: (BuildContext context,
                      AsyncSnapshot<WeekplanMode> snapshot) {
                    return Visibility(
                      visible: snapshot.data == WeekplanMode.guardian,
                      child: RaisedButton(
                          key: const Key('AddActivityButton'),
                          child: Image.asset('assets/icons/add.png'),
                          color: buttonColor,
                          onPressed: () async {
                            final PictogramModel newActivity =
                                await Routes.push(context, PictogramSearch());
                            if (newActivity != null) {
                              weekplanBloc.addActivity(
                                  ActivityModel(
                                      id: newActivity.id,
                                      pictogram: newActivity,
                                      order: activities.length,
                                      state: ActivityState.Active,
                                      isChoiceBoard: false),
                                  day.index);
                            }
                          }),
                    );
                  }),
            ),
          ),
        )
      ],
    );
  }

  void _iconClick(BuildContext context, ActivityModel activity) {
    Routes.push(context, ShowActivityScreen(_week, activity, _user));
  }

  Widget _getPictogram(ActivityModel activity) {
    final PictogramImageBloc bloc = di.getDependency<PictogramImageBloc>();
    bloc.loadPictogramById(activity.pictogram.id);
    return StreamBuilder<Image>(
      stream: bloc.image,
      builder: (BuildContext context, AsyncSnapshot<Image> snapshot) {
        if (snapshot.data == null) {
          return const CircularProgressIndicator();
        }
        return Container(
            child: snapshot.data, key: const Key('PictogramImage'));
      },
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
