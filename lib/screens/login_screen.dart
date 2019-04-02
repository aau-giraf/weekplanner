import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/providers/environment_provider.dart';
import 'package:weekplanner/widgets/giraf_notify_dialog.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  AuthBloc get authBloc => di.getDependency<AuthBloc>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final bool isDebugMode = Environment.getVar<bool>('DEBUG');

  BuildContext loginContext;
  static bool loggedInSuccessfull = false;

  void handleTimeout() {
    if (!loggedInSuccessfull) {
      Navigator.pop(loginContext);
      wrongUsernameOrPassword(loginContext);
    }
  }

  Future<bool> loginAction(BuildContext context) async {
    loginContext = context;
    showLoadingScreen(context, false, handleTimeout, 5000);
    authBloc.loggedIn.listen((bool status) async {
      if (status) {
        Navigator.pop(context);
        loggedInSuccessfull = true;
      }
    });
    authBloc.authenticate(usernameCtrl.value.text, passwordCtrl.value.text);
    return true;
  }

  void wrongUsernameOrPassword(BuildContext context) {
    showDialog<GirafNotifyDialog>(
        builder: (BuildContext context) {
          return const GirafNotifyDialog(
            title: 'Fejl',
            description: 'Forkert brugernavn eller adgangskode',
          );
        },
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool portrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final bool keyboard = MediaQuery.of(context).viewInsets.bottom > 100;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        padding: portrait
            ? const EdgeInsets.fromLTRB(50, 0, 50, 0)
            : const EdgeInsets.fromLTRB(200, 0, 200, 8),
        decoration: BoxDecoration(
          // The background of the login-screen
          image: const DecorationImage(
            image: AssetImage('assets/login_screen_background_image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              getLogo(keyboard, portrait),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: portrait
                          ? const EdgeInsets.fromLTRB(0, 20, 0, 10)
                          : const EdgeInsets.fromLTRB(0, 0, 0, 5),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20.0)),
                            color: Colors.white),
                        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                        child: TextField(
                          key: const Key('UsernameKey'),

                          style: portrait
                              ? const TextStyle(fontSize: 30)
                              : const TextStyle(fontSize: 20),
                          controller: usernameCtrl,
                          keyboardType: TextInputType.text,
                          // Use email input type for emails.
                          decoration: const InputDecoration.collapsed(
                            hintText: 'Brugernavn',
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
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20.0)),
                            color: Colors.white),
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          key: const Key('PasswordKey'),
                          style: portrait
                              ? const TextStyle(fontSize: 30)
                              : const TextStyle(fontSize: 20),
                          controller: passwordCtrl,
                          obscureText: true,
                          decoration: const InputDecoration.collapsed(
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
                            key: const Key('LoginBtnKey'),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: const Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
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
                    Environment.getVar<bool>('DEBUG')
                        ? Container(
                            child: Transform.scale(
                              scale: 1.2,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: const Text(
                                  'Auto-Login',
                                  key: Key('AutoLoginKey'),
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  usernameCtrl.text =
                                      Environment.getVar<String>('USERNAME');
                                  passwordCtrl.text =
                                      Environment.getVar<String>('PASSWORD');
                                  loginAction(context);
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

  Widget getLogo(bool keyboard, bool portrait) {
    if (keyboard) {
      return Container();
    }

    return Transform.scale(
      scale: portrait ? 1.0 : 0.5,
      child: const Image(
        image: AssetImage('assets/giraf_splash_logo.png'),
      ),
    );
  }

  static void showLoadingScreen(BuildContext context, bool dismissible,
      [void callback(), int timeoutMS]) {
    if (callback != null) {
      timeoutMS ??= 2000;
      Timer(Duration(milliseconds: timeoutMS), callback);
    }
    showDialog<Center>(
        barrierDismissible: dismissible,
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Transform.scale(
                scale: 2,
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromRGBO(255, 157, 0, 0.8)),
                )),
          );
        });
  }
}
