import 'package:flutter/material.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section_item.dart';
import '../../style/custom_color.dart' as theme;

/// SettingSection CheckMarkButton class
class SettingsCheckMarkButton extends SettingsSectionItem {
  /// Constructor
  SettingsCheckMarkButton(
      this.expected, this.current, this.text, this.callback);

  /// Constructor that can be used to create the button from a boolean value
  /// instead of two integer values.
  SettingsCheckMarkButton.fromBool(
      bool shouldBeChecked, this.text, this.callback){
    if(shouldBeChecked == true) {
      this.expected = 0;
      this.current = 0;
    } else {
      this.expected = 0;
      this.current = 1;
    }
  }


  /// Values used to keep track of, if the check should be shown
  int expected, current;

  /// Text on button
  final String text;

  /// Function to run on tap
  final VoidCallback callback;

  @override
  ListTile build(BuildContext context) {
    Widget trailing;
    if (expected == current) {
      trailing = Icon(Icons.check, color: theme.GirafColors.black);
    } else {
      trailing = null;
    }

    return ListTile(
      title: Text(text),
      trailing: trailing,
      onTap: () => callback(),
    );
  }
}
