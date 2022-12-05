import 'package:flutter/material.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section_item.dart';
import '../../style/custom_color.dart' as theme;

/// SettingSection ArrowButton class
class SettingsDeleteButton extends SettingsSectionItem {
  /// Constructor
  const SettingsDeleteButton(this.text, this._callback);

  /// Text on button
  final String text;

  /// Function to run on tap
  final VoidCallback _callback;

  @override
  ListTile build(BuildContext context) {
    return ListTile(
      title: buildTitle(),
      onTap: () => _callback(),
    );
  }

  /// Builds the text with or without the optional trailing widget
  Widget buildTitle() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(text, style: const TextStyle(color: theme.GirafColors.red),),
        ],
      );
    }
  }

