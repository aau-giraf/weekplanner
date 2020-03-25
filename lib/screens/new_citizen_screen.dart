import 'package:api_client/models/giraf_user_model.dart';
import 'package:api_client/models/username_model.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/new_citizen_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';

/// Screen for creating a new citizen
class NewCitizenScreen extends StatelessWidget {
  /// Screen for creating a new weekplan.
  /// Requires a [UsernameModel] to be able to save the new weekplan.
  NewCitizenScreen()
      : _bloc = di.getDependency<NewCitizenBloc>() {
    _bloc.initialize();
  }

  final NewCitizenBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GirafAppBar(title: 'Ny borger',),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                left: 16,
                top: 6,
                right: 16,
                bottom: 2.5
            ),
            child: TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide()),
                  hintText: 'Navn'
              ),
              onChanged: _bloc.onDisplayNameChange.add,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
            child: TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide()),
                  hintText: 'Brugernavn'
              ),
              onChanged: _bloc.onUsernameChange.add,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
            child: TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide()),
                  hintText: 'Adgangskode'
              ),
              onChanged: _bloc.onPasswordChange.add,
              obscureText: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
            child: TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide()),
                  hintText: 'Gentag adgangskode'
              ),
              onChanged: _bloc.onPasswordVerifyChange.add,
              obscureText: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.person,
                  size: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GirafButton(
                      icon: const ImageIcon(AssetImage('assets/icons/camera.png')),
                      text: 'Tilføj fra kamera',
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: GirafButton(
                  icon: const ImageIcon(AssetImage('assets/icons/save.png')),
                  text: 'Gem borger',
                  isEnabled: false,
                  isEnabledStream: _bloc.allInputsAreValidStream,
                  onPressed: () {
                    _bloc.createCitizen().listen((GirafUserModel response) {
                      if (response != null) {
                        Routes.pop<GirafUserModel>(context, response);
                        _bloc.resetBloc();
                      }
                    });
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}


