import 'package:api_client/models/username_model.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/style/custom_color.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

/// Shows all the users settings, and lets them change them
class SettingsScreen extends StatelessWidget {
  /// Constructor
  const SettingsScreen(UsernameModel user) : _user = user;

  final UsernameModel _user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GirafAppBar(title: 'Indstillinger'),
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
        _buildWeekPlanSection(),
        _buildUserSettings()
      ],
    );
  }

  Widget _buildThemeSection() {
    return Column(children: <Widget>[
      _sectionLabel('Tema'),
      _arrowButton(() { }, 'Farver på ugeplan'),
      _arrowButton(() { }, 'Tegn for udførelse'),
    ]);
  }

  Widget _buildOrientationSection() {
    return Column(
      children: <Widget>[
        _sectionLabel('Orientering'),
        _checkboxButton((bool b) { return; }, 'Landskab'),
      ],
    );
  }

  Widget _buildWeekPlanSection() {
    return Column(
      children: <Widget>[
        _sectionLabel('Ugeplan'),
        _arrowButton(() { }, 'Antal dage'),
      ],
    );
  }

  Widget _buildUserSettings() {
    return Column(
      children: <Widget>[
        _sectionLabel('Brugerindstillinger'),
        _arrowButton(() {}, _user.name + 's indstillinger')
      ],
    );
  }

  Widget _sectionLabel(String text) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _divider()
      ],
    );
  }

  Widget _arrowButton(VoidCallback onPressed, String text) {
    return Column(
      children: <Widget>[
        SizedBox(
            width: double.infinity,
            child: OutlineButton(
                padding: const EdgeInsets.all(15),
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
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                        )),
                  ],
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0)),
                highlightedBorderColor: GirafColors.appBarOrange,
                borderSide: BorderSide(color: Colors.transparent))
        ),
        _divider()
      ],
    );
  }

  Widget _checkboxButton(VoidCallback onChange(bool b), String label) {
    return Column(children: <Widget>[
      CheckboxListTile(
        value: true,
        title: const Text('Landskab'),
        onChanged: onChange,
      ),
      _divider()
    ]);
  }

  Divider _divider() {
    return const Divider(
      color: Colors.grey,
    );
  }
}
