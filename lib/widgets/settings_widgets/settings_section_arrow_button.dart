import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section_item.dart';

/// SettingSection ArrowButton class
class SettingsArrowButton extends SettingsSectionItem {
  /// Constructor
  const SettingsArrowButton(this.text, this.callback);

  /// Text on button
  final String text;

  /// Function to run on tap
  final VoidCallback callback;

  @override
  ListTile build(BuildContext context) {
    return ListTile(
      title: Text(text),
      trailing: Icon(
        Icons.arrow_forward,
        color: Colors.black,
      ),
      onTap: () => callback(),
    );
  }
}