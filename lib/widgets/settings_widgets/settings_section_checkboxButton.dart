import 'package:flutter/material.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section_item.dart';
import '../../style/custom_color.dart' as theme;

/// SettingSection CheckMarkButton class
class SettingsCheckMarkButton extends SettingsSectionItem {
  /// Constructor
  const SettingsCheckMarkButton(
      this.expected, this.current, this.text, this.callback);

  /// Constructor to create CheckMarkButton from a boolean value
  factory SettingsCheckMarkButton.fromBoolean(bool shouldBeChecked,
      String text,
      VoidCallback callback){
    if (shouldBeChecked) {
      return SettingsCheckMarkButton(1, 1, text, callback);
    }
    return SettingsCheckMarkButton(1, 2, text, callback);
  }

  /// Values used to keep track of, if the check should be shown
  final int expected, current;

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
