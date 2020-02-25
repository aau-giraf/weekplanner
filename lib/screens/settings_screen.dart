import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:api_client/models/enums/giraf_theme_enum.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

/// Shows all the users settings, and lets them change them
class SettingsScreen extends StatelessWidget {
  final SettingsBloc _settingsBloc = di.getDependency<SettingsBloc>();
  static int days_displayed = 7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GirafAppBar(title: 'Indstillinger'),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: _buildViewSection(),
            ),
          ]),
    );
  }


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
      ExpansionTile(
        key: const PageStorageKey<int>(3),
        title: const Text('Farver på ugeplan'),
        children: const <Widget>[Text('Tema 1'), Text('Tema 2')],
      ),
      ExpansionTile(
        key: const PageStorageKey<int>(3),
        title: const Text('Tegn for udførelse'),
        children: const <Widget>[Text('Tema 1'), Text('Tema 2')],
      ),
      ExpansionTile(
        key: const PageStorageKey<int>(3),
        title: const Text('Grå skala'),
        children: const <Widget>[Text('Tema 1'), Text('Tema 2')],
      ),
    ]);
  }


  Widget _buildViewSection() {
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
                child: Text('Vis Man-Fre'),
                onPressed: () { days_displayed = 1; },
              ),
              RaisedButton(
                child: Text('Vis Man-Søn'),
                onPressed: () { days_displayed = 2; },
              ),
              RaisedButton(
                child: Text('Vis kun nuværende dag'),
                onPressed: () { days_displayed = 3; },
              ),
              RaisedButton(
                child: Text('Vis 2 dage frem'),
                onPressed: () { days_displayed = 4; },
              ),
              RaisedButton(
                child: Text('Vis 3 dage frem'),
                onPressed: () { days_displayed = 5; },
              ),
              RaisedButton(
                child: Text('Vis 4 dage frem'),
                onPressed: () { days_displayed = 6; },
              ),
              RaisedButton(
                child: Text('Vis 5 dage frem'),
                onPressed: () { days_displayed = 7; },
              ),
              RaisedButton(
                child: Text('Vis 6 dage frem'),
                onPressed: () { days_displayed = 7; },
              ),
              RaisedButton(
                child: Text('Vis 7 dage frem'),
                onPressed: () { days_displayed = 7; },
              ),
            ],
          ),
        ],
      ),
    ]);
  }
}
