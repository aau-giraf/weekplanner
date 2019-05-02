import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/activity_bloc.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/enums/activity_state_enum.dart';
import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:weekplanner/models/enums/weekplan_mode.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/giraf_title_header.dart';

/// Screen to show information about an activity, and change the state of it.
class ShowActivityScreen extends StatelessWidget {
  /// Constructor
  ShowActivityScreen(
      WeekModel weekModel, this._activity, UsernameModel girafUser,
      {Key key})
      : super(key: key) {
    _pictoImageBloc.load(_activity.pictogram);
    _activityBloc.load(weekModel, _activity, girafUser);
  }

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
        child: StreamBuilder<double>(
            stream: _activityBloc.timerProgressStream,
            builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
              return FittedBox(
                child: Container(
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
                        valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          child: Row(
            children: <Widget>[
              Flexible(
                child: GirafButton(
                  onPressed: () {
                    _activityBloc.playTimer();
                  },
                  icon: _activityBloc.timerIsPlaying()
                      ? const ImageIcon(AssetImage('assets/icons/play.png'))
                      : const ImageIcon(AssetImage('assets/icons/pause.png')),
                ),
              ),
              Flexible(
                child: GirafButton(
                  onPressed: () {
                    _activityBloc.pauseTimer();
                  },
                  icon: const ImageIcon(AssetImage('assets/icons/stop.png')),
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
                            _activityBloc.stopTimer();
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
      )
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
  Widget buildTimerDialog(BuildContext context) {
    final bool keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    final bool isInPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final TextEditingController txtController = TextEditingController();
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0.0),
      titlePadding: const EdgeInsets.all(0.0),
      shape:
          Border.all(color: const Color.fromRGBO(112, 112, 112, 1), width: 5.0),
      title: const Center(
          child: GirafTitleHeader(
        title: 'Vælg tid for aktivitet',
      )),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Center(child: Text('Indtast tid')),
          const Center(
            child: Text(
              'Timer : Minutter : Sekunder',
              style: TextStyle(
                  fontSize: 10, color: Color.fromRGBO(170, 170, 170, 1)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  color: Colors.white),
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
              child: TextField(
                key: const Key('TimerKey'),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                controller: txtController,
                textDirection: TextDirection.ltr,
                cursorColor: Colors.white,
                decoration: const InputDecoration.collapsed(
                  hintText: '00:00',
                  hintStyle: TextStyle(color: Color.fromRGBO(170, 170, 170, 1)),
                  fillColor: Colors.white,
                ),
                onChanged: (String input) {
                  String placeholderText;
                  String stringToAddd = '';
                  if (input.length == 1) {
                    txtController.text = '00:0' + input;
                  } else {
                    placeholderText = input.substring(0, input.length);
                    placeholderText = placeholderText.replaceAll(':', '');
                    for (int i = 0; i < placeholderText.length; i++) {
                      if (placeholderText.substring(i, i + 1) != '0') {
                        if (placeholderText.length - i == 2) {
                          stringToAddd = '00:' +
                              placeholderText.substring(
                                  i, placeholderText.length);
                          break;
                        } else if (placeholderText.length < 4) {
                          stringToAddd = '0' + placeholderText;
                          stringToAddd = stringToAddd.replaceRange(
                              stringToAddd.length - 2,
                              stringToAddd.length,
                              ':' +
                                  stringToAddd.substring(
                                      stringToAddd.length - 2,
                                      stringToAddd.length));
                          break;
                        } else {
                          stringToAddd = placeholderText;
                          if (stringToAddd.length > 4) {
                            if (stringToAddd.substring(0, 1) == '0') {
                              stringToAddd =
                                  stringToAddd.replaceRange(0, 1, '');
                            } else {
                              stringToAddd = stringToAddd.replaceRange(
                                  stringToAddd.length - 4,
                                  stringToAddd.length - 2,
                                  ':' +
                                      stringToAddd.substring(
                                          stringToAddd.length - 4,
                                          stringToAddd.length - 2));
                            }
                          }
                          stringToAddd = stringToAddd.replaceRange(
                              stringToAddd.length - 2,
                              stringToAddd.length,
                              ':' +
                                  stringToAddd.substring(
                                      stringToAddd.length - 2,
                                      stringToAddd.length));
                          break;
                        }
                      }
                    }
                    txtController.text = stringToAddd;
                  }
                  txtController.selection = TextSelection.collapsed(
                      offset: txtController.text.length);
                },
              ),
            ),
          ),
          Visibility(
            visible: (isInPortrait && !keyboardVisible) ||
                (isInPortrait && keyboardVisible) ||
                (!isInPortrait && !keyboardVisible),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 5, 10),
                      child: GirafButton(
                        onPressed: () => Routes.pop(context),
                        icon: const ImageIcon(
                            AssetImage('assets/icons/cancel.png')),
                      )),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 10, 10),
                      child: GirafButton(
                        onPressed: () => null,
                        icon: const ImageIcon(
                            AssetImage('assets/icons/accept.png')),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
