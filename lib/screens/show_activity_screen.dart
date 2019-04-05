import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/activity_bloc.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/activity_model.dart';
import 'package:weekplanner/models/enums/activity_state_enum.dart';
import 'package:weekplanner/models/username_model.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

///
class ShowActivityScreen extends StatefulWidget {
  ///
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

  @override
  State<StatefulWidget> createState() {
    return _ShowActivityScreen();
  }
}

class _ShowActivityScreen extends State<ShowActivityScreen> {
  /// Text style used for title.
  final TextStyle titleTextStyle = TextStyle(fontSize: 24);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final Orientation orientation = MediaQuery.of(context).orientation;

    return buildScreenFromOrientation(screenSize, orientation);
  }

  /// Build the activity and timer screens in a row or column
  /// depending on the orientation of the device.
  Scaffold buildScreenFromOrientation(
      Size screenSize, Orientation orientation) {
    Widget childContainer;

    if (orientation == Orientation.portrait) {
      childContainer = Column(
        children: buildScreen(screenSize, orientation),
      );
    } else if (orientation == Orientation.landscape) {
      childContainer = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: buildScreen(screenSize, orientation),
      );
    }

    return Scaffold(
        appBar: GirafAppBar(
          title: 'Aktivitet',
        ),
        body: childContainer);
  }

  /// Builds the activity and timer cards.
  List<Widget> buildScreen(Size screenSize, Orientation orientation) {
    return <Widget>[
      Expanded(
        flex: 6,
        child: Center(
          child: AspectRatio(
            aspectRatio: 10.0 / 10.0,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                child: Column(
                  children: buildActivity(screenSize, orientation),
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
            aspectRatio: 10.0 / 10.0,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                child: Column(
                  children: buildTimer(screenSize, orientation),
                ),
              ),
            ),
          ),
        ),
      )
    ];
  }

  /// Builds the timer widget.
  List<Widget> buildTimer(Size screenSize, Orientation orientation) {
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
                child: Text(
                  'Start',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                )),
          ))
    ];
  }

  /// Builds the activity widget.
  List<Widget> buildActivity(Size screenSize, Orientation orientation) {
    return <Widget>[
      Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Aktivitet',
            style: titleTextStyle, textAlign: TextAlign.center),
      )),
      Expanded(
        child: FittedBox(
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromRGBO(35, 35, 35, 1.0),
                        width: 0.25)),
                child: Stack(
                  children: <Widget>[
                    buildLoadPictogramImage(),
                    widget._activity.state == ActivityState.Completed
                        ? const Icon(Icons.check,
                            color: Colors.green, size: 280)
                        : Container()
                  ],
                ))),
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
        widget._activity.state == ActivityState.Completed
            ? OutlineButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                onPressed: null,
                child: const Icon(Icons.check, color: Colors.grey),
              )
            : OutlineButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                onPressed: () {
                  widget._activityBloc.completeActivity();
                  setState(() {});
                },
                child: const Icon(Icons.check, color: Colors.green)),
        /*OutlineButton( // The cancel button is prepared under, a check should just be made to check if the user is a guardian
          shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          onPressed: () => _activityBloc.cancelActivity(),
          child: const Icon(
            Icons.cancel,
            color: Colors.red,
          )
        )*/
      ],
    );
  }

  /// Creates a pictogram image from the streambuilder
  Widget buildLoadPictogramImage() {
    return StreamBuilder<Image>(
      stream: widget._pictoImageBloc.image,
      builder: (BuildContext context, AsyncSnapshot<Image> snapshot) {
        return Container(child: snapshot.data,
        // Key is used for testing the widget.
        key: Key(widget._activity.id.toString()));
      }
    );
  }
}
