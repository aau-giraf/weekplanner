import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/globals.dart';
import 'package:weekplanner/widgets/bloc_provider_tree_widget.dart';
import 'package:weekplanner/widgets/giraf_notify_dialog.dart';

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
        Navigator.pushNamed(context, "/choosecitizen");
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
          return GirafNotifyDialog(
            title: "Fejl",
            description: "Forkert brugernavn eller adgangskode",
          );
        });
  }

  AuthBloc authBloc;

  @override
  Widget build(BuildContext context) {
    authBloc = BlocProviderTree.of<AuthBloc>(context);
    final Size screenSize = MediaQuery.of(context).size;
    bool Portrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool Keyboard = MediaQuery.of(context).viewInsets.bottom > 100;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        // Padding here is dependend on Portrait/Landscape and if the keyboard is active
        padding: Portrait
            ? EdgeInsets.fromLTRB(50, 0, 50, 0)
            : Keyboard
                ? EdgeInsets.fromLTRB(200, 0, 200, 20)
                : EdgeInsets.fromLTRB(200, 20, 200, 10),
        decoration: BoxDecoration(
          // The background of the login-screen
          image: DecorationImage(
            image: AssetImage("assets/login_screen_background_image.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GetLogo(Keyboard, Portrait),
              Form(
                key: this._formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: Portrait
                          ? EdgeInsets.fromLTRB(0, 20, 0, 10)
                          : EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Container(
                        decoration: new BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius:
                                new BorderRadius.all(new Radius.circular(20.0)),
                            color: Colors.white),
                        padding: new EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                        child: TextField(
                          style: Portrait
                              ? TextStyle(fontSize: 30)
                              : TextStyle(fontSize: 20),
                          controller: usernameCtrl,
                          keyboardType: TextInputType.text,
                          // Use email input type for emails.
                          decoration: InputDecoration.collapsed(
                            hintText: "Brugernavn",
                            hintStyle: TextStyle(
                                color: Color.fromRGBO(170, 170, 170, 1)),
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Container(
                        decoration: new BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius:
                                new BorderRadius.all(new Radius.circular(20.0)),
                            color: Colors.white),
                        padding: new EdgeInsets.all(8.0),
                        child: TextField(
                          onSubmitted: (newValue) {
                            loginAction(context, "/choosecitizen");
                          },
                          style: Portrait
                              ? TextStyle(fontSize: 30)
                              : TextStyle(fontSize: 20),
                          controller: passwordCtrl,
                          obscureText: true,
                          decoration: InputDecoration.collapsed(
                            hintText: 'Adgangskode',
                            hintStyle: TextStyle(
                                color: Color.fromRGBO(170, 170, 170, 1)),
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                      child: Container(
                        child: Transform.scale(
                          scale: 1.5,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0)),
                            child: Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              loginAction(context, "/choosecitizen");
                            },
                            color: Color.fromRGBO(48, 81, 118, 1),
                          ),
                        ),
                      ),
                    ),
                    // Autologin button, only used for debugging
                    Globals.isInDebugMode
                        ? Container(
                            child: Transform.scale(
                              scale: 1.2,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Text(
                                  'Auto-Login',
                                  style: new TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  usernameCtrl.text = "Graatand";
                                  passwordCtrl.text = "password";
                                },
                                color: Color.fromRGBO(48, 81, 118, 1),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              )
            ]),
      ),
    );
  }

  Widget GetLogo(bool Keyboard, bool Portrait) {
    if (Keyboard) {
      return Container();
    }

    return Transform.scale(
      scale: Portrait ? 1.0 : 0.5,
      child: Image(
        image: AssetImage("assets/giraf_splash_logo.png"),
      ),
    );
  }
}
