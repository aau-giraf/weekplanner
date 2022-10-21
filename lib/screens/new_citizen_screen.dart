import 'package:api_client/models/giraf_user_model.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/new_citizen_bloc.dart';
import 'package:weekplanner/api/errorcode_translater.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';

enum Roles {guardian, trustee, citizen}

/// Screen for creating a new citizen
class NewCitizenScreen extends StatefulWidget {
  /// Constructor for the NewCitizenScreen()
  NewCitizenScreen() : _bloc = di.getDependency<NewCitizenBloc>() {
    _bloc.initialize();
  }

  final NewCitizenBloc _bloc;

  @override
  _NewCitizenScreenState createState() => _NewCitizenScreenState();
}

class _NewCitizenScreenState extends State<NewCitizenScreen> {
  final ApiErrorTranslater _translator = ApiErrorTranslater();
  Roles _role = Roles.citizen;

  void previousRoute(GirafUserModel response) {
    Routes.pop<GirafUserModel>(context, response);
    widget._bloc.resetBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GirafAppBar(
        title: 'Ny borger',
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 16, top: 6, right: 16, bottom: 2.5),
            child: StreamBuilder<bool>(
                stream: widget._bloc.validDisplayNameStream,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  return TextFormField(
                    key: const Key('displayNameField'),
                    decoration: InputDecoration(
                      border:
                          const OutlineInputBorder(borderSide: BorderSide()),
                      labelText: 'Navn',
                      errorText: (snapshot?.data == true) &&
                              widget._bloc.displayNameController.value != null
                          ? null
                          : 'Navn skal udfyldes',
                    ),
                    onChanged: widget._bloc.onDisplayNameChange.add,
                  );
                }),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 16, top: 6, right: 16, bottom: 2.5),
            child: StreamBuilder<bool>(
                stream: widget._bloc.validDisplayNameStream,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  return Column(
                    children: <Widget>[
                      Row(
                        children: <Widget> [
                          Expanded(
                            child: ListTile(
                              title: const Text('Guardian'),
                              leading: Radio<Roles> (
                                value: Roles.guardian,
                                groupValue: _role,
                                onChanged: (Roles value) {
                                  setState(() {
                                    _role = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: const Text('Trustee'),
                              leading: Radio<Roles> (
                                value: Roles.trustee,
                                groupValue: _role,
                                onChanged: (Roles value) {
                                  setState(() {
                                    _role = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: const Text('Citizen'),
                              leading: Radio<Roles> (
                                value: Roles.citizen,
                                groupValue: _role,
                                onChanged: (Roles value) {
                                  setState(() {
                                    _role = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
            child: StreamBuilder<bool>(
                stream: widget._bloc.validUsernameStream,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  return TextFormField(
                    key: const Key('usernameField'),
                    decoration: InputDecoration(
                      border:
                          const OutlineInputBorder(borderSide: BorderSide()),
                      labelText: 'Brugernavn',
                      errorText: (snapshot?.data == true) &&
                              widget._bloc.usernameController.value != null
                          ? null
                          // cant make it shorter because of the string
                          // ignore: lines_longer_than_80_chars
                          : 'Brugernavn er tomt eller indeholder et ugyldigt tegn',
                    ),
                    onChanged: widget._bloc.onUsernameChange.add,
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
            child: StreamBuilder<bool>(
                stream: widget._bloc.validPasswordStream,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  return TextFormField(
                    key: const Key('passwordField'),
                    decoration: InputDecoration(
                      border:
                          const OutlineInputBorder(borderSide: BorderSide()),
                      labelText: 'Kodeord',
                      errorText: (snapshot?.data == true) &&
                              widget._bloc.passwordController.value != null
                          ? null
                          // cant make it shorter because of the string
                          // ignore: lines_longer_than_80_chars
                          : 'Kodeord må ikke indeholde mellemrum eller være tom',
                    ),
                    onChanged: widget._bloc.onPasswordChange.add,
                    obscureText: true,
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
            child: StreamBuilder<bool>(
                stream: widget._bloc.validPasswordVerificationStream,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  return TextFormField(
                    key: const Key('passwordVerifyField'),
                    decoration: InputDecoration(
                      border:
                          const OutlineInputBorder(borderSide: BorderSide()),
                      labelText: 'Gentag kodeord',
                      errorText: (snapshot?.data == true)
                          ? null
                          : 'Kodeord skal være ens',
                    ),
                    onChanged: widget._bloc.onPasswordVerifyChange.add,
                    obscureText: true,
                  );
                }),
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
                  isEnabledStream: widget._bloc.allInputsAreValidStream,
                  onPressed: () {
                    switch(_role) {
                      case Roles.guardian:
                        widget._bloc.createGuardian()
                            .listen((GirafUserModel response) {
                          if (response != null) {
                            previousRoute(response);
                          }})
                            .onError((Object error) =>
                            _translator.catchApiError(error, context));
                        break;
                      case Roles.trustee:
                        widget._bloc.createTrustee()
                            .listen((GirafUserModel response) {
                          if (response != null) {
                            previousRoute(response);
                          }})
                            .onError((Object error) =>
                            _translator.catchApiError(error, context));
                        break;
                      case Roles.citizen:
                        widget._bloc.createCitizen()
                            .listen((GirafUserModel response) {
                          if (response != null) {
                            previousRoute(response);
                          }})
                            .onError((Object error) =>
                            _translator.catchApiError(error, context));
                        break;
                    }
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
