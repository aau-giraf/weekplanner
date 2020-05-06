import 'package:api_client/models/enums/complete_mark_enum.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section_checkboxButton.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section_item.dart';

import '../../di.dart';

/// Screen where the icon for completed activity can be chosen
class CompletedActivityIconScreen extends StatelessWidget {
  /// Constructor
  CompletedActivityIconScreen(DisplayNameModel user) : _user = user {
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
                    SettingsSection('Tegn for udførelse', <SettingsSectionItem>[
                      SettingsCheckMarkButton(
                          0,
                          _settingsModel.completeMark.index,
                          'Fjern aktiviteten for borgeren', () {
                              _settingsModel.completeMark =
                                  CompleteMark.Removed;
                              _settingsBloc.updateSettings(_user.id,
                                _settingsModel).listen((SettingsModel model) {
                                  _settingsBloc.loadSettings(_user);
                              });
                          }),
                      SettingsCheckMarkButton(
                          1,
                          _settingsModel.completeMark.index,
                          'Flueben', () {
                        _settingsModel.completeMark = CompleteMark.Checkmark;
                        _settingsBloc.updateSettings(_user.id, _settingsModel).
                            listen((SettingsModel model) {
                              _settingsBloc.loadSettings(_user);
                        });
                      }),
                      SettingsCheckMarkButton(
                          2,
                          _settingsModel.completeMark.index,
                          'Lav aktiviteten grå', () {
                        _settingsModel.completeMark = CompleteMark.MovedRight;
                        _settingsBloc.updateSettings(_user.id, _settingsModel).
                            listen((SettingsModel model) {
                              _settingsBloc.loadSettings(_user);
                        });
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
