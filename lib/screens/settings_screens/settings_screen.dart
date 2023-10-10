import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/complete_mark_enum.dart';
import 'package:api_client/models/enums/default_timer_enum.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/settings_screens/'
    'color_theme_selection_screen.dart';
import 'package:weekplanner/screens/settings_screens/number_of_activities_selection_screen.dart';
import 'package:weekplanner/screens/settings_screens/'
    'number_of_days_selection_screen.dart';
import 'package:weekplanner/screens/settings_screens/'
    'privacy_information_screen.dart';
import 'package:weekplanner/screens/settings_screens/time_representation_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_confirm_dialog.dart';
import 'package:weekplanner/widgets/giraf_notify_dialog.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_delete_button.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section.dart';
import 'package:weekplanner/widgets/settings_widgets/'
    'settings_section_arrow_button.dart';
import 'package:weekplanner/widgets/settings_widgets/'
    'settings_section_checkboxButton.dart';
import 'package:weekplanner/widgets/settings_widgets/'
    'settings_section_item.dart';

import '../../di.dart';
import '../../widgets/settings_widgets/settings_theme_display_box.dart';
import 'change_password_screen.dart';
import 'change_username_screen.dart';
import 'completed_activity_icon_selection_screen.dart';

/// Shows all the users settings, and lets them change them
class SettingsScreen extends StatelessWidget {
  /// Constructor
  SettingsScreen(DisplayNameModel user) : _user = user {
    _settingsBloc.loadSettings(_user);
  }

  final DisplayNameModel _user;

  final SettingsBloc _settingsBloc = di.get<SettingsBloc>();

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
        _buildUserSettings(context),
        _buildTimeRepresentationSettings(context),
        _buildPrivacySection(),
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
                final Object result = await Routes()
                    .push(context, ColorThemeSelectorScreen(user: _user));
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
                final Object result = await Routes()
                    .push(context, CompletedActivityIconScreen(_user));
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
                'Antal dage der vises når enheden er på højkant',
                () async {
                  final Object result = await Routes().push(
                      context, NumberOfDaysScreen(_user, true, settingsModel));
                  if (result != null) {
                    settingsModel.nrOfDaysToDisplayPortrait = result;
                    _settingsBloc
                        .updateSettings(_user.id, settingsModel)
                        .listen((_) {
                      _settingsBloc.loadSettings(_user);
                    });
                  }
                },
                titleTrailing: Text(
                    nrOfDaysToString(settingsModel.nrOfDaysToDisplayPortrait)),
              ),
              SettingsArrowButton(
                'Antal dage der vises når enheden er på langs',
                () async {
                  final Object result = await Routes().push(
                      context, NumberOfDaysScreen(_user, false, settingsModel));
                  if (result != null) {
                    settingsModel.nrOfDaysToDisplayLandscape = result;
                    _settingsBloc
                        .updateSettings(_user.id, settingsModel)
                        .listen((_) {
                      _settingsBloc.loadSettings(_user);
                    });
                  }
                },
                titleTrailing: Text(
                    nrOfDaysToString(settingsModel.nrOfDaysToDisplayLandscape)),
              ),
              SettingsCheckMarkButton.fromBoolean(
                  settingsModel.pictogramText, 'Piktogram tekst er synlig', () {
                settingsModel.pictogramText = !settingsModel.pictogramText;
                _settingsBloc
                    .updateSettings(_user.id, settingsModel)
                    .listen((_) {
                  _settingsBloc.loadSettings(_user);
                });
              }),
              SettingsCheckMarkButton.fromBoolean(
                  settingsModel.showPopup, 'Vis bekræftelse popups', () {
                settingsModel.showPopup = !settingsModel.showPopup;
                _settingsBloc
                    .updateSettings(_user.id, settingsModel)
                    .listen((_) {
                  _settingsBloc.loadSettings(_user);
                });
              }),
              SettingsCheckMarkButton.fromBoolean(
                  settingsModel.showOnlyActivities, 'Vis kun aktiviteter', () {
                settingsModel.showOnlyActivities =
                    !settingsModel.showOnlyActivities;
                _settingsBloc
                    .updateSettings(_user.id, settingsModel)
                    .listen((_) {
                  _settingsBloc.loadSettings(_user);
                });
              }),
              SettingsArrowButton(
                'Hvor mange aktiviteter skal vises på vis kun aktiviter',
                () async {
                  final Object result = await Routes().push(
                      context, NumberOfActivitiesScreen(_user, settingsModel));
                  if (result != null) {
                    settingsModel.nrOfActivitiesToDisplay = result;
                    _settingsBloc
                        .updateSettings(_user.id, settingsModel)
                        .listen((_) {
                      _settingsBloc.loadSettings(_user);
                    });
                  }
                },
                titleTrailing: Text(nrOfActivitiesToString(
                    settingsModel.nrOfActivitiesToDisplay)),
              ),
            ]);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  /// Takes in one of the possible nrOfDaysToDisplay,
  ///  and returns its corresponding string
  String nrOfDaysToString(int nrOfDaysToDisplay) {
    switch (nrOfDaysToDisplay) {
      case 1:
        {
          return 'En dag';
        }
      case 2:
        {
          return 'To dage';
        }
      case 5:
        {
          return 'Mandag til fredag';
        }
      case 7:
        {
          return 'Mandag til søndag';
        }
      default:
        {
          if (nrOfDaysToDisplay == null) {
            //The value can be null in some tests that uses the settingsmodel,
            // but does not use the nrOfDaysToDisplay value
            return '';
          }
          throw Exception(nrOfDaysToDisplay.toString() +
              ' is not a valid '
                  'value for nrOfDaysToDisplay. It must be either 1,2,5, or 7');
        }
    }
  }

  String nrOfActivitiesToString(int nrOfActivitiesToDisplay) {
    switch (nrOfActivitiesToDisplay) {
      case 1:
        {
          return '1 aktivitet';
        }
      case 2:
        {
          return '2 aktiviteter';
        }
      case 3:
        {
          return '3 aktiviteter';
        }
      case 4:
        {
          return '4 aktiviteter';
        }
      case 5:
        {
          return '5 aktiviteter';
        }
      case 6:
        {
          return '6 aktiviteter';
        }
      case 7:
        {
          return '7 aktiviteter';
        }
      case 8:
        {
          return '8 aktiviteter';
        }
      case 9:
        {
          return '9 aktiviteter';
        }
      case 10:
        {
          return '10 aktiviteter';
        }
      default:
        {
          if (nrOfActivitiesToDisplay == 0) {
            //The value can be null in some tests that uses the settingsmodel,
            // but does not use the nrOfActivitiesToDisplay value
            return '1 aktiviter';
          }
          throw Exception(nrOfActivitiesToDisplay.toString() +
              ' is not a valid '
                  'value for nrOfActivitiesToDisplay.'
                  'It must be either 1 through 10');
        }
    }
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
                _settingsBloc
                    .updateSettings(_user.id, _settingsModel)
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

  Widget _buildUserSettings(BuildContext context) {
    String input = '';
    return StreamBuilder<SettingsModel>(
        stream: _settingsBloc.settings,
        builder: (BuildContext context,
            AsyncSnapshot<SettingsModel> settingsSnapshot) {
          if (settingsSnapshot.hasData) {
            final SettingsModel settingsModel = settingsSnapshot.data;
            return SettingsSection(
                'Bruger indstillinger', <SettingsSectionItem>[
              SettingsCheckMarkButton.fromBoolean(
                  settingsModel.showSettingsForCitizen,
                  'Giv borger adgang til deres indstillinger.', () {
                settingsModel.showSettingsForCitizen =
                    !settingsModel.showSettingsForCitizen;
                _settingsBloc
                    .updateSettings(_user.id, settingsModel)
                    .listen((_) {
                  _settingsBloc.loadSettings(_user);
                });
              }),
              SettingsArrowButton(
                'Skift brugernavn',
                () async {
                  final Object result =
                      await Routes().push(context, ChangeUsernameScreen(_user));
                  if (result != null) {
                    _settingsBloc
                        .updateSettings(_user.id, settingsModel)
                        .listen((_) {
                      _settingsBloc.loadSettings(_user);
                    });
                  }
                },
              ),
              SettingsArrowButton(
                'Skift kodeord',
                () async {
                  final Object result =
                      await Routes().push(context, ChangePasswordScreen(_user));
                  if (result != null) {
                    _settingsBloc
                        .updateSettings(_user.id, settingsModel)
                        .listen((_) {
                      _settingsBloc.loadSettings(_user);
                    });
                  }
                },
              ),
              //Code for delete button
              SettingsDeleteButton('Slet bruger', () {
                showDialog<Center>(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return GirafConfirmDialog(
                        title: 'Slet bruger',
                        descriptionRichText: RichText(
                          text: TextSpan(
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Quicksand'),
                              children: <TextSpan>[
                                const TextSpan(
                                    text: 'For at slette denne bruger,'
                                        ' indtast '),
                                TextSpan(
                                    text: _user.displayName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const TextSpan(text: ' i feltet herunder')
                              ]),
                        ),
                        inputField: TextField(
                          onChanged: (String text) {
                            input = text;
                          },
                          style: const TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            border: OutlineInputBorder(),
                            hintText: 'Indtast navn',
                          ),
                        ),
                        confirmButtonText: 'Slet',
                        confirmButtonIcon: const ImageIcon(
                            AssetImage('assets/icons/delete.png')),
                        confirmOnPressed: () {
                          //if the correct name is written delete the user,
                          // else provide an error
                          if (input == _user.displayName) {
                            _settingsBloc.deleteUser(_user.id);
                            Routes().goHome(context);
                          } else {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) =>
                                    const GirafNotifyDialog(
                                        title: 'Fejl',
                                        description: 'Det indtastede navn'
                                            ' er forkert!'));
                          }
                        },
                      );
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

  Widget _buildPrivacySection() {
    return StreamBuilder<SettingsModel>(
        stream: _settingsBloc.settings,
        builder: (BuildContext context,
            AsyncSnapshot<SettingsModel> settingsSnapshot) {
          return SettingsSection('Privatliv', <SettingsSectionItem>[
            SettingsArrowButton(
              'Privatlivsinformationer',
              () => Routes()
                  .push(context, PrivacyInformationScreen())
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
                  final Object result = await Routes()
                      .push(context, TimeRepresentationScreen(_user));
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
