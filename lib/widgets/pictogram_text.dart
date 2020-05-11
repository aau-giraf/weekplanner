import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/activity_state_enum.dart';
import 'package:api_client/models/enums/complete_mark_enum.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/enums/weekplan_mode.dart';

/// This is a widget used to create text under the pictograms
class PictogramText extends StatelessWidget {
  /// Constructor
  PictogramText(this._activity, this._user, {this.minFontSize = 100}) {
    _settingsBloc.loadSettings(_user);
  }

  final ActivityModel _activity;

  final DisplayNameModel _user;

  /// The settings bloc which we get the settings from, you need to make sure
  /// you have loaded settings into it before hand otherwise text is never build
  final SettingsBloc _settingsBloc = di.getDependency<SettingsBloc>();

  /// The authentication bloc that we get the current mode from (guardian/citizen)
  final AuthBloc _authBloc = di.getDependency<AuthBloc>();

  /// Determines the minimum font size that text can scale down to
  final double minFontSize;

  @override
  Widget build(BuildContext context) {
    final PictogramModel _pictogram = _activity.pictogram;
    return StreamBuilder<WeekplanMode>(
        stream: _authBloc.mode,
        builder: (BuildContext context,
            AsyncSnapshot<WeekplanMode> weekModeSnapshot) {
          return StreamBuilder<SettingsModel>(
              stream: _settingsBloc.settings,
              builder: (BuildContext context,
                  AsyncSnapshot<SettingsModel> settingsSnapshot) {
                if (settingsSnapshot.hasData && weekModeSnapshot.hasData) {
                  final bool hasPictogramText =
                      settingsSnapshot.data.pictogramText;
                  if (_isGuardianMode(weekModeSnapshot) ||
                      (hasPictogramText &&
                          _activityVisible(settingsSnapshot))) {
                    final String pictogramText = _pictogram.title.toUpperCase();
                    return _buildPictogramText(context, pictogramText);
                  }
                }
                return Container(width: 0, height: 0);
              });
        });
  }

  bool _isGuardianMode(AsyncSnapshot<WeekplanMode> weekModeSnapshot) {
    if (weekModeSnapshot.data == WeekplanMode.guardian) {
      return true;
    }
    return false;
  }

  SizedBox _buildPictogramText(BuildContext context, String pictogramText) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width / 4,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05),
          child: AutoSizeText(
            pictogramText,
            minFontSize: minFontSize,
            maxLines: 2,
            textAlign: TextAlign.center,
            // creates a ... postfix if text overflows
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 150),
          ),
        ));
  }

  bool _activityVisible(AsyncSnapshot<SettingsModel> settingsSnapshot) {
    return !(settingsSnapshot.data.completeMark == CompleteMark.Removed &&
        _activity.state == ActivityState.Completed);
    return StreamBuilder<WeekplanMode>(
        stream: _authBloc.mode,
        builder: (BuildContext context,
            AsyncSnapshot<WeekplanMode> weekModeSnapshot) {
          return StreamBuilder<SettingsModel>(
              stream: _settingsBloc.settings,
              builder: (BuildContext context,
                  AsyncSnapshot<SettingsModel> settingsSnapshot) {
                if (settingsSnapshot.hasData) {
                  final bool pictogramTextIsEnabled =
                      settingsSnapshot.data.pictogramText;
                  if (_isGuardianMode(weekModeSnapshot) ||
                      pictogramTextIsEnabled) {
                    final String pictogramText = _pictogram.title.toUpperCase();
                    return _buildPictogramText(context, pictogramText);
                  }
                }
                return Container(width: 0, height: 0);
              });
        });
  }

  bool _isGuardianMode(AsyncSnapshot<WeekplanMode> weekModeSnapshot) {
     return weekModeSnapshot.data == WeekplanMode.guardian;
  }

  SizedBox _buildPictogramText(BuildContext context, String pictogramText) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width / 4,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05),
          child: AutoSizeText(
            pictogramText,
            minFontSize: minFontSize,
            maxLines: 2,
            textAlign: TextAlign.center,
            // creates a ... postfix if text overflows
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 150),
          ),
        ));
  }
}
