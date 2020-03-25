import 'package:api_client/models/enums/giraf_theme_enum.dart';
import 'package:api_client/models/username_model.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

/// Shows all the users settings, and lets them change them
class SettingsScreen extends StatelessWidget {
  /// Constructor
  SettingsScreen(UsernameModel user)
      : _settingsBloc = di.getDependency<SettingsBloc>(),
        _user = user;

  final SettingsBloc _settingsBloc;
  final UsernameModel _user;

  /// temporary solution to store the selected number of days to display
  static int daysDisplayed = 7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GirafAppBar(title: 'Indstillinger for ' + _user.name),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: _buildNumberOfDaysSection(),
            ),
            Expanded(
              child: _buildThemeSection(),
            )
          ]),
    );
  }

  Widget _buildNumberOfDaysSection() {
    return ListView(children: <Widget>[
      const Text('Ugeplan visning'),
      ExpansionTile(
        key: const PageStorageKey<int>(3),
        title: const Text('Vælg visning'),
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                child: const Text('Vis Man-Fre'),
                onPressed: () {
                  daysDisplayed = -1;
                },
              ),
              RaisedButton(
                child: const Text('Vis Man-Søn'),
                onPressed: () {
                  daysDisplayed = 0;
                },
              ),
              RaisedButton(
                child: const Text('Vis kun nuværende dag'),
                onPressed: () {
                  daysDisplayed = 1;
                },
              ),
              RaisedButton(
                child: const Text('Vis 2 dage frem'),
                onPressed: () {
                  daysDisplayed = 2;
                },
              ),
              RaisedButton(
                child: const Text('Vis 3 dage frem'),
                onPressed: () {
                  daysDisplayed = 3;
                },
              ),
              RaisedButton(
                child: const Text('Vis 4 dage frem'),
                onPressed: () {
                  daysDisplayed = 4;
                },
              ),
              RaisedButton(
                child: const Text('Vis 5 dage frem'),
                onPressed: () {
                  daysDisplayed = 5;
                },
              ),
              RaisedButton(
                child: const Text('Vis 6 dage frem'),
                onPressed: () {
                  daysDisplayed = 6;
                },
              ),
              RaisedButton(
                child: const Text('Vis 7 dage frem'),
                onPressed: () {
                  daysDisplayed = 7;
                },
              ),
            ],
          ),
        ],
      ),
    ]);
  }

  // Not used in the current version (from 2019)
  Widget _buildThemeSection() {
    return ListView(children: <Widget>[
      const Text('Tema'),
      StreamBuilder<GirafTheme>(
          stream: _settingsBloc.theme,
          initialData: GirafTheme.AndroidBlue,
          builder: (BuildContext context, AsyncSnapshot<GirafTheme> snapshot) {
            return Text('Selected: ' + snapshot.data.toString());
          }),
      StreamBuilder<List<GirafTheme>>(
        stream: _settingsBloc.themeList,
        initialData: const <GirafTheme>[],
        builder:
            (BuildContext context, AsyncSnapshot<List<GirafTheme>> snapshot) {
          return ExpansionTile(
              key: const PageStorageKey<int>(3),
              title: const Text('Valg af Tema'),
              children: snapshot.data.map((GirafTheme element) {
                return RaisedButton(
                  child: Text(element.toString()),
                  onPressed: () {
                    _settingsBloc.setTheme(element);
                  },
                );
              }).toList());
        },
      ),
      const ExpansionTile(
        key: PageStorageKey<int>(3),
        title: Text('Farver på ugeplan'),
        children: <Widget>[Text('Tema 1'), Text('Tema 2')],
      ),
      const ExpansionTile(
        key: PageStorageKey<int>(3),
        title: Text('Tegn for udførelse'),
        children: <Widget>[Text('Tema 1'), Text('Tema 2')],
      ),
      const ExpansionTile(
        key: PageStorageKey<int>(3),
        title: Text('Grå skala'),
        children: <Widget>[Text('Tema 1'), Text('Tema 2')],
      ),
    ]);
  }
}
