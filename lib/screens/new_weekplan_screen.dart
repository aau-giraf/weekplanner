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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GirafAppBar(title: 'Ny Ugeplan'),
        body: Form(
            child: ListView(children: <Widget>[
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextFormField(
                onFieldSubmitted: (String text) => _bloc.onTitleSubmitted(text),
                decoration: InputDecoration(
                    labelText: 'Titel',
                    border: OutlineInputBorder(borderSide: BorderSide())),
              )),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextFormField(
                keyboardType: TextInputType.number,
                onFieldSubmitted: (String text) => _bloc.onYearSubmitted(text),
                initialValue: DateTime.now().year.toString(),
                decoration: InputDecoration(
                    labelText: 'År',
                    border: OutlineInputBorder(borderSide: BorderSide())),
              )),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextFormField(
                keyboardType: TextInputType.number,
                onFieldSubmitted: (String text) =>
                    _bloc.onWeekNumberSubmitted(text),
                decoration: InputDecoration(
                    labelText: 'Ugenummer',
                    border: OutlineInputBorder(borderSide: BorderSide())),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildThumbnail(context, _bloc.gram),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: RaisedButton(
              child: Text(
                'Vælg Pictogram',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
              onPressed: () => {
                    Routes.push<PictogramModel>(context, PictogramSearch())
                        .then((PictogramModel val) => {_bloc.gram = val}),
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
        ])));
  }

  Widget _buildThumbnail(BuildContext context, PictogramModel gram) {
    if (gram == null) {
      return Card(
        child: ConstrainedBox(
            constraints: const BoxConstraints.expand(height: 200.0),
            child: const Icon(Icons.image)),
      );
    } else {
      return PictogramImage(pictogram: gram, onPressed: null);
    }
  }
}
