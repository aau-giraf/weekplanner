import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/activity_state_enum.dart';
import 'package:api_client/models/enums/complete_mark_enum.dart';
import 'package:api_client/models/enums/default_timer_enum.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/blocs/timer_bloc.dart';
import 'package:weekplanner/models/enums/weekplan_mode.dart';
import 'package:weekplanner/widgets/pictogram_text.dart';
import '../../di.dart';
import '../../style/custom_color.dart' as theme;

/// Widget used for activities in the weekplan screen.
class ActivityCard extends StatelessWidget {

  /// Constructor
  ActivityCard(this._activity, this._user){
    _settingsBloc.loadSettings(_user);
  }

  final ActivityModel _activity;

  final DisplayNameModel _user;
  final AuthBloc _authBloc = di.getDependency<AuthBloc>();
  final SettingsBloc _settingsBloc = di.getDependency<SettingsBloc>();


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<WeekplanMode>(
        stream: _authBloc.mode,
        builder: (BuildContext context,
            AsyncSnapshot<WeekplanMode> weekModeSnapshot) {
          if (weekModeSnapshot.hasData) {
            final WeekplanMode weekMode = weekModeSnapshot.data;
            return StreamBuilder<SettingsModel>(
                stream: _settingsBloc.settings,
                builder: (BuildContext context,
                    AsyncSnapshot<SettingsModel> settingsSnapshot) {
                    if(settingsSnapshot.hasData) {
                        final SettingsModel settings = settingsSnapshot.data;
                        return _buildActivityCard(context, weekMode, settings);
                    } else {
                        return const Center(child: CircularProgressIndicator());
                    }
            });
          } else {
               return const Center(child: CircularProgressIndicator());
          }
    });
  }

  Widget _buildActivityCard(BuildContext context, WeekplanMode weekMode,
      SettingsModel settings){
    final ActivityState _activityState = _activity.state;

    return Opacity(
      opacity: _shouldActivityBeVisible(weekMode, settings) ? 1.0 : 0,
      child: Container(
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
                        child: _getPictogram(_activity),
                      ),
                    ),
                    _buildActivityStateIcon(context, _activityState, weekMode,
                        settings),
                    _buildTimerIcon(context, _activity),
                  ],
                ),
                PictogramText(_activity, _user),
              ],
            ),
          )),
    );
  }

  bool _shouldActivityBeVisible(WeekplanMode weekMode, SettingsModel settings) {
    if(settings != null || weekMode != null) {
      if (weekMode == WeekplanMode.citizen &&
          settings.completeMark == CompleteMark.Removed &&
          _activity.state == ActivityState.Completed) {
        return false;
      }
    }
    return true;
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

  Widget _buildActivityStateIcon(
      BuildContext context, ActivityState state, WeekplanMode role,
      SettingsModel settings) {
    switch (state) {
      case ActivityState.Completed:
        if (role == WeekplanMode.guardian) {
          return Icon(
            Icons.check,
            key: const Key('IconComplete'),
            color: theme.GirafColors.green,
            size: MediaQuery.of(context).size.width,
          );
        }
        else if (role == WeekplanMode.citizen) {
          if (settings.completeMark == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else if (settings.completeMark == CompleteMark.Checkmark) {
            return Icon(
              Icons.check,
              key: const Key('IconComplete'),
              color: theme.GirafColors.green,
              size: MediaQuery
                  .of(context)
                  .size
                  .width,
            );
          }
          else if (settings.completeMark == CompleteMark.MovedRight) {
            return _completedActivityColor(
                theme.GirafColors.transparentGrey, context);
          }
          else if (settings.completeMark == CompleteMark.Removed) {
            //This case should be handled by _shouldActivityBeVisible
            return Container(width: 0, height: 0,);
          }
        }
        return const Center(child: CircularProgressIndicator());
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