import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weekplanner/blocs/new_weekplan_bloc.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/globals.dart';
import 'package:weekplanner/models/pictogram_model.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

class NewWeekplanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final NewWeekplanBloc _newWeekplanBloc = NewWeekplanBloc();
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildIcon(context, _newWeekplanBloc.gram),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: RaisedButton(
              child: Text(
                'Vælg Pictogram',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
              onPressed: () {
                Navigator.pushNamed(context, "/pictogram/search");
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
                // TODO do something.
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
                // TODO do something
              },
            ),
          ),
        ]));
  }
  Widget _buildIcon(BuildContext context, PictogramModel gram) {
    PictogramImageBloc bloc = PictogramImageBloc(Globals.api);

    bloc.load(gram);

    return StreamBuilder<Image>(
        stream: bloc.image,
        builder: (context, snapshot) {
          return Card(
              child: FittedBox(
                  fit: BoxFit.contain, child: snapshot.data));
        }
    );
  }
}