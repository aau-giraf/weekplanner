import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/new_weekplan_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/giraf_user_model.dart';
import 'package:weekplanner/models/pictogram_model.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/pictogram_search_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/pictogram_image.dart';

/// Screen for creating a new weekplan
class NewWeekplanScreen extends StatelessWidget {
  /// Screen for creating a new weekplan
  /// Requires a GirafUserModel to save the new weekplan
  NewWeekplanScreen(GirafUserModel user)
      : _bloc = di.getDependency<NewWeekplanBloc>() {
    _bloc.load(user);
  }

  final NewWeekplanBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GirafAppBar(title: 'Ny Ugeplan'),
        body: ListView(children: <Widget>[
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextField(
                onChanged: (String text) => {
                      _bloc.onTitleChanged(text),
                    },
                decoration: InputDecoration(
                    labelText: 'Titel',
                    border: OutlineInputBorder(borderSide: BorderSide())),
              )),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (String text) => {
                      _bloc.onYearChanged(text),
                    },
                decoration: InputDecoration(
                    labelText: 'År',
                    border: OutlineInputBorder(borderSide: BorderSide())),
              )),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (String text) => {_bloc.onWeekNumberChanged(text)},
                decoration: InputDecoration(
                    labelText: 'Ugenummer',
                    border: OutlineInputBorder(borderSide: BorderSide())),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildThumbnail(context, _bloc.pictogram),
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
                        .then((PictogramModel val) => {_bloc.pictogram = val}),
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
                // TODO(anon): Handle when a weekplan is made from a template
              },
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: StreamBuilder<bool>(
                stream: _bloc.validInputStream,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) =>
                    _buildButton(context, snapshot),
              )

              // RaisedButton(
              //   child: Text(
              //     'Gem Ugeplan',
              //     style: TextStyle(color: Colors.white),
              //   ),
              //   color: Colors.blue,
              //   onPressed: () {
              //     _bloc.save();
              //   },
              // ),
              ),
        ]));
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

  Widget _buildButton(BuildContext context, AsyncSnapshot<bool> snapshot) {
    if (snapshot.data == true) {
      return const Text('True');
    } else {
      return const Text('False');
    }
  }
}
