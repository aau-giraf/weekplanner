import 'dart:async';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/providers/environment_provider.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/choose_citizen_screen.dart';
import 'package:weekplanner/widgets/giraf_notify_dialog.dart';

/// Logs the user in
class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final AuthBloc authBloc;
  final bool isDebugMode = Environment.getVar<bool>("DEBUG");

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
    showLoadingScreen(context, false, handleTimeout, 1500);
    authBloc.loggedIn.listen((status) async {
      if (status) {
        Routes.pop(context);
        loggedInSuccessfull = true;
        await Routes.push(context, ChooseCitizenScreen());
      }
    });
    authBloc.authenticate(usernameCtrl.value.text, passwordCtrl.value.text);
    return true;
  }

  void wrongUsernameOrPassword(BuildContext context) {
    showDialog<GirafNotifyDialog>(
        builder: (BuildContext context) {
          //TODO: Lav en pæn dialog
          return GirafNotifyDialog(
            title: "Fejl",
            description: "Forkert brugernavn eller adgangskode",
          );
        },
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    bool portrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool keyboard = MediaQuery.of(context).viewInsets.bottom > 100;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        padding: portrait
            ? EdgeInsets.fromLTRB(50, 0, 50, 0)
            : EdgeInsets.fromLTRB(200, 0, 200, 8),
        decoration: BoxDecoration(
          // The background of the login-screen
          image: const DecorationImage(
            image: const AssetImage("assets/login_screen_background_image.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GetLogo(keyboard, portrait),
              Form(
                key: this._formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: portrait
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
                          key: Key("UsernameKey"),

                          style: portrait
                              ? TextStyle(fontSize: 30)
                              : TextStyle(fontSize: 20),
                          controller: usernameCtrl,
                          keyboardType: TextInputType.text,
                          // Use email input type for emails.
                          decoration: InputDecoration.collapsed(
                            hintText: "Brugernavn",
                            hintStyle: const TextStyle(
                                color: const Color.fromRGBO(170, 170, 170, 1)),
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
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          key: Key("PasswordKey"),
                          style: portrait
                              ? TextStyle(fontSize: 30)
                              : TextStyle(fontSize: 20),
                          controller: passwordCtrl,
                          obscureText: true,
                          decoration: const InputDecoration.collapsed(
                            hintText: 'Adgangskode',
                            hintStyle: const TextStyle(
                                color: const Color.fromRGBO(170, 170, 170, 1)),
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
                            key: Key("LoginBtnKey"),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0)),
                            child: Text(
                              'Login',
                              style: const TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              loginAction(context);
                            },
                            color: const Color.fromRGBO(48, 81, 118, 1),
                          ),
                        ),
                      ),
                    ),
                    // Autologin button, only used for debugging
                    Environment.getVar<bool>("DEBUG")
                        ? Container(
                            child: Transform.scale(
                              scale: 1.2,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Text(
                                  'Auto-Login',
                                  key: Key("AutoLoginKey"),
                                  style: const TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  usernameCtrl.text =
                                      Environment.getVar<String>("USERNAME");
                                  passwordCtrl.text =
                                      Environment.getVar<String>("PASSWORD");
                                },
                                color: const Color.fromRGBO(48, 81, 118, 1),
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
      child: const Image(
        image: const AssetImage("assets/giraf_splash_logo.png"),
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
    showDialog<Center>(
        barrierDismissible: Dismissible,
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Transform.scale(
                scale: 2,
                child: CircularProgressIndicator(
                  valueColor: const AlwaysStoppedAnimation(
                      const Color.fromRGBO(255, 157, 0, 0.8)),
                )),
          );
        });
  }
}
