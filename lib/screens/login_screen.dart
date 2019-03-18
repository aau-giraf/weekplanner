import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/globals.dart';
import 'package:weekplanner/widgets/bloc_provider_tree_widget.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  final timeout = const Duration(seconds: 2);
  final ms = const Duration(milliseconds: 1);

  BuildContext loginContext = null;
  bool LoggedInSuccessfull = false;

  void handleTimeout() {
    if (!LoggedInSuccessfull) {
      Navigator.pop(loginContext);
      wrongUsernameOrPassword(loginContext);
    }
  }

  Future<bool> loginAction(BuildContext context, String nextScreen) async {
    loginContext = context;
    Globals.showLoadingScreen(context, true, handleTimeout, 1500);

    authBloc.loggedIn.listen((status) {
      if (status) {
        LoggedInSuccessfull = true;
        Navigator.pop(context);
        Navigator.pushNamed(context, "/weekplan");
      }
    });
    authBloc.authenticate(usernameCtrl.value.text, passwordCtrl.value.text);
    return true;
  }

  void wrongUsernameOrPassword(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //TODO: Lav en pæn dialog
          return Center(
            child: Text("Forkert brugernavn eller adgangskode"),
          );
        });
  }

  AuthBloc authBloc;

  @override
  Widget build(BuildContext context) {
    authBloc = BlocProviderTree.of<AuthBloc>(context);
    Key ScaffoldKey = Key("scaffoldKe");
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
        key: ScaffoldKey,
        body: Container(
          width: screenSize.width,
          height: screenSize.height,
          padding: new EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/login_screen_background_image.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                Image(image: AssetImage("assets/giraf_splash_logo.png")),
                Expanded(
                    child: Form(
                  key: this._formKey,
                  child: ListView(
                    children: <Widget>[
                      TextField(
                        controller: usernameCtrl,
                        keyboardType: TextInputType.text,
                        // Use email input type for emails.
                        decoration: InputDecoration(
                          hintText: '',
                          labelText: 'Brugernavn',
                          fillColor: Colors.white,
                        ),
                      ),
                      TextField(
                        controller: passwordCtrl,
                        obscureText: true,
                        // Use email input type for emails.
                        decoration: InputDecoration(
                          hintText: '',
                          labelText: 'Adgangskode',
                          fillColor: Colors.white,
                        ),
                      ),
                      Container(
                        child: new RaisedButton(
                          child: new Text(
                            'Login',
                            style: new TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            await loginAction(context, "/weekplan");
                          },
                          color: Colors.blue,
                        ),
                      ),
                      Container(
                        child: new RaisedButton(
                          child: new Text(
                            'Auto-Login',
                            style: new TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            await loginAction(context, "/weekplan");
                          },
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ))
              ])),
        ));
  }
}
