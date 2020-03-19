import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/new_citizen_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/input_fields_weekplan.dart';

/// Screen for creating a new citizen
class NewCitizenScreen extends StatelessWidget {
  /// Screen for creating a new weekplan.
  /// Requires a [UsernameModel] to be able to save the new weekplan.
  NewCitizenScreen()
      : _bloc = di.getDependency<NewCitizenBloc>() {
    //_bloc.initialize(user);
  }

  final NewCitizenBloc _bloc;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: GirafAppBar(title: 'Ny borger',),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: TextFormField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter Search Term'
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.person,
                  size: 100,
                ),
                GirafButton(
                  icon: const ImageIcon(AssetImage('assets/icons/camera.png')),
                  text: 'Tilføj fra kamera',
                  onPressed: () {},
                )
              ],
            ),
          ),
          GirafButton(
            //TODO Fix width
            icon: const ImageIcon(AssetImage('assets/icons/save.png')),
            text: 'Gem borger',
            onPressed: () {_bloc.createCitizen("Jonas", "jonas", "password");},
          )
        ],
      ),
    );
  }
}


