import 'package:api_client/models/settings_model.dart';
import 'package:api_client/models/username_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section_checkboxButton.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section_item.dart';

/// This class is used to select the color theme for a citizen's weekplans
class ColorThemeSelectorScreen extends StatelessWidget {
  /// Constructor
  ColorThemeSelectorScreen({@required UsernameModel user}) : _user = user {
    _settingsBloc.loadSettings(_user);
  }

  final SettingsBloc _settingsBloc = di.getDependency<SettingsBloc>();
  final UsernameModel _user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GirafAppBar(
          title: _user.name + ': Farver på ugeplan',
        ),
        body: StreamBuilder<SettingsModel>(
            stream: _settingsBloc.settings,
            builder: (BuildContext context,
                AsyncSnapshot<SettingsModel> settingsSnapshot) {
              if (settingsSnapshot.hasData) {
                final SettingsModel _settingsModel = settingsSnapshot.data;
                return ListView(
                  children: <Widget>[
                    SettingsSection(
                        'Farvetema', _createSettingList(_settingsModel)),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }

  //TODO: få lavet lavet vores egen udgave af checkMarkButton som ikke bare
  // sammenligner ints, og derefter få brugt den her og gjort så den ændrer
  // værdien af _settingsModel.weekDayColors i stedet for nrOfdaysToDisplay.
  List<SettingsSectionItem> _createSettingList(SettingsModel _settingsModel) {
    final List<SettingsSectionItem> settingsList = <SettingsSectionItem>[];
    settingsList.add(SettingsCheckMarkButton(
        1, _settingsModel.nrOfDaysToDisplay, 'Standard', () {
      _settingsModel.nrOfDaysToDisplay = 1;
      _settingsBloc.updateSettings(_user.id, _settingsModel);
    }));
    settingsList.add(SettingsCheckMarkButton(
        5, _settingsModel.nrOfDaysToDisplay, 'Blå/Hvid', () {
      _settingsModel.nrOfDaysToDisplay = 5;
      _settingsBloc.updateSettings(_user.id, _settingsModel);
    }));
    settingsList.add(SettingsCheckMarkButton(
        7, _settingsModel.nrOfDaysToDisplay, 'Sort/Hvid', () {
      _settingsModel.nrOfDaysToDisplay = 7;
      _settingsBloc.updateSettings(_user.id, _settingsModel);
    }));

    return settingsList;
  }
}
