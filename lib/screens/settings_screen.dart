import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/widgets/bloc_provider_tree_widget.dart';
import 'package:weekplanner/providers/bloc_provider.dart';
import '../widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/models/enums/giraf_theme_enum.dart';

class SettingsScreen extends StatelessWidget {

  SettingsBloc settingsBloc;

  @override
  Widget build(BuildContext context) {
    settingsBloc = BlocProviderTree.of<SettingsBloc>(context);
    return new Scaffold(
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
          Text("Tema"),
          StreamBuilder<GirafTheme>(
            stream: settingsBloc.theme,
            initialData: GirafTheme.AndroidBlue,
            builder: (BuildContext context, AsyncSnapshot<GirafTheme> snapshot){
              return new Text("Selected: " + snapshot.data.toString());
            }
          ),
          StreamBuilder<List<GirafTheme>>(
            stream: settingsBloc.themeList,
            initialData: [],
            builder: (BuildContext context, AsyncSnapshot<List<GirafTheme>> snapshot){
              return new ExpansionTile(
                key: PageStorageKey(3),
                title: Text("Valg af Tema"),
                children: snapshot.data.map((element) {
                  return RaisedButton(
                    child: Text(element.toString()),
                    onPressed: (){
                      settingsBloc.setTheme(element);
                    },
                  );
                }
                ).toList()
              );
            },
          ),

          new ExpansionTile(
            key: PageStorageKey(3),
            title: Text("Farver på ugeplan"),
            children: <Widget>[
              Text("Tema 1"),
              Text("Tema 2")
            ],
          ),
          new ExpansionTile(
            key: PageStorageKey(3),
            title: Text("Tegn for udførelse"),
            children: <Widget>[
              Text("Tema 1"),
              Text("Tema 2")
            ],
          ),
          new ExpansionTile(
            key: PageStorageKey(3),
            title: Text("Grå skala"),
            children: <Widget>[
              Text("Tema 1"),
              Text("Tema 2")
            ],
          ),
        ]
    );
  }
  Widget _buildOrientationSection(){
    return ListView(
        children:<Widget>[
          Text("Orientering"),
          new ExpansionTile(
            key: PageStorageKey(3),
            title: Text("Antal aktiviteter"),
            children: <Widget>[
              Text("Tema 1"),
              Text("Tema 2")
            ],
          ),
        ]
    );
  }
  Widget _buildUgeplanSection(){
    return ListView(
        children:<Widget>[
          Text("Ugeplan"),
          new ExpansionTile(
            key: PageStorageKey(3),
            title: Text("Antal aktiviteter"),
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
