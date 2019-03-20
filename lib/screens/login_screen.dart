import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/blocs/environment_bloc.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/choose_citizen_screen.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final AuthBloc authBloc;
  final bool isDebugMode =
      di.getDependency<EnvoironmentBloc>().getVar<bool>("DEBUG");

  LoginScreen() : authBloc = di.getDependency<AuthBloc>();

  BuildContext loginContext = null;
  bool loggedInSuccessfull = false;

  void handleTimeout() {
    if (!loggedInSuccessfull) {
      Navigator.pop(loginContext);
      wrongUsernameOrPassword(loginContext);
    }
  }

  Future<bool> loginAction(BuildContext context) async {
    loginContext = context;
    showLoadingScreen(context, true, handleTimeout, 1500);
    authBloc.loggedIn.listen((status) async {
      if (status) {
        Routes.pop(context);
        loggedInSuccessfull = true;
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

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    bool Portrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool Keyboard = MediaQuery.of(context).viewInsets.bottom > 100;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        padding: Portrait
            ? EdgeInsets.fromLTRB(50, 0, 50, 0)
            : EdgeInsets.fromLTRB(200, 0, 200, 8),
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
                          : EdgeInsets.fromLTRB(0, 0, 0, 5),
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
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
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
                              loginAction(context);
                            },
                            color: Color.fromRGBO(48, 81, 118, 1),
                          ),
                        ),
                      ),
                    ),
                    // Autologin button, only used for debugging
                    isDebugMode
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
                                  usernameCtrl.text = di
                                      .getDependency<EnvoironmentBloc>()
                                      .getVar<String>("USERNAME");
                                  passwordCtrl.text = di
                                      .getDependency<EnvoironmentBloc>()
                                      .getVar<String>("PASSWORD");
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

  static void showLoadingScreen(BuildContext context, bool Dismissible,
      [void callback(), int timeoutMS]) {
    if (callback != null) {
      if (timeoutMS == null) {
        timeoutMS = 2000;
      }
      Timer(Duration(milliseconds: timeoutMS), callback);
    }
    showDialog(
        barrierDismissible: Dismissible,
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Transform.scale(
                scale: 2,
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Color.fromRGBO(255, 157, 0, 0.8)),
                )),
          );
        });
  }
}
