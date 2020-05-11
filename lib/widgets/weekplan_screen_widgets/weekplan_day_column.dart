import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/activity_state_enum.dart';
import 'package:api_client/models/enums/weekday_enum.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/weekday_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/blocs/weekplan_bloc.dart';
import 'package:weekplanner/models/enums/weekplan_mode.dart';
import 'package:weekplanner/screens/pictogram_search_screen.dart';
import 'package:weekplanner/screens/show_activity_screen.dart';

import '../../di.dart';
import '../../routes.dart';
import '../../style/custom_color.dart' as theme;
import '../giraf_button_widget.dart';
import 'activity_card.dart';

/// Widget used to create a single column in the weekplan screen.
class WeekplanDayColumn extends StatelessWidget {
  /// Constructor
  WeekplanDayColumn(
      {@required this.weekDayNumber,
      @required this.color,
      @required this.week,
      @required this.user}) {
    _settingsBloc.loadSettings(user);
  }

  /// The number of the day of the week i.e. 0 for monday.
  final int weekDayNumber;

  /// The color that the column should be painted
  final Color color;

  /// The entire weekmodel storing all information about the week
  final WeekModel week;

  final DisplayNameModel user;

  final AuthBloc _authBloc = di.getDependency<AuthBloc>();
  final WeekplanBloc _weekplanBloc = di.getDependency<WeekplanBloc>();
  final SettingsBloc _settingsBloc = di.getDependency<SettingsBloc>();

  @override
  Widget build(BuildContext context) {
    return Card(color: color, child: _day(week.days[weekDayNumber], context));
  }

  Column _day(WeekdayModel weekday, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _translateWeekDay(weekday.day),
        buildDaySelectorButtons(context, weekday),
        buildDayActivities(weekday.activities, weekday),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal:
                  MediaQuery.of(context).orientation == Orientation.portrait
                      ? MediaQuery.of(context).size.width * 0.01
                      : MediaQuery.of(context).size.height * 0.01),
          child: _createAddActivityButton(weekday),
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

    return Card(
      key: Key(translation),
      color: theme.GirafColors.buttonColor,
      child: ListTile(
        contentPadding: const EdgeInsets.all(0.0), // Sets padding in cards
        title: AutoSizeText(
          translation,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
      ),
    );
  }

  ///Builds the selector buttons day
  Container buildDaySelectorButtons(
      BuildContext context, WeekdayModel weekDay) {
    return Container(
        child: StreamBuilder<WeekplanMode>(
      stream: _authBloc.mode,
      initialData: WeekplanMode.guardian,
      builder: (BuildContext context, AsyncSnapshot<WeekplanMode> snapshot) {
        return Visibility(
          visible: snapshot.data == WeekplanMode.guardian,
          child: StreamBuilder<bool>(
            stream: _weekplanBloc.editMode,
            initialData: false,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.data) {
                return Container(
                  child: Column(children: <Widget>[
                    GirafButton(
                      text: 'Vælg alle',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 35,
                      width: 110,
                      key: const Key('SelectAllButton'),
                      onPressed: () {
                        markAllDayActivities(weekDay);
                      },
                    ),
                    const SizedBox(height: 3.5),
                    GirafButton(
                      text: 'Fravælg alle',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 35,
                      width: 110,
                      key: const Key('DeselectAllButton'),
                      onPressed: () {
                        unmarkAllDayActivities(weekDay);
                      },
                    ),
                  ]),
                );
              } else {
                return Container(width: 0.0, height: 0.0);
              }
            },
          ),
        );
      },
    ));
  }

  /// Marks all activities for a given day
  void markAllDayActivities(WeekdayModel weekdayModel) {
    for (ActivityModel activity in weekdayModel.activities) {
      if (_weekplanBloc.isActivityMarked(activity) == false) {
        _weekplanBloc.addMarkedActivity(activity);
      }
    }
  }

  /// Unmarks all activities for a given day
  void unmarkAllDayActivities(WeekdayModel weekdayModel) {
    for (ActivityModel activity in weekdayModel.activities) {
      if (_weekplanBloc.isActivityMarked(activity) == true) {
        _weekplanBloc.removeMarkedActivity(activity);
      }
    }
  }

  /// Builds a day's activities
  StreamBuilder<List<ActivityModel>> buildDayActivities(
      List<ActivityModel> activities, WeekdayModel weekday) {
    return StreamBuilder<List<ActivityModel>>(
        stream: _weekplanBloc.markedActivities,
        builder: (BuildContext context,
            AsyncSnapshot<List<ActivityModel>> markedActivities) {
          return StreamBuilder<bool>(
              initialData: false,
              stream: _weekplanBloc.editMode,
              builder:
                  (BuildContext context, AsyncSnapshot<bool> editModeSnapshot) {
                return Expanded(
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      if (index == weekday.activities.length) {
                        return StreamBuilder<bool>(
                            stream: _weekplanBloc.activityPlaceholderVisible,
                            initialData: false,
                            builder: (BuildContext context,
                                AsyncSnapshot<bool> snapshot) {
                              return Visibility(
                                key: const Key('GreyDragVisibleKey'),
                                visible: snapshot.data,
                                child: _dragTargetPlaceholder(index, weekday),
                              );
                            });
                      } else {
                        return StreamBuilder<WeekplanMode>(
                            stream: _authBloc.mode,
                            initialData: WeekplanMode.guardian,
                            builder: (BuildContext context,
                                AsyncSnapshot<WeekplanMode> snapshot) {
                              if (snapshot.data == WeekplanMode.guardian) {
                                return _dragTargetPictogram(
                                    index, weekday, editModeSnapshot.data);
                              }
                              return _pictogramIconStack(context, index,
                                  weekday, editModeSnapshot.data);
                            });
                      }
                    },
                    itemCount: weekday.activities.length + 1,
                  ),
                );
              });
        });
  }

  DragTarget<Tuple2<ActivityModel, Weekday>> _dragTargetPlaceholder(
      int dropTargetIndex, WeekdayModel weekday) {
    return DragTarget<Tuple2<ActivityModel, Weekday>>(
      key: const Key('DragTargetPlaceholder'),
      builder: (BuildContext context,
          List<Tuple2<ActivityModel, Weekday>> candidateData,
          List<dynamic> rejectedData) {
        return const AspectRatio(
          aspectRatio: 1,
          child: Card(
            color: theme.GirafColors.dragShadow,
            child: ListTile(),
          ),
        );
      },
      onWillAccept: (Tuple2<ActivityModel, Weekday> data) {
        // Draggable can be dropped on every drop target
        return true;
      },
      onAccept: (Tuple2<ActivityModel, Weekday> data) {
        _weekplanBloc.reorderActivities(
            data.item1, data.item2, weekday.day, dropTargetIndex);
      },
    );
  }

  // Returns the draggable pictograms, which also function as drop targets.
  DragTarget<Tuple2<ActivityModel, Weekday>> _dragTargetPictogram(
      int index, WeekdayModel weekday, bool inEditMode) {
    return DragTarget<Tuple2<ActivityModel, Weekday>>(
      key: const Key('DragTarget'),
      builder: (BuildContext context,
          List<Tuple2<ActivityModel, Weekday>> candidateData,
          List<dynamic> rejectedData) {
        return LongPressDraggable<Tuple2<ActivityModel, Weekday>>(
          data: Tuple2<ActivityModel, Weekday>(
              weekday.activities[index], weekday.day),
          dragAnchor: DragAnchor.pointer,
          child: _pictogramIconStack(context, index, weekday, inEditMode),
          childWhenDragging: Opacity(
              opacity: 0.5,
              child: _pictogramIconStack(context, index, weekday, inEditMode)),
          onDragStarted: () =>
              _weekplanBloc.setActivityPlaceholderVisible(true),
          onDragCompleted: () =>
              _weekplanBloc.setActivityPlaceholderVisible(false),
          onDragEnd: (DraggableDetails details) =>
              _weekplanBloc.setActivityPlaceholderVisible(false),
          feedback: Container(
              height: MediaQuery.of(context).orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.width * 0.4
                  : MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.width * 0.4
                  : MediaQuery.of(context).size.height * 0.4,
              child: _pictogramIconStack(context, index, weekday, inEditMode)),
        );
      },
      onWillAccept: (Tuple2<ActivityModel, Weekday> data) {
        // Draggable can be dropped on every drop target
        return true;
      },
      onAccept: (Tuple2<ActivityModel, Weekday> data) {
        _weekplanBloc.reorderActivities(
            data.item1, data.item2, weekday.day, index);
      },
    );
  }

  // Returning a widget that stacks a pictogram and an status icon
  FittedBox _pictogramIconStack(
      BuildContext context, int index, WeekdayModel weekday, bool inEditMode) {
    final bool isMarked =
        _weekplanBloc.isActivityMarked(weekday.activities[index]);

    return FittedBox(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          StreamBuilder<WeekplanMode>(
              stream: _authBloc.mode,
              initialData: WeekplanMode.guardian,
              builder: (BuildContext context,
                  AsyncSnapshot<WeekplanMode> modeSnapshot) {
                return StreamBuilder<SettingsModel>(
                    stream: _settingsBloc.settings,
                    builder: (BuildContext context,
                        AsyncSnapshot<SettingsModel> settingsSnapshot) {
                      if (settingsSnapshot.hasData && modeSnapshot.hasData) {
                        double _width = 1;
                        final int _daysToDisplay =
                            settingsSnapshot.data.nrOfDaysToDisplay;

                        if (MediaQuery.of(context).orientation ==
                            Orientation.portrait) {
                          if (modeSnapshot.data == WeekplanMode.citizen) {
                            if (_daysToDisplay == 1) {
                              _width = 1;
                            }
                          }
                        } else if (MediaQuery.of(context).orientation ==
                            Orientation.landscape) {
                          if (modeSnapshot.data == WeekplanMode.citizen) {
                            if (_daysToDisplay == 1) {
                              _width = 1;
                            }
                          }
                        }
                        return SizedBox(
                            // MediaQuery.of(context).size.width / 3,
                            width: MediaQuery.of(context).size.width / _width,
                            //  MediaQuery.of(context).size.width / 1,
                            child: Container(
                              child: GestureDetector(
                                key: Key(weekday.day.index.toString() +
                                    weekday.activities[index].id.toString()),
                                onTap: () {
                                  if (modeSnapshot.data ==
                                      WeekplanMode.guardian) {
                                    _handleOnTapActivity(
                                        inEditMode,
                                        isMarked,
                                        false,
                                        weekday.activities,
                                        index,
                                        context);
                                  } else {
                                    _handleOnTapActivity(false, false, true,
                                        weekday.activities, index, context);
                                  }
                                },
                                child:
                                    (modeSnapshot.data == WeekplanMode.guardian)
                                        ? _buildIsMarked(isMarked, context,
                                            weekday, weekday.activities, index)
                                        : _buildIsMarked(false, context,
                                            weekday, weekday.activities, index),
                              ),
                            ));
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    });
              }),
        ],
      ),
    );
  }

  /// Handles tap on an activity
  void _handleOnTapActivity(bool inEditMode, bool isMarked, bool isCitizen,
      List<ActivityModel> activities, int index, BuildContext context) {
    if (inEditMode) {
      if (isMarked) {
        _weekplanBloc.removeMarkedActivity(activities[index]);
      } else {
        _weekplanBloc.addMarkedActivity(activities[index]);
      }
    } else if (!(activities[index].state == ActivityState.Completed &&
        isCitizen)) {
      Routes.push(context, ShowActivityScreen(activities[index], user))
          .then((Object object) => _weekplanBloc.loadWeek(week, user));
    }
  }

  /// Builds activity card with a status icon if it is marked
  StatelessWidget _buildIsMarked(bool isMarked, BuildContext context,
      WeekdayModel weekday, List<ActivityModel> activities, int index) {
    if (isMarked) {
      return Container(
          key: const Key('isSelectedKey'),
          margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.black,
                  width: MediaQuery.of(context).size.width * 0.1)),
          child: ActivityCard(activities[index], weekday, user));
    } else {
      return ActivityCard(activities[index], weekday, user);
    }
  }

  Widget _createAddActivityButton(WeekdayModel weekday) {
    return ButtonTheme(
      child: SizedBox(
        width: double.infinity,
        child: StreamBuilder<WeekplanMode>(
            stream: _authBloc.mode,
            builder:
                (BuildContext context, AsyncSnapshot<WeekplanMode> snapshot) {
              return Visibility(
                visible: snapshot.data == WeekplanMode.guardian,
                child: RaisedButton(
                    key: const Key('AddActivityButton'),
                    child: Image.asset('assets/icons/add.png'),
                    color: theme.GirafColors.buttonColor,
                    onPressed: () async {
                      final PictogramModel newActivity =
                          await Routes.push(context, PictogramSearch());
                      if (newActivity != null) {
                        _weekplanBloc.addActivity(
                            ActivityModel(
                                id: newActivity.id,
                                pictogram: newActivity,
                                order: weekday.activities.length,
                                state: ActivityState.Active,
                                isChoiceBoard: false),
                            weekday.day.index);
                      }
                    }),
              );
            }),
      ),
    );
  }
}
