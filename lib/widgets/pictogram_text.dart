import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/pictogram_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/enums/weekplan_mode.dart';
import 'package:weekplanner/style/font_size.dart';

/// This is a widget used to create text under the pictograms
class PictogramText extends StatelessWidget {
  /// Constructor
  PictogramText(this._activity, this._user, {this.minFontSize = 100}) {
    _settingsBloc.loadSettings(_user);
    //_pictogramBloc.load(_activity.pictograms.first);
  }

  final ActivityModel _activity;
  //final PictogramBloc _pictogramBloc;
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
    final PictogramModel _pictogram = _activity.pictograms.first;
    return StreamBuilder<WeekplanMode>(
        stream: _authBloc.mode,
        builder: (BuildContext context,
            AsyncSnapshot<WeekplanMode> weekModeSnapshot) {
          return StreamBuilder<SettingsModel>(
              stream: _settingsBloc.settings,
              builder: (BuildContext context,
                  AsyncSnapshot<SettingsModel> settingsSnapshot) {
                if (settingsSnapshot.hasData && weekModeSnapshot.hasData) {
                  final WeekplanMode weekMode = weekModeSnapshot.data;
                  final SettingsModel settings = settingsSnapshot.data;
                  final bool pictogramTextIsEnabled = settings.pictogramText;
                  if (_isGuardianMode(weekMode) || pictogramTextIsEnabled) {
                    if (_activity.isChoiceBoard) {
                      return _buildPictogramText(context, 'ChoiceBoard');
                    } else {
                      final String pictogramText = setPictogramText();
                      //final String pictogramText = _pictogram.title;
                      return _buildPictogramText(context, pictogramText);
                    }
                  }
                }
                return Container(width: 0, height: 0);
              });
        });
  }

  bool _isGuardianMode(WeekplanMode weekMode) {
    return weekMode == WeekplanMode.guardian;
  }

  SizedBox _buildPictogramText(BuildContext context, String pictogramText) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width / 4,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05),
          child: AutoSizeText(
            pictogramText[0].toUpperCase()
                + pictogramText.substring(1).toLowerCase(),
            minFontSize: minFontSize,
            maxLines: 2,
            textAlign: TextAlign.center,
            // creates a ... postfix if text overflows
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold,
                fontSize: GirafFont.pictogram),
          ),
        ));
  }

  /// Sets the pictogram text
  String setPictogramText(){
    final List<Tuple2<String, String>> testTuple = <Tuple2<String, String>>[
      const Tuple2<String, String>('a', 'tr'),
      const Tuple2<String, String>('b', 'GU'),
      const Tuple2<String, String>('c', 'hjul'),
      const Tuple2<String, String>('e', 'BITCH'),
      const Tuple2<String, String>('d', 'iu')
    ];

    if(testTuple.isNotEmpty){
      for(int i = 0; testTuple.length > i; i++){
        if(testTuple[i].item1 == _user.id){
          return testTuple[i].item2;
        }
      }
    }

    return _activity.pictograms.first.title;
  }
}
