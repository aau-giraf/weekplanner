import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:api_client/models/enums/giraf_theme_enum.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

/// Shows all the users settings, and lets them change them
class SettingsScreen extends StatelessWidget {
  final SettingsBloc _settingsBloc = di.getDependency<SettingsBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GirafAppBar(title: 'Settings'),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _buildAllSettings(),
          )
        ],
      )
    );
  }

  Widget _buildAllSettings() {
    return ListView(
      children: <Widget>[
        Column(
          children: <Widget>[
            ListTile(
              title: Text('Hejsa'),
            ),
            CheckboxListTile(
              value: true,
              title: Text("This is a CheckBoxPreference"),
              onChanged: (value) {},
            ),
          ],
        ),
        Column(
          children: <Widget>[
            ListTile(
              title: Text('Hejsa2'),
            )
          ],
        )
      ],
    );
  }

  Widget _buildThemeSection() {
    return ListView(
      children: <Widget>[
        ListTile(
          title: const Text('Vælg tema'),
        )
      ],
    );
  }

  Widget _buildOrientationSection() {
    return ListView(
      children: <Widget>[
        ListTile(
          title: const Text('Vælg tema'),
        )
      ],
    );
  }

  Widget _buildSelectWeekdaysSection() {
    return const ListTile(
      title: Text('Vælg antal dage i ugeplan'),
    );
  }

}
