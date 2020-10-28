import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section_item.dart';
import '../../style/custom_color.dart' as theme;

/// SettingSection ArrowButton class
class SettingsArrowButton extends SettingsSectionItem {
  /// Constructor
  const SettingsArrowButton(this.text, this._callback, {this.titleTrailing});

  /// Text on button
  final String text;

  /// Function to run on tap
  final VoidCallback _callback;

  /// This is extra trailing that is added to the text
  /// The trailing will appear right before the arrow
  final Widget titleTrailing;

  @override
  ListTile build(BuildContext context) {
    return ListTile(
      title: buildTitle(),
      trailing: const Icon(
        Icons.arrow_forward,
        color: theme.GirafColors.black,
      ),
      onTap: () => _callback(),
    );
  }

  /// Builds the text with or without the optional trailing widget
  Widget buildTitle() {
    if (titleTrailing == null) {
      return Text(text);
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(text),
          titleTrailing,
        ],
      );
    }
  }
}
