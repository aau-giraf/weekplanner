import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/default_timer_enum.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section_checkboxButton.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section_item.dart';

import '../../di.dart';

/// Screen responsible for changeing which timer to show a citizen
class TimeRepresentationScreen extends StatelessWidget {
  /// Constructor
  TimeRepresentationScreen(DisplayNameModel user) : _user = user {
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
                    SettingsSection(
                        'Vælg Tidsrepræsentation', <SettingsSectionItem>[
                      SettingsCheckMarkButton(DefaultTimer.PieChart,
                          _settingsModel.defaultTimer, 'Standard', () {
                        _settingsModel.defaultTimer = DefaultTimer.PieChart;
                        _settingsBloc
                            .updateSettings(_user.id, _settingsModel)
                            .listen((SettingsModel response) {
                          if (response != null) {
                            Routes.pop(context);
                          }
                        });
                      }, DefaultTimer.PieChart),
                      SettingsCheckMarkButton(DefaultTimer.Hourglass,
                          _settingsModel.defaultTimer, 'Timeglas', () {
                        _settingsModel.defaultTimer = DefaultTimer.Hourglass;
                        _settingsBloc
                            .updateSettings(_user.id, _settingsModel)
                            .listen((SettingsModel response) {
                          if (response != null) {
                            Routes.pop(context);
                          }
                        });
                      }, DefaultTimer.Hourglass),
                      SettingsCheckMarkButton(DefaultTimer.Numeric,
                          _settingsModel.defaultTimer, 'Nedtælling', () {
                        _settingsModel.defaultTimer = DefaultTimer.Numeric;
                        _settingsBloc
                            .updateSettings(_user.id, _settingsModel)
                            .listen((SettingsModel response) {
                          if (response != null) {
                            Routes.pop(context);
                          }
                        });
                      }, DefaultTimer.Numeric)
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
