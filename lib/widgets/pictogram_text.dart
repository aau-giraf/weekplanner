import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/activity_state_enum.dart';
import 'package:api_client/models/enums/complete_mark_enum.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/activity_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';

import 'package:weekplanner/di.dart';

/// This is a widget used to create text under the pictograms
class PictogramText extends StatelessWidget {
  /// Constructor
  PictogramText(this._activity, this._user, {this.minFontSize = 100}) {
    _settingsBloc.loadSettings(_user);
    _activityBloc.load(_activity, _user);
    _pictogram = _activity.pictogram;
  }

  final ActivityModel _activity;

  final DisplayNameModel _user;

  /// The pictogram to build the text for
  PictogramModel _pictogram;

  /// The settings bloc which we get the settings from, you need to make sure
  /// you have loaded settings into it before hand otherwise text is never build
  final SettingsBloc _settingsBloc = di.getDependency<SettingsBloc>();

  final ActivityBloc _activityBloc = di.getDependency<ActivityBloc>();

  /// Determines the minimum font size that text can scale down to
  final double minFontSize;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SettingsModel>(
        stream: _settingsBloc.settings,
        builder: (BuildContext context,
            AsyncSnapshot<SettingsModel> settingsSnapshot) {
          return StreamBuilder<ActivityModel>(
              stream: _activityBloc.activityModelStream,
              builder: (BuildContext context,
                  AsyncSnapshot<ActivityModel> activitySnapshot) {
                if (settingsSnapshot.hasData &&
                    _activityVisible(activitySnapshot, settingsSnapshot)) {
                  final bool hasPictogramText =
                      settingsSnapshot.data.pictogramText;
                  if (hasPictogramText) {
                    final String pictogramText = _pictogram.title.toUpperCase();
                    return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width / 4,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.05),
                          child: AutoSizeText(
                            pictogramText,
                            minFontSize: minFontSize,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            // creates a ... postfix if text is too long
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 150),
                          ),
                        ));
                  }
                }
                return Container(width: 0, height: 0);
              });
        });
  }

  bool _activityVisible(AsyncSnapshot<ActivityModel> activitySnapshot,
      AsyncSnapshot<SettingsModel> settingsSnapshot) {
    return !(settingsSnapshot.data.completeMark == CompleteMark.Removed &&
        activitySnapshot.data.state == ActivityState.Completed);
  }
}
