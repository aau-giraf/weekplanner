import 'package:api_client/models/username_model.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/style/custom_color.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

import 'number_of_days_selection_screen.dart';

/// Shows all the users settings, and lets them change them
class SettingsScreen extends StatelessWidget {
  /// Constructor
  const SettingsScreen(UsernameModel user) : _user = user;

  final UsernameModel _user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GirafAppBar(title: _user.name + ': Indstillinger'),
        body: Column(
          children: <Widget>[
            Expanded(
              child: _buildAllSettings(context),
            )
          ],
        ));
  }

  Widget _buildAllSettings(BuildContext context) {
    return ListView(
      children: <Widget>[
        _buildThemeSection(),
        _buildOrientationSection(),
        _buildWeekPlanSection(context),
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
      _buttonDivider(),
      SizedBox(
          width: double.infinity, child: _button(() {}, 'Farver på ugeplan')),
      _buttonDivider(),
      SizedBox(
        width: double.infinity,
        child: _button(() {}, 'Tegn for udførelse'),
      ),
      _buttonDivider()
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
        _buttonDivider(),
        Container(
          child: CheckboxListTile(
            value: true,
            title: const Text('Landskab'),
            onChanged: (bool value) {},
          ),
        ),
        _buttonDivider(),
      ],
    );
  }

  Widget _buildWeekPlanSection(BuildContext context) {
    return Column(
      children: <Widget>[
        const ListTile(
          title: Text('Ugeplan',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              )),
        ),
        _buttonDivider(),
        SizedBox(
          width: double.infinity,
          child: _button(() {
            Routes.push(context, NumberOfDaysScreen(_user));
          }, 'Antal dage'),
        ),
        _buttonDivider()
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
        _buttonDivider(),
        SizedBox(
          width: double.infinity,
          child: _button(() {}, _user.name + ' indstillinger'),
        ),
        _buttonDivider(),
      ],
    );
  }

  OutlineButton _button(VoidCallback onPressed, String text) {
    return OutlineButton(
      padding: const EdgeInsets.all(15),
      onPressed: () => onPressed(),
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
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.normal),
              ))
        ],
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      highlightedBorderColor: GirafColors.appBarOrange,
      borderSide: BorderSide(
        color: Colors.transparent
      )
    );
  }

  Divider _buttonDivider() {
    return const Divider(
      color: Colors.grey,
    );
  }

}
