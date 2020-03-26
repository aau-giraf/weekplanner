import 'package:api_client/models/username_model.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/style/custom_color.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

/// Shows all the users settings, and lets them change them
class SettingsScreen extends StatelessWidget {
  /// Constructor
  SettingsScreen(UsernameModel user)
      : _settingsBloc = di.getDependency<SettingsBloc>(),
        _user = user;

  final SettingsBloc _settingsBloc;
  final UsernameModel _user;

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
        ));
  }

  Widget _buildAllSettings() {
    return ListView(
      children: <Widget>[
        _buildThemeSection(),
        _buildOrientationSection(),
        _buildWeekplanSection(),
        _buildUserSettings()
      ],
    );
  }

  Widget _buildThemeSection() {
    return Column(children: <Widget>[
      const ListTile(
        title: Text('Tema',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            )),
      ),
      SizedBox(
          width: double.infinity, child: _button(() {}, 'Farver på ugeplan')),
      SizedBox(
        width: double.infinity,
        child: _button(() {}, 'Tegn for udførelse'),
      )
    ]);
  }

  Widget _buildOrientationSection() {
    return Column(
      children: <Widget>[
        const ListTile(
          title: Text('Orientering',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              )),
        ),
        Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.grey[350])),
          child: CheckboxListTile(
            value: true,
            title: const Text('Landskab'),
            onChanged: (value) {},
          ),
        )
      ],
    );
  }

  Widget _buildWeekplanSection() {
    return Column(
      children: <Widget>[
        const ListTile(
          title: Text('Ugeplan',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              )),
        ),
        SizedBox(
          width: double.infinity,
          child: _button(() {}, 'Antal dage'),
        )
      ],
    );
  }

  Widget _buildUserSettings() {
    return Column(
      children: <Widget>[
        const ListTile(
          title: Text('Brugerindstillinger',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              )),
        ),
        SizedBox(
          width: double.infinity,
          child: _button(() {}, _user.name + 's indstillinger'),
        )
      ],
    );
  }

  OutlineButton _button(VoidCallback onPressed, String text) {
    return OutlineButton(
      padding: EdgeInsets.all(15),
      onPressed: () => onPressed,
      child: Stack(
        children: <Widget>[
          Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.arrow_forward)),
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                text,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ))
        ],
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      highlightedBorderColor: GirafColors.appBarOrange,
    );
  }
}
