import 'package:api_client/api/account_api.dart';
import 'package:api_client/api/api.dart';
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
import 'package:weekplanner/screens/settings_screens/user_settings_screen.dart';
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
import 'change_username_screen.dart';
import 'completed_activity_icon_selection_screen.dart';

/// Shows all the users settings, and lets them change them
class SettingsScreen extends StatelessWidget {
  /// Constructor
  SettingsScreen(DisplayNameModel user) : _user = user {
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
        _buildTimerSection(context),
        _buildTimeRepresentationSettings(context),
        _buildUserSettings(),
        _buildPrivacySection()
      ],
    );
  }

  Widget _buildThemeSection(BuildContext context) {
    return StreamBuilder<SettingsModel>(
        stream: _settingsBloc.settings,
        builder: (BuildContext context,
            AsyncSnapshot<SettingsModel> settingsSnapshot) {
          if (settingsSnapshot.hasData) {
            final SettingsModel settingsModel = settingsSnapshot.data;
            return SettingsSection('Tema', <SettingsSectionItem>[
              SettingsArrowButton('Farver på ugeplan', () async {
                final Object result = await Routes.push(
                    context, ColorThemeSelectorScreen(user: _user));
                settingsModel.weekDayColors = result;
                _settingsBloc
                    .updateSettings(_user.id, settingsModel)
                    .listen((_) {
                  _settingsBloc.loadSettings(_user);
                });
              },
                  titleTrailing: ThemeBox.fromHexValues(
                      settingsModel.weekDayColors[0].hexColor,
                      settingsModel.weekDayColors[1].hexColor)),
              SettingsArrowButton('Tegn for udførelse', () async {
                final Object result = await Routes.push(
                    context, CompletedActivityIconScreen(_user));
                if (result != null) {
                  settingsModel.completeMark = result;
                  _settingsBloc
                      .updateSettings(_user.id, settingsModel)
                      .listen((_) {
                    _settingsBloc.loadSettings(_user);
                  });
                }
              },
                  titleTrailing: Text(settingsModel.completeMark ==
                          CompleteMark.Checkmark
                      ? 'Flueben'
                      : settingsModel.completeMark == CompleteMark.MovedRight
                          ? 'Lav aktiviteten grå'
                          : 'Fjern aktiviteten'))
            ]);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _buildOrientationSection() {
    return SettingsSection('Orientering', <SettingsSectionItem>[
      SettingsCheckMarkButton(5, 5, 'Landskab', () {}),
    ]);
  }

  Widget _buildWeekPlanSection(BuildContext context) {
    return StreamBuilder<SettingsModel>(
        stream: _settingsBloc.settings,
        builder: (BuildContext context,
            AsyncSnapshot<SettingsModel> settingsSnapshot) {
          if (settingsSnapshot.hasData) {
            final SettingsModel settingsModel = settingsSnapshot.data;
            return SettingsSection('Ugeplan', <SettingsSectionItem>[
              SettingsArrowButton(
                'Antal dage', () async {
                  final Object result = await Routes.push(
                      context, NumberOfDaysScreen(_user));
                  if(result != null) {
                    settingsModel.nrOfDaysToDisplay = result;
                    _settingsBloc.updateSettings(
                        _user.id, settingsModel)
                      .listen((_) {
                        _settingsBloc.loadSettings(_user);
                      }
                    );
                  }
                },
                titleTrailing: Text(settingsModel.nrOfDaysToDisplay == 1
                    ? 'En dag'
                    : settingsModel.nrOfDaysToDisplay == 2
                    ? 'To dage'
                    : settingsModel.nrOfDaysToDisplay == 5
                    ? 'Mandag til fredag'
                    : 'Mandag til søndag'),
              ),
              SettingsCheckMarkButton.fromBoolean(
                settingsModel.pictogramText, 'Piktogram tekst er synlig', () {
                  settingsModel.pictogramText = !settingsModel.pictogramText;
                  _settingsBloc.updateSettings(_user.id, settingsModel)
                      .listen((_) {
                        _settingsBloc.loadSettings(_user);
                  });
                }),
              SettingsCheckMarkButton.fromBoolean(
                settingsModel.showPopup, 'Vis bekræftelse popups', () {
                  settingsModel.showPopup = !settingsModel.showPopup;
                  _settingsBloc.updateSettings(_user.id, settingsModel)
                      .listen((_) {
                        _settingsBloc.loadSettings(_user);
                  });
                }),
            ]);
          } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
        });
  }

  Widget _buildTimerSection(BuildContext context) {
    return StreamBuilder<SettingsModel>(
        stream: _settingsBloc.settings,
        builder: (BuildContext context,
            AsyncSnapshot<SettingsModel> settingsSnapshot) {
          if (settingsSnapshot.hasData) {
            final SettingsModel _settingsModel = settingsSnapshot.data;
            return SettingsSection('Tid', <SettingsSectionItem>[
              SettingsCheckMarkButton.fromBoolean(
                _settingsModel.lockTimerControl, 'Lås tidsstyring', () {
                  _settingsModel.lockTimerControl =
                  !_settingsModel.lockTimerControl;
                  _settingsBloc.updateSettings(_user.id, _settingsModel)
                      .listen((_) {
                        _settingsBloc.loadSettings(_user);
                  });
              })
            ]);
          } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
        });
  }

  Widget _buildUserSettings() {
    return StreamBuilder<SettingsModel>(
        stream: _settingsBloc.settings,
        builder: (BuildContext context,
            AsyncSnapshot<SettingsModel> settingsSnapshot) {
          if (settingsSnapshot.hasData) {
            final SettingsModel settingsModel = settingsSnapshot.data;
            return SettingsSection(
                'Bruger indstillinger', <SettingsSectionItem>[
              SettingsArrowButton(
                _user.displayName + ' indstillinger',
                () async {
                  final Object result =
                      await Routes.push(context, SettingsScreen(_user));
                  if (result != null) {
                    settingsModel.nrOfDaysToDisplay = result;
                    _settingsBloc
                        .updateSettings(_user.id, settingsModel)
                        .listen((_) {
                      _settingsBloc.loadSettings(_user);
                    });
                  }
                },
              ),
              SettingsArrowButton('Skift brugernavn',
                    () async {
                final Object result =
                await Routes.push(context, ChangeUsernameScreen(_user));
                if (result != null) {
                  settingsModel.nrOfDaysToDisplay = result;
                  _settingsBloc
                      .updateSettings(_user.id, settingsModel)
                      .listen((_) {
                    _settingsBloc.loadSettings(_user);
                  });
                }
              },),
              SettingsArrowButton(
                'Skift kodeord',
                () async {
                  final Object result =
                      await Routes.push(context, ChangePasswordScreen(_user));
                  if (result != null) {
                    settingsModel.nrOfDaysToDisplay = result;
                    _settingsBloc
                        .updateSettings(_user.id, settingsModel)
                        .listen((_) {
                      _settingsBloc.loadSettings(_user);
                    });
                  }
                },
              ),
            ]);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });

    /*
        return SettingsSection('Bruger indstillinger', <SettingsSectionItem>[
          SettingsArrowButton(_user.displayName + ' indstillinger', () {}),
        ]);
              */
  }

  Widget _buildPrivacySection() {
    return StreamBuilder<SettingsModel>(
      stream: _settingsBloc.settings,
      builder: (BuildContext context,
        AsyncSnapshot<SettingsModel> settingsSnapshot) {
          return SettingsSection('Privatliv', <SettingsSectionItem>[
            SettingsArrowButton('Privatlivsinformationer', () =>
              Routes.push(context, PrivacyInformationScreen())
                .then((Object object) => _settingsBloc.loadSettings(_user)),
            ),
          ]);
      });
  }

  Widget _buildTimeRepresentationSettings(BuildContext context) {
    return StreamBuilder<SettingsModel>(
      stream: _settingsBloc.settings,
      builder: (BuildContext context,
        AsyncSnapshot<SettingsModel> settingsSnapshot) {
          if (settingsSnapshot.hasData) {
            final DefaultTimer userTimer = settingsSnapshot.data.defaultTimer;
            final SettingsModel settingsModel = settingsSnapshot.data;
            return SettingsSection('Tidsrepræsentation', <SettingsSectionItem>[
              SettingsArrowButton(
                'Indstillinger for tidsrepræsentation',
                () async {
                  final Object result = await Routes.push(
                      context, TimeRepresentationScreen(_user));
                  settingsModel.defaultTimer = result;
                  _settingsBloc
                      .updateSettings(_user.id, settingsModel)
                      .listen((_) {
                    _settingsBloc.loadSettings(_user);
                  });
                },
                titleTrailing: Image(
                    width: 50,
                    height: 50,
                    image: AssetImage(userTimer == DefaultTimer.PieChart
                        ? 'assets/timer/piechart_icon.png'
                        : userTimer == DefaultTimer.Hourglass
                            ? 'assets/timer/hourglass_icon.png'
                            : 'assets/timer/countdowntimer_icon.png')),
              )
            ]);
          } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
      });
  }
}
