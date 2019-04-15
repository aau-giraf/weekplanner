import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/activity_bloc.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/enums/activity_state_enum.dart';
import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

/// Screen to show information about an activity, and change the state of it.
class ShowActivityScreen extends StatelessWidget {
  /// Constructor
  ShowActivityScreen(this._weekModel, this._activity, this._girafUser,
      {Key key})
      : super(key: key) {
    _pictoImageBloc.load(_activity.pictogram);
    _activityBloc.load(_weekModel, _activity, _girafUser);
  }

  final WeekModel _weekModel;
  final ActivityModel _activity;
  final UsernameModel _girafUser;

  final PictogramImageBloc _pictoImageBloc =
      di.getDependency<PictogramImageBloc>();
  final ActivityBloc _activityBloc = di.getDependency<ActivityBloc>();

  /// Text style used for title.
  final TextStyle titleTextStyle = const TextStyle(fontSize: 24);

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;

    return buildScreenFromOrientation(orientation);
  }

  /// Build the activity and timer screens in a row or column
  /// depending on the orientation of the device.
  Scaffold buildScreenFromOrientation(Orientation orientation) {
    Widget childContainer;

    if (orientation == Orientation.portrait) {
      childContainer = Column(
        children: buildScreen(),
      );
    } else if (orientation == Orientation.landscape) {
      childContainer = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: buildScreen(),
      );
    }

    return Scaffold(
        appBar: GirafAppBar(
          title: 'Aktivitet',
        ),
        body: childContainer);
  }

  /// Builds the activity and timer cards.
  List<Widget> buildScreen() {
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
                  children: buildActivity(),
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
        child: FittedBox(
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromRGBO(35, 35, 35, 1.0),
                        width: 0.25)),
                child: const Icon(Icons.timer))),
      ),
      Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            child: OutlineButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                onPressed: null,
                color: Colors.green,
                child: const Text(
                  'Start',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                )),
          ))
    ];
  }

  /// Builds the activity widget.
  List<Widget> buildActivity() {
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
                        children: <Widget>[
                          SizedBox(
                              width: MediaQuery.of(context).size.width,
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
      buildButtonBar()
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
}
