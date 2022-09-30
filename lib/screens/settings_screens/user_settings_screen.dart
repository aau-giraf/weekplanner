import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/complete_mark_enum.dart';
import 'package:api_client/models/enums/default_timer_enum.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/settings_screens/'
    'number_of_days_selection_screen.dart';
import 'package:weekplanner/screens/settings_screens/'
    'color_theme_selection_screen.dart';
import 'package:weekplanner/screens/settings_screens/'
    'privacy_information_screen.dart';
import 'package:weekplanner/screens/settings_screens/'
    'time_representation_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section.dart';
import 'package:weekplanner/widgets/settings_widgets/'
    'settings_section_arrow_button.dart';
import 'package:weekplanner/widgets/settings_widgets/'
    'settings_section_checkboxButton.dart';
import 'package:weekplanner/widgets/settings_widgets/'
    'settings_section_item.dart';
import 'package:weekplanner/widgets/settings_widgets/'
    'settings_theme_display_box.dart';
import '../../di.dart';
import '../../widgets/settings_widgets/settings_section_arrow_button.dart';
import 'completed_activity_icon_selection_screen.dart';

class UserSettingsScreen extends StatelessWidget {
  /// Constructor
  UserSettingsScreen(DisplayNameModel user) : _user = user {
    _settingsBloc.loadSettings(_user);
  }

  final DisplayNameModel _user;
  final SettingsBloc _settingsBloc = di.getDependency<SettingsBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GirafAppBar(title: _user.displayName + ' indstillinger',),
        body: _buildAllSettings(context));
  }

  Widget _buildAllSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        _buildChangePasswordAndUsername(context)
      ],
    );
  }

  Widget _buildChangePasswordAndUsername(BuildContext context) {
    return SettingsSection(_user.displayName + ' - skift personlig information', <SettingsSectionItem>[
      SettingsArrowButton('Skift brugernavn', () {}),
      SettingsArrowButton('Skift kodeord', () {}),
    ]);
  }

}