import 'package:api_client/models/username_model.dart';
import 'package:flutter/material.dart';
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
        appBar: GirafAppBar(title: 'Indstillinger'), body: _buildAllSettings());
  }

  Widget _buildAllSettings() {
    return ListView(
      children: <Widget>[
        _buildThemeSection(),
        _buildOrientationSection(),
        _buildWeekPlanSection(),
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
      SettingsCheckMarkButton('Landskab', () {}),
    ]);
  }

  Widget _buildWeekPlanSection() {
    return SettingsSection('Ugeplan', <SettingsSectionItem>[
      SettingsArrowButton('Antal dage', () {}),
    ]);
  }

  Widget _buildUserSettings() {
    return SettingsSection('Bruger indstillinger', <SettingsSectionItem>[
      SettingsArrowButton(_user.name + ' indstillinger', () {}),
    ]);
  }
}
