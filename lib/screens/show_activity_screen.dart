import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/activity_bloc.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/activity_model.dart';
import 'package:weekplanner/models/giraf_user_model.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

/// Screen to show activity, mark done/canceled and see timer.
class ShowActivityScreen extends StatelessWidget {
  ///
  ShowActivityScreen(this._weekModel, this._activity, this._girafUserModel,
      {Key key})
      : super(key: key) {
    _pictoImageBloc.load(_activity.pictogram);
    _activityBloc.load(_weekModel, _activity, _girafUserModel);
  }

  final WeekModel _weekModel;
  final ActivityModel _activity;
  final GirafUserModel _girafUserModel;

  final PictogramImageBloc _pictoImageBloc =
      di.getDependency<PictogramImageBloc>();

  final ActivityBloc _activityBloc = di.getDependency<ActivityBloc>();

  /// Text style used for title
  final TextStyle titleTextStyle = TextStyle(fontSize: 24);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final Orientation orientation = MediaQuery.of(context).orientation;

    return buildPortratActivityScreen(screenSize, orientation);
  }

  Scaffold buildPortratActivityScreen(
      Size screenSize, Orientation orientation) {
    Widget childContainer;

    if (orientation == Orientation.portrait) {
      childContainer = Column(
        children: buildScreen(screenSize, orientation),
      );
    } else if (orientation == Orientation.landscape) {
      childContainer = Row(
        children: buildScreen(screenSize, orientation),
      );
    }

    return Scaffold(
        appBar: GirafAppBar(
          title: 'Aktivitet',
        ),
        body: childContainer);
  }

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

  List<Widget> buildTimer(Size screenSize, Orientation orientation) {
    if (orientation == Orientation.portrait) {
    } else if (orientation == Orientation.landscape) {}

    return <Widget>[
      //topSpace,
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
                        color: Color.fromRGBO(35, 35, 35, 1.0), width: 0.25)),
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
                "Start",
                style: TextStyle(fontSize: 16, color: Colors.black),
              )),
        ),
      ),
    ];
  }

  List<Widget> buildActivity(Size screenSize, Orientation orientation) {
    if (orientation == Orientation.portrait) {
    } else if (orientation == Orientation.landscape) {}

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
                        color: Color.fromRGBO(35, 35, 35, 1.0), width: 0.25)),
                child: buildLoadPictogramImage())),
      ),
      buildButtonBar(),
    ];
  }

  ButtonBar buildButtonBar() {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        OutlineButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            onPressed: () => _activityBloc.completeActivity(),
            child: const Icon(Icons.check, color: Colors.green)),
        OutlineButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            onPressed: () => _activityBloc.cancelActivity(),
            child: const Icon(
              Icons.cancel,
              color: Colors.red,
            ))
      ],
    );
  }

  /// Creates a pictogram image from the streambuilder
  Widget buildLoadPictogramImage() {
    return StreamBuilder<Image>(
        stream: _pictoImageBloc.image,
        builder: (BuildContext context, AsyncSnapshot<Image> snapshot) {
          return Container(child: snapshot.data);
        });
  }
}
