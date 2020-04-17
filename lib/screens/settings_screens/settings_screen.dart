import 'package:api_client/models/settings_model.dart';
import 'package:api_client/models/username_model.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/settings_screens/number_of_days_selection_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section_arrow_button.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section_checkboxButton.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section_item.dart';

import '../../di.dart';

/// Shows all the users settings, and lets them change them
class SettingsScreen extends StatelessWidget {
  /// Constructor
  SettingsScreen(UsernameModel user) : _user = user{
    _settingsBloc.loadSettings(user);
  }

  final UsernameModel _user;
  final SettingsBloc _settingsBloc = di.getDependency<SettingsBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GirafAppBar(title: 'Indstillinger'),
        body: _buildAllSettings(context));
  }

  Widget _buildAllSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        _buildThemeSection(),
        _buildOrientationSection(),
        _buildWeekPlanSection(context),
        _buildTimerSection(context),
        _buildUserSettings()
      ],
    );
  }

  Widget _buildThemeSection() {
    return SettingsSection('Tema', <SettingsSectionItem>[
      SettingsArrowButton('Farver på ugeplan', () {}),
      SettingsArrowButton('Tegn for udførelse', () {})
    ]);
  }

  Widget _buildOrientationSection() {
    return SettingsSection('Orientering', <SettingsSectionItem>[
      SettingsCheckMarkButton(5, 5, 'Landskab', () {}),
    ]);
  }

  Widget _buildWeekPlanSection(BuildContext context) {
    return SettingsSection('Ugeplan', <SettingsSectionItem>[
      SettingsArrowButton(
          'Antal dage', () => Routes.push(context,  NumberOfDaysScreen(_user))),
    ]);
  }

  Widget _buildTimerSection(BuildContext context) {
    return StreamBuilder<SettingsModel>(
      stream: _settingsBloc.settings,
      builder: (BuildContext context, AsyncSnapshot<SettingsModel> settingsSnapshot) {
        return SettingsSection('Tid', <SettingsSectionItem>[
          SettingsCheckMarkButton(1, 0, 'Lås tidsstyring', (){
            //TODO insert that changes the value of settings
           //final SettingsModel _settingsModel = settingsSnapshot.data;
           //_settingsModel.timerControl = _settingsModel.timerControl == 1 ? 0 : 1;
           //_settingsBloc.updateSettings(_user.id, _settingsModel);
          })
        ]);
      }
    );
  }

  Widget _buildUserSettings() {
    return SettingsSection('Bruger indstillinger', <SettingsSectionItem>[
      SettingsArrowButton(_user.name + ' indstillinger', () {}),
    ]);
  }
}
