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
  NumberOfDaysScreen(UsernameModel user) {
    _user = user; // The selected citizen
    _settingsBloc.loadSettings(_user);
  }

  UsernameModel _user;
  final SettingsBloc _settingsBloc = di.getDependency<SettingsBloc>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SettingsModel>(
        stream: _settingsBloc.settings,
        builder: (BuildContext context,
            AsyncSnapshot<SettingsModel> settingsSnapshot) {
          if (settingsSnapshot.hasData) {
            print('Data');

            SettingsModel _settingsModel = settingsSnapshot.data;
            int _daysToDisplay = _settingsModel.nrOfDaysToDisplay;

            print('Test!!!');

            return Scaffold(
                appBar: GirafAppBar(
                  title: 'Antal dage',
                ),
                body: ListView(
                  children: <Widget>[
                    _button(() {
                      _settingsModel.nrOfDaysToDisplay = 1;
                      _settingsBloc.updateSettings(_user.id, _settingsModel);
                    }, 'Vis kun nuværende dag'),
                    _button(() {
                      _settingsModel.nrOfDaysToDisplay = 5;
                      _settingsBloc.updateSettings(_user.id, _settingsModel);
                    }, 'Vis mandag til fredag'),
                    _button(() {
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

  // TODO: ADD checkmark √ functionality to button
  OutlineButton _button(VoidCallback onPressed, String text) {
    return OutlineButton(
      padding: const EdgeInsets.all(15),
      onPressed: () => onPressed(),
      child: Stack(
        children: <Widget>[
          Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.arrow_forward)),
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
