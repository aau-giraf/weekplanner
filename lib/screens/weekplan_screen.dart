import 'package:api_client/models/weekday_model.dart';
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
import 'package:weekplanner/widgets/bottom_app_bar_button_widget.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_confirm_dialog.dart';
import 'package:weekplanner/screens/pictogram_search_screen.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:tuple/tuple.dart';
import 'package:weekplanner/widgets/giraf_copy_activities_dialog.dart';

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
    _weekplanBloc.setWeek(_week, _user);
  }

  final WeekplanBloc _weekplanBloc = di.getDependency<WeekplanBloc>();
  final AuthBloc _authBloc = di.getDependency<AuthBloc>();
  final UsernameModel _user;
  final WeekModel _week;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<WeekplanMode>(
        stream: _authBloc.mode,
        builder: (BuildContext context,
            AsyncSnapshot<WeekplanMode> weekModeSnapshot) {
          if (weekModeSnapshot.data == WeekplanMode.citizen) {
            _weekplanBloc.setEditMode(false);
          }
          return Scaffold(
            appBar: GirafAppBar(
              title: 'Ugeplan',
              appBarIcons: (weekModeSnapshot.data == WeekplanMode.guardian)
                  ? <AppBarIcon, VoidCallback>{
                      AppBarIcon.edit: () => _weekplanBloc.toggleEditMode(),
                      AppBarIcon.changeToCitizen: () {},
                      AppBarIcon.settings: () {},
                      AppBarIcon.logout: () {}
                    }
                  : <AppBarIcon, VoidCallback>{
                      AppBarIcon.changeToGuardian: () {}
                    },
            ),
            body: StreamBuilder<UserWeekModel>(
              stream: _weekplanBloc.userWeek,
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
            bottomNavigationBar: StreamBuilder<WeekplanMode>(
              stream: _authBloc.mode,
              initialData: WeekplanMode.guardian,
              builder:
                  (BuildContext context, AsyncSnapshot<WeekplanMode> snapshot) {
                return Visibility(
                  visible: snapshot.data == WeekplanMode.guardian,
                  child: StreamBuilder<bool>(
                    stream: _weekplanBloc.editMode,
                    initialData: false,
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      if (snapshot.data) {
                        return buildBottomAppBar(context);
                      } else {
                        return Container(width: 0.0, height: 0.0);
                      }
                    },
                  ),
                );
              },
            ),
          );
        });
  }

  /// Builds the BottomAppBar when in edit mode
  BottomAppBar buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
        child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: <double>[
                        1 / 3,
                        2 / 3
                      ],
                          colors: <Color>[
                        Color.fromRGBO(254, 215, 108, 1),
                        Color.fromRGBO(253, 187, 85, 1),
                      ])),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      BottomAppBarButton(
                          buttonText: 'Annuller',
                          buttonKey: 'CancelActivtiesButton',
                          assetPath: 'assets/icons/cancel.png',
                          dialogFunction: _buildCancelDialog),
                      BottomAppBarButton(
                          buttonText: 'Kopier',
                          buttonKey: 'CopyActivtiesButton',
                          assetPath: 'assets/icons/copy.png',
                          dialogFunction: _buildCopyDialog),
                      BottomAppBarButton(
                          buttonText: 'Slet',
                          buttonKey: 'DeleteActivtiesButton',
                          assetPath: 'assets/icons/delete.png',
                          dialogFunction: _buildRemoveDialog)
                    ],
                  )))
        ]));
  }

  void _copyActivities(List<bool> days, BuildContext context) {
    _weekplanBloc.copyMarkedActivities(days);
    Routes.pop(context);
    _weekplanBloc.toggleEditMode();
  }

  Future<Center> _buildCopyDialog(BuildContext context) {
    return showDialog<Center>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return GirafCopyActivitiesDialog(
            title: 'Kopier aktiviteter',
            description: 'Vælg hvilke dage de markerede aktiviteter skal '
                'kopieres til',
            confirmButtonText: 'Kopier',
            confirmButtonIcon:
                const ImageIcon(AssetImage('assets/icons/accept.png')),
            confirmOnPressed: _copyActivities,
          );
        });
  }
  /// Builds dialog box to confirm/cancel deletion
  Future<Center> _buildRemoveDialog(BuildContext context) {
    return showDialog<Center>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return GirafConfirmDialog(
              title: 'Bekræft',
              description: 'Vil du slette ' +
                  _weekplanBloc.getNumberOfMarkedActivities().toString() +
                  ' aktivitet(er)',
              confirmButtonText: 'Bekræft',
              confirmButtonIcon:
              const ImageIcon(AssetImage('assets/icons/accept.png')),
              confirmOnPressed: () {
                _weekplanBloc.deleteMarkedActivities();
                _weekplanBloc.toggleEditMode();

                // Closes the dialog box
                Routes.pop(context);
              });
        });
  }


  /// Builds the dialog box to confirm marking activities as canceled
  Future<Center> _buildCancelDialog(BuildContext context) {
    return showDialog<Center>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return GirafConfirmDialog(
              title: 'Bekræft',
              description: 'Vil du markere ' +
                  _weekplanBloc.getNumberOfMarkedActivities().toString() +
                  ' aktivitet(er) som annulleret',
              confirmButtonText: 'Bekræft',
              confirmButtonIcon:
                  const ImageIcon(AssetImage('assets/icons/accept.png')),
              confirmOnPressed: () {
                _weekplanBloc.cancelMarkedActivities();
                _weekplanBloc.toggleEditMode();

                // Closes the dialog box
                Routes.pop(context);
              });
        });
  }

  /// Builds dialog box to confirm/cancel deletion
  Future<Center> buildShowDialog(BuildContext context) {
    return showDialog<Center>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return GirafConfirmDialog(
              title: 'Bekræft',
              description: 'Vil du slette ' +
                  _weekplanBloc.getNumberOfMarkedActivities().toString() +
                  ' aktivitet(er)',
              confirmButtonText: 'Bekræft',
              confirmButtonIcon:
                  const ImageIcon(AssetImage('assets/icons/accept.png')),
              confirmOnPressed: () {
                _weekplanBloc.deleteMarkedActivities();
                _weekplanBloc.toggleEditMode();

                // Closes the dialog box
                Routes.pop(context);
              });
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
              child: _day(weekModel.days[i], context))));
    }
    return Row(children: weekDays);
  }

  Column _day(WeekdayModel weekday, BuildContext context) {
    return Column(
      children: <Widget>[
        _translateWeekDay(weekday.day),
        buildDayActivities(weekday.activities, weekday),
        Container(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: ButtonTheme(
            child: SizedBox(
              width: double.infinity,
              child: StreamBuilder<WeekplanMode>(
                  stream: _authBloc.mode,
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
          ),
        ),
      ],
    );
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

  /// Handles tap on a activity
  void handleOnTapActivity(bool inEditMode, bool isMarked,
      List<ActivityModel> activities, int index, BuildContext context) {
    if (inEditMode) {
      if (isMarked) {
        _weekplanBloc.removeMarkedActivity(activities[index]);
      } else {
        _weekplanBloc.addMarkedActivity(activities[index]);
      }
    } else {
      Routes.push(context, ShowActivityScreen(activities[index], _user));
    }
  }

  /// Builds activity card with a complete if is marked
  StatelessWidget buildIsMarked(bool isMarked, BuildContext context,
      List<ActivityModel> activities, int index) {
    if (isMarked) {
      return Container(
          key: const Key('isSelectedKey'),
          margin: const EdgeInsets.all(20),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.black, width: 50)),
          child: _buildActivityCard(
            context,
            activities,
            index,
            activities[index].state,
          ));
    } else {
      return _buildActivityCard(
          context, activities, index, activities[index].state);
    }
  }

  // Returns the grayed out drag targets in the end of the columns.
  DragTarget<Tuple2<ActivityModel, Weekday>> _dragTargetPlaceholder(
      int dropTargetIndex, WeekdayModel weekday) {
    return DragTarget<Tuple2<ActivityModel, Weekday>>(
      key: const Key('DragTargetPlaceholder'),
      builder: (BuildContext context,
          List<Tuple2<ActivityModel, Weekday>> candidateData,
          List<dynamic> rejectedData) {
        return AspectRatio(
          aspectRatio: 1,
          child: Card(
            color: const Color.fromRGBO(200, 200, 200, 0.5),
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
              height: 150,
              width: 150,
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

  // Returning a widget that stacks a pictogram and an accept icon
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
              builder:
                  (BuildContext context, AsyncSnapshot<WeekplanMode> snapshot) {
                return SizedBox(
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    child: FittedBox(
                      child: GestureDetector(
                        key: Key(weekday.day.index.toString() +
                            weekday.activities[index].id.toString()),
                        onTap: () {
                          if (snapshot.data == WeekplanMode.guardian) {
                            handleOnTapActivity(inEditMode, isMarked,
                                weekday.activities, index, context);
                          } else {
                            handleOnTapActivity(false, false,
                                weekday.activities, index, context);
                          }
                        },
                        child: (snapshot.data == WeekplanMode.guardian)
                            ? buildIsMarked(
                                isMarked, context, weekday.activities, index)
                            : buildIsMarked(
                                false, context, weekday.activities, index),
                      ),
                    ));
              }),
        ],
      ),
    );
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

  /// Builds card that displays the activity
  Card _buildActivityCard(
    BuildContext context,
    List<ActivityModel> activities,
    int index,
    ActivityState activityState,
  ) {
    Widget icon;
    switch (activityState) {
      case ActivityState.Completed:
        icon = Icon(
          Icons.check,
          key: const Key('IconComplete'),
          color: Colors.green,
          size: MediaQuery.of(context).size.width,
        );
        break;
      case ActivityState.Canceled:
        icon = Icon(
          Icons.clear,
          key: const Key('IconCanceled'),
          color: Colors.red,
          size: MediaQuery.of(context).size.width,
        );
        break;
      default:
        icon = Container();
        break;
    }

    return Card(
        margin: const EdgeInsets.all(20),
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
              icon
            ],
          ),
        ));
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
        ),
      ),
    );
  }
}
