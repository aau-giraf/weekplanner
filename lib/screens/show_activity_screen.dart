import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/activity_bloc.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/enums/activity_state_enum.dart';
import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';
import 'package:weekplanner/models/enums/weekplan_mode.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';

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

    return buildScreenFromOrientation(orientation);
  }

  /// Build the activity screens in a row or column
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
            appBarIcons: const <AppBarIcon, VoidCallback>{}),
        body: childContainer);
  }

  /// Builds the activity.
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
                        alignment: AlignmentDirectional.center,
                        children: <Widget>[
                          SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width,
                              child: buildLoadPictogramImage()),
                          _buildActivityStateIcon(context, snapshot.data.state)
                        ],
                      );
                    }))),
      ),
      buildButton()
    ];
  }

  /// Builds the buttons below the activity widget.
  Widget buildButton() {
    return StreamBuilder<WeekplanMode>(
      stream: _authBloc.mode,
      builder: (BuildContext context,
          AsyncSnapshot<WeekplanMode> weekplanModeSnapshot) {
        return StreamBuilder<ActivityModel>(
            stream: _activityBloc.activityModelStream,
            builder:
                (BuildContext context, AsyncSnapshot<ActivityModel> snapshot) {
              if (snapshot.data == null) {
                return const CircularProgressIndicator();
              }
              return _buildChangeActivityStateButton(
                  snapshot.data.state, weekplanModeSnapshot.data);
            });
      },
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

  GirafButton _buildChangeActivityStateButton(
      ActivityState state, WeekplanMode mode) {
    if (mode == WeekplanMode.guardian) {
      return GirafButton(
          key: const Key('CancelStateToggleButton'),
          onPressed: () {
            _activityBloc.cancelActivity();
          },
          width: 100,
          icon: state != ActivityState.Canceled
              ? const ImageIcon(AssetImage('assets/icons/cancel.png'),
                  color: Colors.red)
              : const ImageIcon(AssetImage('assets/icons/undo.png'),
                  color: Colors.blue));
    } else {
      return GirafButton(
          key: const Key('CompleteStateToggleButton'),
          onPressed: () {
            _activityBloc.completeActivity();
          },
          isEnabled: state != ActivityState.Canceled,
          width: 100,
          icon: state != ActivityState.Completed
              ? const ImageIcon(AssetImage('assets/icons/accept.png'),
                  color: Colors.green)
              : const ImageIcon(AssetImage('assets/icons/undo.png'),
                  color: Colors.blue));
    }
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
