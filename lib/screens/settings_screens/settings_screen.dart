import 'package:api_client/models/username_model.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/settings_screens/number_of_days_selection_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section_arrow_button.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section_checkboxButton.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section_item.dart';

/// Shows all the users settings, and lets them change them
class SettingsScreen extends StatelessWidget {
  /// Constructor
  const SettingsScreen(UsernameModel user) : _user = user;

  final UsernameModel _user;

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
    return SettingsSection('Tid', <SettingsSectionItem>[
      SettingsCheckMarkButton(1, 0, 'Lås tidsstyring', (){})
    ]);
  }

  Widget _buildUserSettings() {
    return SettingsSection('Bruger indstillinger', <SettingsSectionItem>[
      SettingsArrowButton(_user.name + ' indstillinger', () {}),
    ]);
  }
}
