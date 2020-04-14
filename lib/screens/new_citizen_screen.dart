import 'package:api_client/models/giraf_user_model.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/new_citizen_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';

/// Screen for creating a new citizen
class NewCitizenScreen extends StatelessWidget {

  /// Constructor for the NewCitizenScreen()
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
            child: StreamBuilder<bool>(
              stream: _bloc.validDisplayNameStream,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return TextFormField(
                  key: const Key('displayNameField'),
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(borderSide:
                      BorderSide()),
                      labelText: 'Navn',
                      errorText: (snapshot?.data == false) ?
                      'Navn skal udfyldes' : null,
                  ),
                  onChanged: _bloc.onDisplayNameChange.add,
                );
              }
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
            child: StreamBuilder<bool>(
              stream: _bloc.validUsernameStream,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return TextFormField(
                  key: const Key('usernameField'),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(borderSide: BorderSide()),
                    labelText: 'Brugernavn',
                    errorText: (snapshot?.data == false) ?
                    'Brugernavn må ikke indeholde mellemrum eller være tom'
                        : null,
                  ),
                  onChanged: _bloc.onUsernameChange.add,
                );
              }
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
            child: StreamBuilder<bool>(
              stream: _bloc.validPasswordStream,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return TextFormField(
                  key: const Key('passwordField'),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(borderSide: BorderSide()),
                    labelText: 'Kodeord',
                    errorText: (snapshot?.data == false) ?
                    'Kodeord må ikke indeholde mellemrum eller være tom' : null,
                  ),
                  onChanged: _bloc.onPasswordChange.add,
                  obscureText: true,
                );
              }
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
            child: StreamBuilder<bool>(
              stream: _bloc.validPasswordVerificationStream,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return TextFormField(
                  key: const Key('passwordVerifyField'),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(borderSide: BorderSide()),
                    labelText: 'Gentag kodeord',
                    errorText: (snapshot?.data == false) ?
                    'Kodeord må ikke indeholde mellemrum eller være tom' : null,
                  ),
                  onChanged: _bloc.onPasswordVerifyChange.add,
                  obscureText: true,
                );
              }
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: GirafButton(
                  key: const Key('saveButton'),
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


