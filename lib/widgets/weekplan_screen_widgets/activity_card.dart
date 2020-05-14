import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/activity_state_enum.dart';
import 'package:api_client/models/enums/complete_mark_enum.dart';
import 'package:api_client/models/enums/default_timer_enum.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:api_client/models/weekday_model.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/blocs/timer_bloc.dart';
import 'package:weekplanner/models/enums/weekplan_mode.dart';
import 'package:weekplanner/style/standard_week_colors.dart';
import 'package:weekplanner/widgets/pictogram_text.dart';
import '../../di.dart';
import '../../style/custom_color.dart' as theme;

/// Widget used for activities in the weekplan screen.
class ActivityCard extends StatelessWidget {
  /// Constructor
  ActivityCard(this._activity, this._weekday, this._user) {
    _settingsBloc.loadSettings(_user);
  }

  final ActivityModel _activity;
  final WeekdayModel _weekday;

  final DisplayNameModel _user;
  final AuthBloc _authBloc = di.getDependency<AuthBloc>();
  final SettingsBloc _settingsBloc = di.getDependency<SettingsBloc>();

  @override
  Widget build(BuildContext context) {
    final ActivityState _activityState = _activity.state;
    if (!_activity.isChoiceBoard) {
      return Container(
          color: theme.GirafColors.white,
          margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
          child: FittedBox(
            child: Column(
              children: <Widget>[
                Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      child: FittedBox(
                        child: _getPictogram(_activity.pictograms.first),
                      ),
                    ),
                    _buildActivityStateIcon(context, _activityState, _weekday),
                    _buildTimerIcon(context, _activity),
                  ],
                ),
               PictogramText(_activity.pictograms.first, _user),
              ],
            ),
          ));
    } else {
      return buildChoiceboardAcivityCard(context);
    }
  }

  ///This function builds the activity card
  Widget buildChoiceboardAcivityCard(BuildContext context) {
    final ActivityState _activityState = _activity.state;
    List<Widget> pictograms = [];
    for(int i = 0; i < _activity.pictograms.length; i++){
      pictograms.add(_getPictogram(_activity.pictograms[i]));
    }
    return Container(
        decoration: BoxDecoration(
            color: theme.GirafColors.white,
            border: Border.all(
                color: Colors.black,
                width: MediaQuery.of(context).size.width * 0.01)),
        margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
        child: FittedBox(
          child: Column(
            children: <Widget>[
              Stack(
                alignment: AlignmentDirectional.topEnd,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    child: FittedBox(
                        child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: <Widget>[
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width,
                            child: returnGridView(pictograms)),
                      ],
                    )),
                  ),
                  _buildActivityStateIcon(context, _activityState, _weekday),
                  _buildTimerIcon(context, _activity),
                ],
              ),
              PictogramText(_activity.pictograms.first, _user),
            ],
          ),
        ));
  }

  ///Returns the correct gridview
  Center returnGridView(List<Widget> list) {
    if (list.length == 1) {
      return Center(
        child: GridView.count(
          crossAxisCount: 1,
          children: list,
        ),
      );
    } else if (list.length == 2) {
      return Center(
        child: GridView.count(
          childAspectRatio: 0.5,
          crossAxisCount: 2,
          children: list,
        ),
      );
    } else {
      return Center(
        child: GridView.count(
          crossAxisCount: 2,
          children: list,
        ),
      );
    }
  }

  Widget _getPictogram(PictogramModel _pictogram) {
    final PictogramImageBloc bloc = di.getDependency<PictogramImageBloc>();
    bloc.loadPictogramById(_pictogram.id);
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

  Widget _buildActivityStateIcon(
      BuildContext context, ActivityState state, WeekdayModel weekday) {
    switch (state) {
      case ActivityState.Completed:
        return StreamBuilder<WeekplanMode>(
            stream: _authBloc.mode,
            builder: (BuildContext context,
                AsyncSnapshot<WeekplanMode> weekModeSnapshot) {
              if (weekModeSnapshot.hasData) {
                final WeekplanMode role = weekModeSnapshot.data;

                if (role == WeekplanMode.guardian) {
                  return Icon(
                    Icons.check,
                    key: const Key('IconComplete'),
                    color: theme.GirafColors.green,
                    size: MediaQuery.of(context).size.width,
                  );
                } else if (role == WeekplanMode.citizen) {
                  return StreamBuilder<SettingsModel>(
                      stream: _settingsBloc.settings,
                      builder: (BuildContext context,
                          AsyncSnapshot<SettingsModel> snapshot) {
                        if (!snapshot.hasData ||
                            snapshot.data.completeMark == null) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.data.completeMark ==
                            CompleteMark.Checkmark) {
                          return Icon(
                            Icons.check,
                            key: const Key('IconComplete'),
                            color: theme.GirafColors.green,
                            size: MediaQuery.of(context).size.width,
                          );
                        } else if (snapshot.data.completeMark ==
                            CompleteMark.MovedRight) {
                          return _completedActivityColor(
                              theme.GirafColors.transparentGrey, context);
                        } else if (snapshot.data.completeMark ==
                            CompleteMark.Removed) {
                          return StreamBuilder<SettingsModel>(
                            stream: _settingsBloc.settings,
                            builder: (BuildContext buildContext,
                                AsyncSnapshot<SettingsModel> settingsSnapshot) {
                              Color c;

                              if (settingsSnapshot.data == null) {
                                c = Color(int.parse(
                                    WeekplanColorTheme.blueWhiteColorSetting()[
                                            weekday.day.index]
                                        .hexColor
                                        .replaceFirst('#', '0xff')));
                              } else {
                                c = Color(int.parse(settingsSnapshot.data
                                    .weekDayColors[weekday.day.index].hexColor
                                    .replaceFirst('#', '0xff')));
                              }

                              return _completedActivityColor(c, context);
                            },
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      });
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            });

      case ActivityState.Canceled:
        return Icon(
          Icons.clear,
          key: const Key('IconCanceled'),
          color: theme.GirafColors.red,
          size: MediaQuery.of(context).size.width,
        );
      default:
        return Container();
    }
  }

  Container _completedActivityColor(Color dayColor, BuildContext context) {
    return Container(
        color: dayColor,
        height: MediaQuery.of(context).size.width,
        width: MediaQuery.of(context).size.width);
  }

  Widget _buildTimerIcon(BuildContext context, ActivityModel activity) {
    final TimerBloc timerBloc = di.getDependency<TimerBloc>();
    timerBloc.load(activity, user: _user);
    return StreamBuilder<bool>(
        stream: timerBloc.timerIsInstantiated,
        builder:
            (BuildContext streamContext, AsyncSnapshot<bool> timerSnapshot) {
          if (timerSnapshot.hasData && timerSnapshot.data) {
            // Activities that are not overlayed.
            if (activity.state != ActivityState.Completed) {
              return _buildTimerAssetIcon();
            }
            // Activities that are overlayed.
            return StreamBuilder<WeekplanMode>(
                stream: _authBloc.mode,
                builder: (BuildContext roleContext,
                    AsyncSnapshot<WeekplanMode> role) {
                  if (role.data == WeekplanMode.guardian) {
                    return _buildTimerAssetIcon();
                  } else {
                    return StreamBuilder<SettingsModel>(
                        stream: _settingsBloc.settings,
                        builder: (BuildContext settingsContext,
                            AsyncSnapshot<SettingsModel> settings) {
                          if (!settings.hasData ||
                              settings.data.completeMark !=
                                  CompleteMark.Removed) {
                            return _buildTimerAssetIcon();
                          }

                          return Container();
                        });
                  }
                });
          }
          return Container();
        });
  }

  /// Build timer icon.
  Widget _buildTimerAssetIcon() {
    return StreamBuilder<SettingsModel>(
        stream: _settingsBloc.settings,
        builder: (BuildContext context,
            AsyncSnapshot<SettingsModel> settingsSnapshot) {
          String _iconPath;

          if (settingsSnapshot.hasData) {
            if (settingsSnapshot.data.defaultTimer == DefaultTimer.PieChart) {
              _iconPath = 'assets/timer/piechart_icon.png';
            } else if (settingsSnapshot.data.defaultTimer ==
                DefaultTimer.Hourglass) {
              _iconPath = 'assets/timer/hourglass_icon.png';
            } else if (settingsSnapshot.data.defaultTimer ==
                DefaultTimer.Numeric) {
              _iconPath = 'assets/timer/countdowntimer_icon.png';
            }
          } else {
            return const CircularProgressIndicator();
          }
          return Image(
            image: AssetImage(_iconPath),
            height: 250,
            width: 250,
          );
        });
  }
}
