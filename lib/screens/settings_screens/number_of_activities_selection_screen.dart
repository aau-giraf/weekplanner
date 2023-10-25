import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section.dart';
import 'package:weekplanner/widgets/settings_widgets/'
    'settings_section_checkboxButton.dart';
import 'package:weekplanner/widgets/settings_widgets/'
    'settings_section_item.dart';

import '../../di.dart';
import '../../routes.dart';

/// Screen where the user can select how many activities to show for a citizen
// ignore: must_be_immutable
class NumberOfActivitiesScreen extends StatelessWidget {
  /// Constructor
  NumberOfActivitiesScreen(DisplayNameModel user, SettingsModel settingsModel)
      : _user = user {
    _settingsModel = settingsModel;
    _settingsBloc.loadSettings(_user);
  }
  SettingsModel _settingsModel;
  final DisplayNameModel _user;

  final SettingsBloc _settingsBloc = di.get<SettingsBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GirafAppBar(
          title: _user.displayName + ': indstillinger',
        ),
        body: StreamBuilder<SettingsModel>(
            stream: _settingsBloc.settings,
            builder: (BuildContext context,
                AsyncSnapshot<SettingsModel> settingsSnapshot) {
              if (settingsSnapshot.hasData) {
                final int _nrOfActivitiesToDisplay =
                    _settingsModel.nrOfActivitiesToDisplay;
                return ListView(
                  children: <Widget>[
                    SettingsSection(
                        'Hvor mange aktiviteter skal vises'
                        'på vis kun aktiviter',
                        <SettingsSectionItem>[
                          SettingsCheckMarkButton(
                              1, _nrOfActivitiesToDisplay, '1 aktivitet', () {
                            Routes().pop(context, 1);
                          }),
                          SettingsCheckMarkButton(
                              2, _nrOfActivitiesToDisplay, '2 aktiviteter', () {
                            Routes().pop(context, 2);
                          }),
                          SettingsCheckMarkButton(
                              3, _nrOfActivitiesToDisplay, '3 aktiviteter', () {
                            Routes().pop(context, 3);
                          }),
                          SettingsCheckMarkButton(
                              4, _nrOfActivitiesToDisplay, '4 aktiviteter', () {
                            Routes().pop(context, 4);
                          }),
                          SettingsCheckMarkButton(
                              5, _nrOfActivitiesToDisplay, '5 aktiviteter', () {
                            Routes().pop(context, 5);
                          }),
                          SettingsCheckMarkButton(
                              6, _nrOfActivitiesToDisplay, '6 aktiviteter', () {
                            Routes().pop(context, 6);
                          }),
                          SettingsCheckMarkButton(
                              7, _nrOfActivitiesToDisplay, '7 aktiviteter', () {
                            Routes().pop(context, 7);
                          }),
                          SettingsCheckMarkButton(
                              8, _nrOfActivitiesToDisplay, '8 aktiviteter', () {
                            Routes().pop(context, 8);
                          }),
                          SettingsCheckMarkButton(
                              9, _nrOfActivitiesToDisplay, '9 aktiviteter', () {
                            Routes().pop(context, 9);
                          }),
                          SettingsCheckMarkButton(
                              10, _nrOfActivitiesToDisplay, '10 aktiviteter',
                              () {
                            Routes().pop(context, 10);
                          }),
                        ]),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
