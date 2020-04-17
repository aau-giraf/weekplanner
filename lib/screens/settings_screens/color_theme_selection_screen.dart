import 'package:api_client/models/enums/weekday_enum.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/weekday_color_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/style/custom_color.dart';
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
                        'Farvetema', _createSettingList(_settingsModel)),
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
    settingsList.add(ColorThemeCheckMarkButton(_standardColorSetting(),
        _settingsModel.weekDayColors , 'Standard', () {
      _settingsModel.weekDayColors = _standardColorSetting();
      _settingsBloc.updateSettings(_user.id, _settingsModel);
    }));
    settingsList.add(ColorThemeCheckMarkButton(_blueWhiteColorSetting(),
        _settingsModel.weekDayColors, 'Blå/Hvid', () {
      _settingsModel.weekDayColors = _blueWhiteColorSetting();
      _settingsBloc.updateSettings(_user.id, _settingsModel);
    }));
    settingsList.add(ColorThemeCheckMarkButton(_greyWhiteColorSetting(),
        _settingsModel.weekDayColors, 'Grå/Hvid', () {
      _settingsModel.weekDayColors = _greyWhiteColorSetting();
      _settingsBloc.updateSettings(_user.id, _settingsModel);
    }));

    return settingsList;
  }

  List<WeekdayColorModel> _standardColorSetting(){
    final List<WeekdayColorModel> weekDayColors = <WeekdayColorModel>[];
    weekDayColors.add(WeekdayColorModel(
        hexColor: '#08A045',
        day: Weekday.Monday
    ));
    weekDayColors.add(WeekdayColorModel(
        hexColor: '#540D6E',
        day: Weekday.Tuesday
    ));
    weekDayColors.add(WeekdayColorModel(
        hexColor: '#F77F00',
        day: Weekday.Wednesday
    ));
    weekDayColors.add(WeekdayColorModel(
        hexColor: '#004777',
        day: Weekday.Thursday
    ));
    weekDayColors.add(WeekdayColorModel(
        hexColor: '#F9C80E',
        day: Weekday.Friday
    ));
    weekDayColors.add(WeekdayColorModel(
        hexColor: '#DB2B39',
        day: Weekday.Saturday
    ));
    weekDayColors.add(WeekdayColorModel(
        hexColor: '#FFFFFF',
        day: Weekday.Sunday
    ));

    return weekDayColors;
  }

  List<WeekdayColorModel> _blueWhiteColorSetting(){
    final List<WeekdayColorModel> weekDayColors = <WeekdayColorModel>[];
    weekDayColors.add(WeekdayColorModel(
        hexColor: GirafColors.blue.toString(),
        day: Weekday.Monday
    ));
    weekDayColors.add(WeekdayColorModel(
        hexColor: GirafColors.white.toString(),
        day: Weekday.Tuesday
    ));
    weekDayColors.add(WeekdayColorModel(
        hexColor: GirafColors.blue.toString(),
        day: Weekday.Wednesday
    ));
    weekDayColors.add(WeekdayColorModel(
        hexColor: GirafColors.white.toString(),
        day: Weekday.Thursday
    ));
    weekDayColors.add(WeekdayColorModel(
        hexColor: GirafColors.blue.toString(),
        day: Weekday.Friday
    ));
    weekDayColors.add(WeekdayColorModel(
        hexColor: GirafColors.white.toString(),
        day: Weekday.Saturday
    ));
    weekDayColors.add(WeekdayColorModel(
        hexColor: GirafColors.blue.toString(),
        day: Weekday.Sunday
    ));

    return weekDayColors;
  }

  List<WeekdayColorModel> _greyWhiteColorSetting(){
    final List<WeekdayColorModel> weekDayColors = <WeekdayColorModel>[];
    weekDayColors.add(WeekdayColorModel(
        hexColor: GirafColors.grey.toString(),
        day: Weekday.Monday
    ));
    weekDayColors.add(WeekdayColorModel(
        hexColor: GirafColors.white.toString(),
        day: Weekday.Tuesday
    ));
    weekDayColors.add(WeekdayColorModel(
        hexColor: GirafColors.grey.toString(),
        day: Weekday.Wednesday
    ));
    weekDayColors.add(WeekdayColorModel(
        hexColor: GirafColors.white.toString(),
        day: Weekday.Thursday
    ));
    weekDayColors.add(WeekdayColorModel(
        hexColor: GirafColors.grey.toString(),
        day: Weekday.Friday
    ));
    weekDayColors.add(WeekdayColorModel(
        hexColor: GirafColors.white.toString(),
        day: Weekday.Saturday
    ));
    weekDayColors.add(WeekdayColorModel(
        hexColor: GirafColors.grey.toString(),
        day: Weekday.Sunday
    ));

    return weekDayColors;
  }

}
