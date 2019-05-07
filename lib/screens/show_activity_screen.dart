import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/activity_bloc.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/blocs/timer_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/enums/activity_state_enum.dart';
import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:weekplanner/models/enums/weekplan_mode.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';
import 'package:weekplanner/widgets/giraf_activity_time_picker_dialog.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/giraf_confirm_dialog.dart';

/// Screen to show information about an activity, and change the state of it.
class ShowActivityScreen extends StatelessWidget {
  /// Constructor
  ShowActivityScreen(
      WeekModel weekModel, this._activity, UsernameModel girafUser,
      {Key key})
      : super(key: key) {
    _pictoImageBloc.load(_activity.pictogram);
    _activityBloc.load(weekModel, _activity, girafUser);
    _timerBloc.load(_activity);
  }

  final TimerBloc _timerBloc = di.getDependency<TimerBloc>();

  final ActivityModel _activity;

  final PictogramImageBloc _pictoImageBloc =
      di.getDependency<PictogramImageBloc>();
  final ActivityBloc _activityBloc = di.getDependency<ActivityBloc>();
  final AuthBloc _authBloc = di.getDependency<AuthBloc>();

  /// Text style used for title.
  final TextStyle titleTextStyle = const TextStyle(fontSize: 24);

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    _timerBloc.initTimer();

    ///Used to check if the keyboard is visible
    return buildScreenFromOrientation(orientation, context);
  }

  /// Build the activity screens in a row or column
  /// depending on the orientation of the device.
  Scaffold buildScreenFromOrientation(
      Orientation orientation, BuildContext context) {
    Widget childContainer;

    if (orientation == Orientation.portrait) {
      childContainer = Column(
        children: buildScreen(context),
      );
    } else if (orientation == Orientation.landscape) {
      childContainer = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: buildScreen(context),
      );
    }
    final bool keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
        appBar: GirafAppBar(
          title: 'Aktivitet',
            appBarIcons: const <AppBarIcon, VoidCallback>{}),
        body: keyboardVisible ? Container() : childContainer);
  }

  /// Builds the activity.
  List<Widget> buildScreen(BuildContext context) {
    return <Widget>[
      Expanded(
        flex: 6,
        child: Center(
          child: AspectRatio(
            aspectRatio: 1,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: buildActivity(context),
            ),
          ),
        ),
      ),
      Expanded(
        flex: 4,
        child: Center(
          child: AspectRatio(
            aspectRatio: 1,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: buildTimer(context),
            ),
          ),
        ),
      ),
    ];
  }

  /// Builds the activity widget.
  Card buildActivity(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          const Center(child: Padding(padding: EdgeInsets.all(8.0))),
          Expanded(
            child: FittedBox(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromRGBO(35, 35, 35, 1.0),
                        width: 0.25)),
                child: StreamBuilder<ActivityModel>(
                  stream: _activityBloc.activityModelStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<ActivityModel> snapshot) {
                    if (snapshot.data == null) {
                      return const CircularProgressIndicator();
                    }
                    return Stack(
                      alignment: AlignmentDirectional.center,
                      children: <Widget>[
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width,
                            child: buildLoadPictogramImage()),
                        _buildActivityStateIcon(context, snapshot.data.state)
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the timer widget.
  StreamBuilder<WeekplanMode> buildTimer(BuildContext overallContext) {
    return StreamBuilder<WeekplanMode>(
        stream: _authBloc.mode,
        builder: (BuildContext modeContext,
            AsyncSnapshot<WeekplanMode> modeSnapshot) {
          return StreamBuilder<bool>(
              stream: _timerBloc.timerIsInstantiated,
              builder: (BuildContext timerInitContext,
                  AsyncSnapshot<bool> timerInitSnapshot) {
                //if a timer is not initiated, and the app is in citizen mode,
                //nothing is shown
                return Visibility(
                  visible: (timerInitSnapshot.hasData && modeSnapshot.hasData)
                      ? timerInitSnapshot.data ||
                          (!timerInitSnapshot.data &&
                              modeSnapshot.data == WeekplanMode.guardian)
                      : false,
                  child: Card(
                    key: const Key('OverallTimerBoxKey'),
                    child: Column(children: <Widget>[
                      //the title of the timer widget
                      Center(
                          key: const Key('TimerTitleKey'),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Timer',
                                style: titleTextStyle,
                                textAlign: TextAlign.center),
                          )),
                      Expanded(
                          //depending on whether a timer is initiated, different
                          //widgets are shown.
                          child: (timerInitSnapshot.hasData
                                  ? timerInitSnapshot.data
                                  : false)
                              ? _timerIsInitiatedWidget()
                              : _timerIsNotInitiatedWidget(
                                  overallContext, modeSnapshot)),
                      _timerButtons(
                          overallContext, timerInitSnapshot, modeSnapshot)
                    ]),
                  ),
                );
              });
        });
  }

  ///The widget to show, in the case that a timer has been initiated,
  ///showing the progression for the timer in both citizen and guardian mode.
  Widget _timerIsInitiatedWidget() {
    return FittedBox(
      key: const Key('TimerInitKey'),
      child: StreamBuilder<double>(
        stream: _timerBloc.timerProgressStream,
        builder: (BuildContext timerProgressContext,
            AsyncSnapshot<double> timerProgressSnapshot) {
          return Container(
            decoration: const ShapeDecoration(
                shape: CircleBorder(
                    side: BorderSide(color: Colors.black, width: 0.5))),
            child: CircleAvatar(
              backgroundColor: Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: CircularProgressIndicator(
                  strokeWidth: 30,
                  value: timerProgressSnapshot.hasData
                      ? timerProgressSnapshot.data
                      : 0.0,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  ///the widget to show, in the case that a timer has not been initiated
  ///for the activity. When in guardian mode, an "addtimer" button is shown,
  ///as citizen, nothing is shown.
  Widget _timerIsNotInitiatedWidget(
      BuildContext overallContext, AsyncSnapshot<WeekplanMode> modeSnapshot) {
    return (modeSnapshot.hasData
            ? (modeSnapshot.data == WeekplanMode.guardian)
            : false)
        ? FittedBox(
            key: const Key('TimerNotInitGuardianKey'),
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                  child: IconButton(
                    key: const Key('AddTimerButtonKey'),
                      icon: const ImageIcon(
                          AssetImage('assets/icons/addTimerHighRes.png')),
                      onPressed: () {
                        _buildTimerDialog(overallContext);
                      })),
            ))
        : Container(
            key: const Key('TimerNotInitCitizenKey'),
          );
  }

  ///the buttons for the timer. Depending on whether the application is in
  ///citizen or guardian mode, certain buttons are displayed.
  ///Buttons are: Play/Pause, Stop and delete
  Widget _timerButtons(
      BuildContext overallContext,
      AsyncSnapshot<bool> timerInitSnapshot,
      AsyncSnapshot<WeekplanMode> modeSnapshot) {
    return Visibility(
      visible: timerInitSnapshot.hasData ? timerInitSnapshot.data : false,
      key: const Key('TimerOverallButtonVisibilityKey'),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          child: Row(
            key: const Key('TimerButtonRow'),
            children: <Widget>[
              StreamBuilder<bool>(
                  stream: _timerBloc.timerIsRunning,
                  builder: (BuildContext timerRunningContext,
                      AsyncSnapshot<bool> timerRunningSnapshot) {
                    return Flexible(
                      //button has different icons and press logic depending on
                      //whether the timer is already running.
                      child: GirafButton(
                        key: (timerRunningSnapshot.hasData
                                ? timerRunningSnapshot.data
                                : false)
                            ? const Key('TimerPauseButtonKey')
                            : const Key('TimerPlayButtonKey'),
                        onPressed: () {
                          (timerRunningSnapshot.hasData
                                  ? timerRunningSnapshot.data
                                  : false)
                              ? _timerBloc.pauseTimer()
                              : _timerBloc.playTimer();
                        },
                        icon: (timerRunningSnapshot.hasData
                                ? timerRunningSnapshot.data
                                : false)
                            ? const ImageIcon(
                                AssetImage('assets/icons/pause.png'))
                            : const ImageIcon(
                                AssetImage('assets/icons/play.png')),
                      ),
                    );
                  }),
              Flexible(
                child: GirafButton(
                  key: const Key('TimerStopButtonKey'),
                  onPressed: () {
                    showDialog<Center>(
                        context: overallContext,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          //a dialog is shown to confirm to stop the timer.
                          return GirafConfirmDialog(
                            key: const Key('TimerStopConfirmDialogKey'),
                            title: 'Stop Timer',
                            description: 'Vil du stoppe timeren?',
                            confirmButtonText: 'stop',
                            confirmButtonIcon: const ImageIcon(
                                AssetImage('assets/icons/stop.png')),
                            confirmOnPressed: () {
                              _timerBloc.stopTimer();
                              Routes.pop(context);
                            },
                          );
                        });
                  },
                  icon: const ImageIcon(AssetImage('assets/icons/stop.png')),
                ),
              ),
              Visibility(
                //the delete button is only visible when in guardian mode,
                //since a citizen should not be able to delete the timer.
                visible: modeSnapshot.data == WeekplanMode.guardian,
                child: Flexible(
                  child: GirafButton(
                    key: const Key('TimerDeleteButtonKey'),
                    onPressed: () {
                      showDialog<Center>(
                          context: overallContext,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            //a dialog is shown to confirm to delete the timer.
                            return GirafConfirmDialog(
                              key: const Key('TimerDeleteConfirmDialogKey'),
                              title: 'Slet Timer',
                              description: 'Vil du slette timeren?',
                              confirmButtonText: 'Slet',
                              confirmButtonIcon: const ImageIcon(
                                  AssetImage('assets/icons/delete.png')),
                              confirmOnPressed: () {
                                _timerBloc.deleteTimer();
                                Routes.pop(context);
                              },
                            );
                          });
                    },
                    icon:
                        const ImageIcon(AssetImage('assets/icons/delete.png')),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// returns a dialog where time can be decided for an activity(timer)
  void _buildTimerDialog(BuildContext context) {
    showDialog<Center>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return GirafActivityTimerPickerDialog(_activity, _timerBloc);
        });
  }

  /// Builds the button that changes the state of the activity. The content
  /// of the button depends on whether it is in guardian or citizen mode.
  ButtonBar buildButtonBar() {
    return ButtonBar(
        // Key used for testing widget.
        key: const Key('ButtonBarRender'),
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          StreamBuilder<WeekplanMode>(
            stream: _authBloc.mode,
            builder: (BuildContext context,
                AsyncSnapshot<WeekplanMode> weekplanModeSnapshot) {
              return StreamBuilder<ActivityModel>(
                  stream: _activityBloc.activityModelStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<ActivityModel> activitySnapshot) {
                    if (activitySnapshot.data == null) {
                      return const CircularProgressIndicator();
                    }
                    if (weekplanModeSnapshot.data == WeekplanMode.guardian) {
                      return GirafButton(
                          key: const Key('CancelStateToggleButton'),
                          onPressed: () {
                            _activityBloc.cancelActivity();
                          },
                          width: 100,
                          icon: activitySnapshot.data.state !=
                                  ActivityState.Canceled
                              ? const ImageIcon(
                                  AssetImage('assets/icons/cancel.png'),
                                  color: Colors.red)
                              : const ImageIcon(
                                  AssetImage('assets/icons/undo.png'),
                                  color: Colors.blue));
                    } else {
                      return GirafButton(
                          key: const Key('CompleteStateToggleButton'),
                          onPressed: () {
                            _activityBloc.completeActivity();
                          },
                          isEnabled: activitySnapshot.data.state !=
                              ActivityState.Canceled,
                          width: 100,
                          icon: activitySnapshot.data.state !=
                                  ActivityState.Completed
                              ? const ImageIcon(
                                  AssetImage('assets/icons/accept.png'),
                                  color: Colors.green)
                              : const ImageIcon(
                                  AssetImage('assets/icons/undo.png'),
                                  color: Colors.blue));
                    }
                  });
            },
          ),
        ]);
  }

  /// Creates a pictogram image from the streambuilder
  Widget buildLoadPictogramImage() {
    return StreamBuilder<Image>(
      stream: _pictoImageBloc.image,
      builder: (BuildContext context, AsyncSnapshot<Image> snapshot) {
        return FittedBox(
            child: snapshot.data,
            // Key is used for testing the widget.
            key: Key(_activity.id.toString()));
      },
    );
  }

  /// Builds the icon that displays the activity's state
  Widget _buildActivityStateIcon(BuildContext context, ActivityState state) {
    if (state == ActivityState.Completed) {
      return Icon(
        Icons.check,
        key: const Key('IconCompleted'),
        color: Colors.green,
        size: MediaQuery.of(context).size.width,
      );
    } else if (state == ActivityState.Canceled) {
      return Icon(
        Icons.clear,
        key: const Key('IconCanceled'),
        color: Colors.red,
        size: MediaQuery.of(context).size.width,
      );
    } else {
      return Container();
    }
  }
}
