import 'package:flutter/material.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section_item.dart';

/// SettingSection CheckMarkButton class
class SettingsCheckMarkButton extends SettingsSectionItem {
  /// Constructor
  const SettingsCheckMarkButton(this.text, this.callback);

  /// Text on button
  final String text;

  /// Function to run on tap
  final VoidCallback callback;

  @override
  ListTile build(BuildContext context) {
    return ListTile(
      title: Text(text),
      trailing: Icon(
        Icons.check_box,
        color: Colors.black,
      ),
      onTap: () => callback(),
    );
  }
}
