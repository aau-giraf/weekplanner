import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/weekday_enum.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/weekday_color_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/blocs/weekplan_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';
import 'package:weekplanner/models/enums/weekplan_mode.dart';
import 'package:weekplanner/models/user_week_model.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/settings_screens/settings_screen.dart';
import 'package:weekplanner/widgets/bottom_app_bar_button_widget.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_confirm_dialog.dart';
import 'package:weekplanner/widgets/giraf_copy_activities_dialog.dart';
import 'package:weekplanner/widgets/weekplan_screen_widgets/weekplan_day_column.dart';

import '../style/custom_color.dart' as theme;

/// <summary>
/// The WeekplanScreen is used to display a week
/// and all the activities that occur in it.
/// </summary>
class WeekplanScreen extends StatelessWidget {
  /// <summary>
  /// WeekplanScreen constructor
  /// </summary>
  /// <param name="key">Key of the widget</param>
  /// <param name="week">Week that should be shown on the weekplan</param>
  /// <param name="user">owner of the weekplan</param>
  WeekplanScreen(this._week, this._user, {Key key}) : super(key: key) {
    _weekplanBloc.loadWeek(_week, _user);
    _settingsBloc.loadSettings(_user);
  }

  final WeekplanBloc _weekplanBloc = di.getDependency<WeekplanBloc>();
  final SettingsBloc _settingsBloc = di.getDependency<SettingsBloc>();
  final AuthBloc _authBloc = di.getDependency<AuthBloc>();
  final DisplayNameModel _user;
  final WeekModel _week;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<WeekplanMode>(
        stream: _authBloc.mode,
        builder: (BuildContext context,
            AsyncSnapshot<WeekplanMode> weekModeSnapshot) {
          if (weekModeSnapshot.data == WeekplanMode.citizen) {
            _weekplanBloc.setEditMode(false);
          }
          return WillPopScope(
            onWillPop: () async =>
                weekModeSnapshot.data == WeekplanMode.guardian,
            child: Scaffold(
              appBar: GirafAppBar(
                title: _user.displayName + ' - ' + _week.name,
                appBarIcons: (weekModeSnapshot.data == WeekplanMode.guardian)
                    ? <AppBarIcon, VoidCallback>{
                        AppBarIcon.edit: () => _weekplanBloc.toggleEditMode(),
                        AppBarIcon.changeToCitizen: () {},
                        AppBarIcon.logout: () {},
                        AppBarIcon.settings: () =>
                            Routes.push<WeekModel>(context,
                            SettingsScreen(_user)).then((WeekModel newWeek) =>
                                _settingsBloc.loadSettings(_user)),
                      }

                    : <AppBarIcon, VoidCallback>{
                        AppBarIcon.changeToGuardian: () {}
                      },
                isGuardian: weekModeSnapshot.data == WeekplanMode.guardian,
              ),
              body: StreamBuilder<UserWeekModel>(
                stream: _weekplanBloc.userWeek,
                initialData: null,
                builder: (BuildContext context,
                    AsyncSnapshot<UserWeekModel> snapshot) {
                  if (snapshot.hasData) {
                    return _buildWeeks(snapshot.data.week, context);
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              bottomNavigationBar: StreamBuilder<WeekplanMode>(
                stream: _authBloc.mode,
                initialData: WeekplanMode.guardian,
                builder: (BuildContext context,
                    AsyncSnapshot<WeekplanMode> snapshot) {
                  return Visibility(
                    visible: snapshot.data == WeekplanMode.guardian,
                    child: StreamBuilder<bool>(
                      stream: _weekplanBloc.editMode,
                      initialData: false,
                      builder:
                          (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        if (snapshot.data) {
                          return buildBottomAppBar(context);
                        } else {
                          return Container(width: 0.0, height: 0.0);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          );
        });
  }

  /// Builds the BottomAppBar when in edit mode
  BottomAppBar buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
        child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Expanded(
              child: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: <double>[
                        1 / 3,
                        2 / 3
                      ],
                          colors: <Color>[
                        theme.GirafColors.appBarYellow,
                        theme.GirafColors.appBarOrange,
                      ])),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      BottomAppBarButton(
                          buttonText: 'Aflys',
                          buttonKey: 'CancelActivtiesButton',
                          assetPath: 'assets/icons/cancel.png',
                          isEnabled: false,
                          isEnabledStream:
                              _weekplanBloc.atLeastOneActivityMarked,
                          dialogFunction: _buildCancelDialog),
                      BottomAppBarButton(
                          buttonText: 'Kopier',
                          buttonKey: 'CopyActivtiesButton',
                          assetPath: 'assets/icons/copy.png',
                          isEnabled: false,
                          isEnabledStream:
                              _weekplanBloc.atLeastOneActivityMarked,
                          dialogFunction: _buildCopyDialog),
                      BottomAppBarButton(
                          buttonText: 'Slet',
                          buttonKey: 'DeleteActivtiesButton',
                          assetPath: 'assets/icons/delete.png',
                          isEnabled: false,
                          isEnabledStream:
                              _weekplanBloc.atLeastOneActivityMarked,
                          dialogFunction: _buildRemoveDialog)
                    ],
                  )))
        ]));
  }

  void _copyActivities(List<bool> days, BuildContext context) {
    _weekplanBloc.copyMarkedActivities(days);
    Routes.pop(context);
    _weekplanBloc.toggleEditMode();
  }

  Future<Center> _buildCopyDialog(BuildContext context) {
    return showDialog<Center>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return GirafCopyActivitiesDialog(
            title: 'Kopier aktiviteter',
            description: 'Vælg hvilke dage de markerede aktiviteter skal '
                'kopieres til',
            confirmButtonText: 'Kopier',
            confirmButtonIcon:
                const ImageIcon(AssetImage('assets/icons/copy.png')),
            confirmOnPressed: _copyActivities,
          );
        });
  }

  /// Builds the dialog box to confirm marking activities as canceled
  Future<Center> _buildCancelDialog(BuildContext context) {
    return showDialog<Center>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return GirafConfirmDialog(
              title: 'Aflys aktiviteter',
              description: 'Vil du markere ' +
                  _weekplanBloc.getNumberOfMarkedActivities().toString() +
                  ' aktivitet(er) som aflyst',
              confirmButtonText: 'Bekræft',
              confirmButtonIcon:
                  const ImageIcon(AssetImage('assets/icons/accept.png')),
              confirmOnPressed: () {
                _weekplanBloc.cancelMarkedActivities();
                _weekplanBloc.toggleEditMode();

                // Closes the dialog box
                Routes.pop(context);
              });
        });
  }

  /// Builds dialog box to confirm/cancel deletion
  Future<Center> _buildRemoveDialog(BuildContext context) {
    return showDialog<Center>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return GirafConfirmDialog(
              title: 'Slet aktiviteter',
              description: 'Vil du slette ' +
                  _weekplanBloc.getNumberOfMarkedActivities().toString() +
                  ' aktivitet(er)',
              confirmButtonText: 'Slet',
              confirmButtonIcon:
                  const ImageIcon(AssetImage('assets/icons/delete.png')),
              confirmOnPressed: () {
                _weekplanBloc.deleteMarkedActivities();
                _weekplanBloc.toggleEditMode();

                // Closes the dialog box
                Routes.pop(context);
              });
        });
  }

  StreamBuilder<WeekplanMode> _buildWeeks(
      WeekModel weekModel, BuildContext context) {
    const List<Color> defaultWeekColors = <Color>[
      theme.GirafColors.mondayColor,
      theme.GirafColors.tuesdayColor,
      theme.GirafColors.wednesdayColor,
      theme.GirafColors.thursdayColor,
      theme.GirafColors.fridayColor,
      theme.GirafColors.saturdayColor,
      theme.GirafColors.sundayColor
    ];
    final List<Widget> weekDays = <Widget>[];

    final int _weekday = DateTime.now().weekday.toInt();
    int _weekdayCounter = 0;

    return StreamBuilder<WeekplanMode>(
        stream: _authBloc.mode,
        builder: (BuildContext context,
            AsyncSnapshot<WeekplanMode> weekModeSnapshot) {
          if (weekModeSnapshot.hasData) {
            final WeekplanMode role = weekModeSnapshot.data;

            if (role == WeekplanMode.guardian) {
              weekDays.clear();
              for (int i = 0; i < weekModel.days.length; i++) {
                weekDays.add(Expanded(
                    child: WeekplanDayColumn(
                  dayOfTheWeek: Weekday.values[i],
                  color: defaultWeekColors[i],
                  weekplanBloc: _weekplanBloc,
                  user: _user,
                )));
              }
              return Row(children: weekDays);
            } else if (role == WeekplanMode.citizen) {
              return StreamBuilder<SettingsModel>(
                stream: _settingsBloc.settings,
                builder: (BuildContext context,
                    AsyncSnapshot<SettingsModel> settingsSnapshot) {
                  if (settingsSnapshot.hasData) {
                    final SettingsModel _settingsModel = settingsSnapshot.data;
                    final int _daysToDisplay = _settingsModel.nrOfDaysToDisplay;

                    _weekdayCounter = 0;
                    // If the option of showing 1 or 2 days is chosen the
                    // _weekdayCounter must start from today's date
                    if (_daysToDisplay == 1 || _daysToDisplay == 2) {
                      _weekdayCounter = _weekday - 1; // monday = 0, sunday = 6
                    }
                    // Adding the selected number of days to weekDays
                    weekDays.clear();
                    for (int i = 0; i < _daysToDisplay; i++) {
                      // Get color from the citizen's chosen color theme
                      final String dayColor = _settingsModel.weekDayColors
                          .where((WeekdayColorModel w) =>
                              w.day == Weekday.values[_weekdayCounter])
                          .single
                          .hexColor
                          .replaceFirst('#', '0xff');
                      weekDays.add(Expanded(
                        child: WeekplanDayColumn(
                          dayOfTheWeek: Weekday.values[_weekdayCounter],
                          color: Color(int.parse(dayColor)),
                          weekplanBloc: _weekplanBloc,
                          user: _user,
                          )
                        )
                      );
                      if (_daysToDisplay == 2 && _weekdayCounter == 6) {
                        break;
                        /* If the user wants two days to display
                         * and today is sunday then it only shows one day
                         */
                      }
                      if (_weekdayCounter == 6) {
                        _weekdayCounter = 0;
                      } else {
                        _weekdayCounter += 1;
                      }
                    }
                  }
                  if (weekDays.length == 1) {
                    return Row(
                      key: const Key('SingleWeekdayRow'),
                      children: <Widget>[
                        const Spacer(flex: 2),
                        weekDays.first,
                        const Spacer(flex: 2),
                      ],
                    );
                  } else {
                    return Row(children: weekDays);
                  }
                },
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Row(children: weekDays);
        });
  }
}
