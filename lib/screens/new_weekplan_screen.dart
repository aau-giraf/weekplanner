import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

class NewWeekplanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: GirafAppBar(title: "Ny Ugeplan"),
        body: ListView(children: <Widget>[
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextField(
                decoration: InputDecoration(
                    labelText: "Titel",
                    border: OutlineInputBorder(borderSide: BorderSide())),
              )),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextFormField(
                initialValue: DateTime.now().year.toString(),
                decoration: InputDecoration(
                    labelText: "År",
                    border: OutlineInputBorder(borderSide: BorderSide())),
              )),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextField(
                decoration: InputDecoration(
                    labelText: "Ugenummer",
                    border: OutlineInputBorder(borderSide: BorderSide())),
              )),
          /*Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            //child: StreamBuilder<PictogramModel>(
          )),*/
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: RaisedButton(
              child: Text(
                'Vælg Pictogram',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
              onPressed: () {
                Navigator.pushNamed(context, "/select_weekplan/new_weekplan");
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: RaisedButton(
              child: Text(
                'Vælg Skabelon',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
              onPressed: () {
                Navigator.pushNamed(context, "/select_weekplan/new_weekplan");
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: RaisedButton(
              child: Text(
                'Gem Ugeplan',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
              onPressed: () {
                Navigator.pushNamed(context, "/select_weekplan/new_weekplan");
              },
            ),
          ),
        ]));
  }
}
