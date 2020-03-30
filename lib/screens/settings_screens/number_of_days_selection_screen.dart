import 'package:api_client/models/settings_model.dart';
import 'package:api_client/models/username_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/style/custom_color.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

import '../../di.dart';

/// Screen where the user can select how many days to show for a citizen
class NumberOfDaysScreen extends StatelessWidget {
  /// Constructor
  NumberOfDaysScreen(UsernameModel user) : _user = user {
    _settingsBloc.loadSettings(_user);
  }

  final UsernameModel _user;
  final SettingsBloc _settingsBloc = di.getDependency<SettingsBloc>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SettingsModel>(
        stream: _settingsBloc.settings,
        builder: (BuildContext context,
            AsyncSnapshot<SettingsModel> settingsSnapshot) {
          if (settingsSnapshot.hasData) {
            final SettingsModel _settingsModel = settingsSnapshot.data;
            return Scaffold(
                appBar: GirafAppBar(
                  title: 'Antal dage',
                ),
                body: ListView(
                  children: <Widget>[
                    _button(1, _settingsModel.nrOfDaysToDisplay, () {
                      _settingsModel.nrOfDaysToDisplay = 1;
                      _settingsBloc.updateSettings(_user.id, _settingsModel);
                    }, 'Vis kun nuværende dag'),
                    _button(5, _settingsModel.nrOfDaysToDisplay, () {
                      _settingsModel.nrOfDaysToDisplay = 5;
                      _settingsBloc.updateSettings(_user.id, _settingsModel);
                    }, 'Vis mandag til fredag'),
                    _button(7, _settingsModel.nrOfDaysToDisplay, () {
                      _settingsModel.nrOfDaysToDisplay = 7;
                      _settingsBloc.updateSettings(_user.id, _settingsModel);
                    }, 'Vis mandag til søndag')
                  ],
                ));
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  /// The button will show a check mark if [expected] is the same as [current]
  OutlineButton _button(
      int expected, int current, VoidCallback onPressed, String text) {
    Widget _child;
    if (expected == current) {
      _child = Icon(Icons.check, size: 20);
    } else {
      _child = null;
    }
    return OutlineButton(
      padding: const EdgeInsets.all(15),
      onPressed: () => onPressed(),
      child: Stack(
        children: <Widget>[
          Align(alignment: Alignment.centerRight, child: _child),
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                text,
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.normal),
              ))
        ],
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      highlightedBorderColor: GirafColors.appBarOrange,
    );
  }
}
