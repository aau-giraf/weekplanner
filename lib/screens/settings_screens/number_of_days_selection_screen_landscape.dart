import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:flutter/cupertino.dart';
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

/// Screen where the user can select how many days to show for a citizen
class NumberOfDaysScreenLandscape extends StatelessWidget {
  /// Constructor
  NumberOfDaysScreenLandscape(DisplayNameModel user) : _user = user {
    _settingsBloc.loadSettings(_user);
  }

  final DisplayNameModel _user;
  final SettingsBloc _settingsBloc = di.getDependency<SettingsBloc>();

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
                final SettingsModel _settingsModel = settingsSnapshot.data;

                return ListView(
                  children: <Widget>[
                    SettingsSection('Antal dage der vises når enheden er på langs', <SettingsSectionItem>[
                      SettingsCheckMarkButton(
                          1, _settingsModel.nrOfDaysToDisplayLandscape, 'Vis i dag',
                              () {
                            _settingsModel.displayDaysRelativeLandscape = true;
                            Routes.pop(context, 1);
                          }),
                      SettingsCheckMarkButton(
                          2, _settingsModel.nrOfDaysToDisplayLandscape, 'Vis to dage',
                              () {
                                _settingsModel.displayDaysRelativeLandscape = true;
                            Routes.pop(context, 2);
                          }),

                      SettingsCheckMarkButton(
                          5,
                          _settingsModel.nrOfDaysToDisplayLandscape,
                          'Vis mandag til fredag', () {
                        _settingsModel.displayDaysRelativeLandscape = false;
                        Routes.pop(context, 5);
                      }),
                      SettingsCheckMarkButton(
                          7,
                          _settingsModel.nrOfDaysToDisplayLandscape,
                          'Vis mandag til søndag', () {
                        _settingsModel.displayDaysRelativeLandscape = false;
                        Routes.pop(context, 7);
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
