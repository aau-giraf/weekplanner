import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/settings_screens/number_of_days_selection_screen.dart';
import 'package:weekplanner/screens/settings_screens/color_theme_selection_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section_arrow_button.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section_checkboxButton.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section_item.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_theme_display_box.dart';

import '../../di.dart';
import 'completed_activity_icon_selection_screen.dart';

/// Shows all the users settings, and lets them change them
class SettingsScreen extends StatelessWidget {

  /// Constructor
  SettingsScreen(DisplayNameModel user) : _user = user{
    _settingsBloc.loadSettings(_user);
  }

  final DisplayNameModel _user;

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
    return StreamBuilder<SettingsModel>(
        stream: _settingsBloc.settings,
        builder: (BuildContext context,
            AsyncSnapshot<SettingsModel> settingsSnapshot) {
          if(settingsSnapshot.hasData) {
            final SettingsModel settingsModel = settingsSnapshot.data;
            return SettingsSection('Tema', <SettingsSectionItem>[
              SettingsArrowButton('Farver på ugeplan',
                      () =>
                      Routes.push(
                          context, ColorThemeSelectorScreen(user: _user)
                      ).then((Object object) =>
                          _settingsBloc.loadSettings(_user)),
                  titleTrailing: ThemeBox.fromHexValues(
                      settingsModel.weekDayColors[0].hexColor,
                      settingsModel.weekDayColors[1].hexColor
                  )
              ),
              SettingsArrowButton('Tegn for udførelse',
                      () => Routes.push(context,
                          CompletedActivityIconScreen(_user)))
            ]);
          }else{
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
    );
  }

  Widget _buildOrientationSection() {
    return SettingsSection('Orientering', <SettingsSectionItem>[
      SettingsCheckMarkButton(5, 5, 'Landskab', () {}),
    ]);
  }

  Widget _buildWeekPlanSection(BuildContext context) {
    return SettingsSection('Ugeplan', <SettingsSectionItem>[
      SettingsArrowButton(
          'Antal dage', () => Routes.push(context, NumberOfDaysScreen(_user))),
      // TODO(klogeat): bind to correct settings value when API is merged
      SettingsCheckMarkButton.fromBoolean(
          false, 'Piktogram tekst er synlig', () {}),
    ]);
  }

  Widget _buildUserSettings() {
    return SettingsSection('Bruger indstillinger', <SettingsSectionItem>[
      SettingsArrowButton(_user.displayName + ' indstillinger', () {}),
    ]);
  }
}