import 'package:api_client/models/settings_model.dart';
import 'package:api_client/models/username_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/style/standard_week_colors.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section_colorThemeButton.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section_item.dart';

/// This class is used to select the color theme for a citizen's weekplans
class ColorThemeSelectorScreen extends StatelessWidget {
  /// Constructor
  ColorThemeSelectorScreen({@required UsernameModel user}) : _user = user {
    _settingsBloc.loadSettings(_user);
  }

  final SettingsBloc _settingsBloc = di.getDependency<SettingsBloc>();
  final UsernameModel _user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GirafAppBar(
          title: _user.name + ': Farver på ugeplan',
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
                        'Farvetema', _createSettingList(_settingsModel)
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }

  // TODO(eneder17): få lavet lavet vores egen udgave af checkMarkButton.
  // Den skal ikke bare sammenligner ints men weekDayColor værdier.
  // Derefter få brugt den her og gjort så knapperne ændrer værdien af
  // _settingsModel.weekDayColors.
  List<SettingsSectionItem> _createSettingList(SettingsModel _settingsModel) {

    final List<SettingsSectionItem> settingsList = <SettingsSectionItem>[];

    settingsList.add(SettingsColorThemeCheckMarkButton(
        WeekplanColorTheme.standardColorSetting(),
        _settingsModel.weekDayColors , 'Standard', () {
          _settingsModel.weekDayColors =
              WeekplanColorTheme.standardColorSetting();
          _settingsBloc.updateSettings(_user.id, _settingsModel);

    }));

    settingsList.add(SettingsColorThemeCheckMarkButton(
        WeekplanColorTheme.blueWhiteColorSetting(),
          _settingsModel.weekDayColors, 'Blå/Hvid', () {
            _settingsModel.weekDayColors =
                WeekplanColorTheme.blueWhiteColorSetting();
            _settingsBloc.updateSettings(_user.id, _settingsModel);
    }));

    settingsList.add(SettingsColorThemeCheckMarkButton(
        WeekplanColorTheme.greyWhiteColorSetting(),
        _settingsModel.weekDayColors, 'Grå/Hvid', () {
          _settingsModel.weekDayColors =
              WeekplanColorTheme.greyWhiteColorSetting();
          _settingsBloc.updateSettings(_user.id, _settingsModel);
    }));

    return settingsList;
  }
}
