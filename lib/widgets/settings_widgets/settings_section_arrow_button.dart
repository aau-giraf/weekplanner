import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section_item.dart';
import '../../style/custom_color.dart' as theme;

/// SettingSection ArrowButton class
class SettingsArrowButton extends SettingsSectionItem {
  /// Constructor
  const SettingsArrowButton(this.text, this.callback, {this.trailing});

  /// Text on button
  final String text;

  /// Function to run on tap
  final VoidCallback callback;

  /// This is extra trailing to be added before the arrow
  final Widget trailing;

  @override
  ListTile build(BuildContext context) {
    return ListTile(
      title: buildTitle(),
      trailing: Icon(
        Icons.arrow_forward,
        color: theme.GirafColors.black,
      ),
      onTap: () => callback(),
    );
  }

  /// Builds the text with or without color boxes
  Widget buildTitle(){
    if(trailing == null){
      return Text(text);
    } else{
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(text),
          trailing,
        ],
      );
    }
  }
}
