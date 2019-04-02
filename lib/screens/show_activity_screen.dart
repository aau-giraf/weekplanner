import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/activity_bloc.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/activity_model.dart';
import 'package:weekplanner/models/giraf_user_model.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';

/// Screen to show activity, mark done/canceled and see timer.
class ShowActivityScreen extends StatelessWidget {
  ///
  ShowActivityScreen(this._weekModel, this._activity, this._girafUserModel,
      {Key key})
      : super(key: key) {
    _pictoImageBloc.load(_activity.pictogram);
    // _activityBloc.load(_weekModel, _activity, _girafUserModel);
  }

  final WeekModel _weekModel;
  final ActivityModel _activity;
  final GirafUserModel _girafUserModel;

  final PictogramImageBloc _pictoImageBloc =
      di.getDependency<PictogramImageBloc>();

  // final ActivityBloc _activityBloc = di.getDependency<ActivityBloc>();

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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: buildScreen(screenSize, orientation),
      );
    } else if (orientation == Orientation.landscape) {
      childContainer = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
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
      Column(
        children: buildActivity(screenSize, orientation),
      ),
      Column(
        children: buildTimer(screenSize, orientation),
      )
    ];
  }

  List<Widget> buildTimer(Size screenSize, Orientation orientation) {
    double height;
    double width;
    Widget topSpace;
    if (orientation == Orientation.portrait) {
      height = screenSize.height * 0.25;
      width = screenSize.height * 0.25;
      topSpace = Container();
    } else if (orientation == Orientation.landscape) {
      height = screenSize.height * 0.45;
      width = screenSize.height * 0.45;
      topSpace = Container(
        height: screenSize.height * 0.05,
      );
    }

    return <Widget>[
      topSpace,
      Center(
        child: AutoSizeText('Timer',
            minFontSize: 10.0, maxFontSize: 24, textAlign: TextAlign.center),
      ),
      Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: Colors.black)),
          child: const Icon(Icons.ac_unit)),
      SizedBox(
        child: OutlineButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            onPressed: null,
            color: Colors.green,
            child: Text(
              "Start",
              style: TextStyle(fontSize: 16, color: Colors.black),
            )),
      ),
    ];
  }

  List<Widget> buildActivity(Size screenSize, Orientation orientation) {
    double height;
    double width;

    if (orientation == Orientation.portrait) {
      height = screenSize.height * 0.30;
      width = screenSize.height * 0.30;
    } else if (orientation == Orientation.landscape) {
      height = screenSize.height * 0.50;
      width = screenSize.height * 0.50;
    }

    return <Widget>[
      Container(
        height: screenSize.height * 0.05,
      ),
      Center(
          child: AutoSizeText('Aktivitet',
              minFontSize: 10.0, maxFontSize: 24, textAlign: TextAlign.center)),
      SizedBox(
          height: height,
          width: width,
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  border: Border.all(color: Colors.black)),
              child: const Icon(Icons.ac_unit))),
      buildButtonBar(),
    ];
  }

  ButtonBar buildButtonBar() {
    return ButtonBar(
      mainAxisSize: MainAxisSize.max,
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        OutlineButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            // onPressed: () => _activityBloc.completeActivity(),

            child: const Icon(Icons.check, color: Colors.green)),
        OutlineButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            // onPressed: () => _activityBloc.cancelActivity(),
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
