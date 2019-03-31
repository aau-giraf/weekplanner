import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/new_weekplan_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/pictogram_model.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/pictogram_search_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/pictogram_image.dart';

/// Screen for creating a new weekplan
class NewWeekplanScreen extends StatelessWidget {
  final NewWeekplanBloc _bloc = di.getDependency<NewWeekplanBloc>();
  Future<PictogramImage> _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GirafAppBar(title: 'Ny Ugeplan'),
        body: ListView(children: <Widget>[
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextFormField(
                onFieldSubmitted: (String text) =>
                    _bloc.onTitleChanged(text),
                decoration: InputDecoration(
                    labelText: 'Titel',
                    border: OutlineInputBorder(borderSide: BorderSide())),
              )),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextFormField(
                onFieldSubmitted: (String text) =>
                    _bloc.onYearChanged(text),
                initialValue: DateTime.now().year.toString(),
                decoration: InputDecoration(
                    labelText: 'År',
                    border: OutlineInputBorder(borderSide: BorderSide())),
              )),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextFormField(
                onFieldSubmitted: (String text) =>
                    _bloc.onWeekNumberChanged(text),
                decoration: InputDecoration(
                    labelText: 'Ugenummer',
                    border: OutlineInputBorder(borderSide: BorderSide())),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            // child: ,
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
                _image = Routes.push<PictogramImage>(context, PictogramSearch());
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
                _bloc.save();
              },
            ),
          ),
        ]));
  }

  // Widget _buildIcon(BuildContext context, PictogramModel gram) {
  //   final PictogramImageBloc _bloc = PictogramImageBloc(Globals.api);

  //   _bloc.load(gram);

  //   return StreamBuilder<Image>(
  //       stream: _bloc.image,
  //       builder: (context, snapshot) {
  //         return Card(
  //             child: FittedBox(fit: BoxFit.contain, child: snapshot.data));
  //       });
  // }
}
