import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/enums/giraf_theme_enum.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

/// Shows all the users settings, and lets them change them
class SettingsScreen extends StatelessWidget {

  final SettingsBloc _settingsBloc = di.getDependency<SettingsBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GirafAppBar(
          title: 'Settings'
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded (
              child: _buildThemeSection(),
            ),
            Expanded (
              child: _buildOrientationSection(),
            ),
            Expanded (
              child: _buildUgeplanSection(),
            ),
          ]
      ),
    );
  }
  Widget _buildThemeSection(){
    return ListView(
        children:<Widget>[
          const Text('Tema'),
          StreamBuilder<GirafTheme>(
            stream: _settingsBloc.theme,
            initialData: GirafTheme.AndroidBlue,
            builder: (BuildContext context, AsyncSnapshot<GirafTheme> snapshot){
              return Text('Selected: ' + snapshot.data.toString());
            }
          ),
          StreamBuilder<List<GirafTheme>>(
            stream: _settingsBloc.themeList,
            initialData: const <GirafTheme>[],
            builder: (BuildContext context, AsyncSnapshot<List<GirafTheme>> snapshot){
              return ExpansionTile(
                key: const PageStorageKey<int>(3),
                title: const Text('Valg af Tema'),
                children: snapshot.data.map((GirafTheme element) {
                  return RaisedButton(
                    child: Text(element.toString()),
                    onPressed: (){
                      _settingsBloc.setTheme(element);
                    },
                  );
                }
                ).toList()
              );
            },
          ),

          ExpansionTile(
            key: const PageStorageKey<int>(3),
            title: const Text('Farver på ugeplan'),
            children: const <Widget>[
              Text('Tema 1'),
              Text('Tema 2')
            ],
          ),
          ExpansionTile(
            key: const PageStorageKey<int>(3),
            title: const Text('Tegn for udførelse'),
            children: const <Widget>[
              Text('Tema 1'),
              Text('Tema 2')
            ],
          ),
          ExpansionTile(
            key: const PageStorageKey<int>(3),
            title: const Text('Grå skala'),
            children: const <Widget>[
              Text('Tema 1'),
              Text('Tema 2')
            ],
          ),
        ]
    );
  }
  Widget _buildOrientationSection(){
    return ListView(
        children:<Widget>[
          const Text('Orientering'),
          ExpansionTile(
            key: const PageStorageKey<int>(3),
            title: const Text('Antal aktiviteter'),
            children: const <Widget>[
              Text('Tema 1'),
              Text('Tema 2')
            ],
          ),
        ]
    );
  }
  Widget _buildUgeplanSection(){
    return ListView(
        children:<Widget>[
          const Text('Ugeplan'),
          ExpansionTile(
            key: const PageStorageKey<int>(3),
            title: const Text('Antal aktiviteter'),
            children: <Widget>[
              RaisedButton(
                child: const Text('Tema 1'),
                onPressed: () {},
              ),
              RaisedButton(
                child: const Text('Tema 2'),
                onPressed: () {},
              ),
            ],
          ),
        ]
    );
  }

}
