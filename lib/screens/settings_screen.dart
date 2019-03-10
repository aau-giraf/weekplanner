import 'package:flutter/material.dart';
import '../widgets/giraf_app_bar_widget.dart';

class SettingsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: GirafAppBarWidget(
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
          new ExpansionTile(
            key: PageStorageKey(3),
            title: Text("Valg af Tema"),
            children: <Widget>[
              Text("Tema 1"),
              Text("Tema 2")
            ],
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
