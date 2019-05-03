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

  final ActivityModel _activity;

  final PictogramImageBloc _pictoImageBloc =
      di.getDependency<PictogramImageBloc>();
  final ActivityBloc _activityBloc = di.getDependency<ActivityBloc>();
  final TimerBloc _timerBloc = TimerBloc();

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

    return Scaffold(
        appBar: GirafAppBar(
          title: 'Aktivitet',
          appBarIcons: const <AppBarIcon>[],
        ),
        body: childContainer);
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
              child: Card(
                child: Column(
                  children: buildActivity(context),
                ),
              ),
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
              child: Card(
                child: Column(
                  children: buildTimer(),
                ),
              ),
            ),
          ),
        ),
      )
    ];
  }

  /// Builds the activity widget.
  List<Widget> buildActivity(BuildContext context) {
    return <Widget>[
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
                          snapshot.data.state == ActivityState.Completed
                              ? Icon(
                                  Icons.check,
                                  key: const Key('IconComplete'),
                                  color: Colors.green,
                                  size: MediaQuery.of(context).size.width,
                                )
                              : Container()
                        ],
                      );
                    }))),
      ),
      buildButtonBar(),
    ];
  }

  /// Builds the timer widget.
  List<Widget> buildTimer() {
    return <Widget>[
      Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            Text('Timer', style: titleTextStyle, textAlign: TextAlign.center),
      )),
      Expanded(
        child: StreamBuilder<bool>(
          stream: _timerBloc.timerIsInstantiated,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            return !snapshot.data
                ? FittedBox(
                    child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      child: IconButton(
                          icon: const ImageIcon(
                              AssetImage('assets/icons/addTimerHighRes.png')),
                          onPressed: () {
                            buildTimerDialog(context);
                          }),
                    ),
                  ))
                : FittedBox(
                    child: StreamBuilder<Object>(
                      stream: _timerBloc.timerProgressStream,
                      builder: (context, snapshot) {
                        return Container(
                          decoration: const ShapeDecoration(
                              shape: CircleBorder(
                                  side: BorderSide(
                                      color: Colors.black, width: 0.5))),
                          child: CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 30,
                                value: snapshot.data,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
          },
        ),
      ),
      StreamBuilder<bool>(
          stream: _timerBloc.timerIsInstantiated,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            return Visibility(
              visible: snapshot.data,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  child: Row(
                    children: <Widget>[
                      StreamBuilder<bool>(
                          stream: _timerBloc.timerIsRunning,
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> snapshot) {
                            return Flexible(
                                child: GirafButton(
                                    onPressed: () {
                                      snapshot.data
                                          ? _timerBloc.pauseTimer()
                                          : _timerBloc.playTimer();
                                    },
                                    icon: snapshot.data
                                        ? const ImageIcon(AssetImage(
                                            'assets/icons/pause.png'))
                                        : const ImageIcon(AssetImage(
                                            'assets/icons/play.png'))));
                          }),
                      Flexible(
                        child: GirafButton(
                          onPressed: () {
                            showDialog<Center>(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context){
                                  return GirafConfirmDialog(
                                    title: 'Stop Timer',
                                    description: 'Vil du stoppe ' +
                                        'timeren?',
                                    confirmButtonText: 'stop',
                                    confirmButtonIcon: const ImageIcon(
                                        AssetImage(
                                            'assets/icons/stop.png')),
                                    confirmOnPressed: () {
                                      _timerBloc.stopTimer();
                                      Routes.pop(context);
                                    },
                                  );
                                });
                          },
                          icon: const ImageIcon(
                              AssetImage('assets/icons/stop.png')),
                        ),
                      ),
                      StreamBuilder<WeekplanMode>(
                          stream: _authBloc.mode,
                          builder: (BuildContext context,
                              AsyncSnapshot<WeekplanMode> snapshot) {
                            return Visibility(
                              visible: snapshot.data == WeekplanMode.guardian,
                              child: Flexible(
                                child: GirafButton(
                                  onPressed: () {
                                    showDialog<Center>(
                                        context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context){
                                          return GirafConfirmDialog(
                                            title: 'Slet Timer',
                                            description: 'Vil du slette ' +
                                                'timeren?',
                                            confirmButtonText: 'Slet',
                                            confirmButtonIcon: const ImageIcon(
                                                AssetImage(
                                                    'assets/icons/delete.png')),
                                            confirmOnPressed: () {
                                              _timerBloc.deleteTimer();
                                              Routes.pop(context);
                                            },
                                          );
                                    });
                                  },
                                  icon: const ImageIcon(
                                      AssetImage('assets/icons/delete.png')),
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ),
            );
          })
    ];
  }

  /// Builds the buttons below the activity widget.
  ButtonBar buildButtonBar() {
    return ButtonBar(
      // Key used for testing widget.
      key: const Key('ButtonBarRender'),
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        StreamBuilder<ActivityModel>(
            stream: _activityBloc.activityModelStream,
            builder:
                (BuildContext context, AsyncSnapshot<ActivityModel> snapshot) {
              if (snapshot.data == null) {
                return const CircularProgressIndicator();
              }
              return OutlineButton(
                  key: const Key('CompleteStateToggleButton'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  onPressed: () {
                    _activityBloc.completeActivity();
                  },
                  child: snapshot.data.state != ActivityState.Completed
                      ? const Icon(Icons.check, color: Colors.green)
                      : const Icon(
                          Icons.undo,
                          color: Colors.blue,
                        ));
            }),
      ],
    );
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
        });
  }

  /// returns a dialog where time can be decided for an activity(timer)
  void buildTimerDialog(BuildContext context) {
    showDialog<Center>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return GirafActivityTimerPickerDialog(_activity);
        });
  }
}
