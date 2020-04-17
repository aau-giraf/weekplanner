
import 'package:api_client/models/weekday_color_model.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section_item.dart';
import '../../style/custom_color.dart' as theme;

/// Button used for the color theme settings
class ColorThemeCheckMarkButton extends SettingsSectionItem {

  /// Constructor
  const ColorThemeCheckMarkButton(
      this._expected, this._current, this._text, this._callback);


  final List<WeekdayColorModel> _expected, _current;

  final String _text;

  final VoidCallback _callback;


  @override
  ListTile build(BuildContext context) {
    Widget trailing;
    if (_shouldHaveCheckmark()) {
      trailing = Icon(Icons.check, color: theme.GirafColors.black);
    } else {
      trailing = null;
    }

    return ListTile(
      title: Text(_text),
      trailing: trailing,
      onTap: () => _callback(),
    );
  }

  bool _shouldHaveCheckmark(){
    if(_expected.length != _current.length) {
      return false;
    }

    for(int i = 0; i < _expected.length; i++) {
      if(_expected[i].hexColor != _current[i].hexColor) {
        return false;
      }
      if(_expected[i].day != _current[i].day) {
        return false;
      }
    }
    return true;
  }

}