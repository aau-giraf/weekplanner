import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section_item.dart';
import '../../style/custom_color.dart' as theme;

/// SettingSection class
class SettingsSection extends StatelessWidget {
  /// Constructor
  const SettingsSection(this.title, this.children);

  /// This is the Settings Sections name
  final String title;

  /// This is the elements in the Settings section
  final List<SettingsSectionItem> children;

  @override
  Column build(BuildContext context) {

    // Adding dividers
    for (int i = 0; i < children.length; i += 2) {
      children.insert(i, const SettingsDivider());
    }
    children.add(const SettingsDivider());

    final Container _titleContainer = Container(
      width: double.infinity,
      color: theme.GirafColors.lightGrey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Column(
      children: <Widget>[_titleContainer] + children,
    );
  }
}

/// Created to be able to add Divider in List<SettingsSectionItem>
class SettingsDivider extends SettingsSectionItem {
  /// Constructor
  const SettingsDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 0,
      color: theme.GirafColors.grey,
    );
  }
}
