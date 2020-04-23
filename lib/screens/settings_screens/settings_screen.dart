import 'package:api_client/models/username_model.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/settings_screens/number_of_days_selection_screen.dart';
import 'package:weekplanner/screens/settings_screens/completed_activity_icon_selection_screen.dart';
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
    _settingsBloc.loadSettings(_user);
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
        _buildThemeSection(context),
        _buildOrientationSection(),
        _buildWeekPlanSection(context),
        _buildUserSettings()
      ],
    );
  }

  Widget _buildThemeSection(BuildContext context) {
    return SettingsSection('Tema', <SettingsSectionItem>[
      SettingsArrowButton('Farver på ugeplan', () {}),
      SettingsArrowButton('Tegn for udførelse',
              () => Routes.push(context, CompletedActivityIconScreen(_user))),
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

  Widget _buildUserSettings() {
    return SettingsSection('Bruger indstillinger', <SettingsSectionItem>[
      SettingsArrowButton(_user.name + ' indstillinger', () {}),
    ]);
  }
}
