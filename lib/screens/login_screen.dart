import 'dart:io';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/providers/environment_provider.dart' as environment;
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/giraf_notify_dialog.dart';
import 'package:weekplanner/widgets/loading_spinner_widget.dart';
import 'package:http/http.dart' as http;

/// Logs the user in
class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

/// This is the login state
class LoginScreenState extends State<LoginScreen> {
  /// AuthBloC used to communicate with API
  final AuthBloc authBloc = di.getDependency<AuthBloc>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// This is the username control, that allows for username extraction
  final TextEditingController usernameCtrl = TextEditingController();

  /// This is the password control, that allows for password extraction
  final TextEditingController passwordCtrl = TextEditingController();

  /// Stores the context
  BuildContext currentContext;

  /// Stores the login status, used for dismissing the LoadingSpinner
  bool loginStatus = false;

  /// This is called when login should be triggered
  void loginAction(BuildContext context) {
    showLoadingSpinner(context, false, showNotifyDialog, 2000);
    currentContext = context;
    loginStatus = false;
    authBloc.authenticate(usernameCtrl.value.text, passwordCtrl.value.text);
    authBloc.loggedIn.listen((bool snapshot) {
      loginStatus = snapshot;
      if (snapshot) {
        Routes.goHome(context);
      }
    });
  }

  /// This is the callback method of the loading spinner to show the dialog
  void showNotifyDialog() {
    // Checking internet connection, if true check server connection
    checkInternetConnection().then((bool value) {
      if (value == true) {

        // Checking server connection, if true check username/password
        checkServerConnection().then((bool value1) {
          if (value1 == true) {

            // Checking username/password
            if (!loginStatus) {
              creatingNotifyDialog('Forkert brugernavn og/eller adgangskode', 'WrongUsernameOrPassword');
            }
          } else {
            creatingNotifyDialog('Der er i øjeblikket'
                ' ikke forbindelse til severen', 'NoConnectionToServer');
          }
        });
      } else {
        creatingNotifyDialog('Der er ingen forbindelse'
            ' til internettet', 'NoConnectionToInternet');
      }
    });
  }

  // Function that creates the notify dialog,
  // depeninding which login error occured
  void creatingNotifyDialog(String description, String key) {
    // Remove the loading spinner
    Routes.pop(currentContext);
    // Show the new NotifyDialog
    showDialog<Center>(
        barrierDismissible: false,
        context: currentContext,
        builder: (BuildContext context) {
          return GirafNotifyDialog(
              title: 'Fejl',
              description: description,
              key: Key(key));
        });
  }


  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool portrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    ///Used to check if the keyboard is visible
    final bool keyboard = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        padding: portrait
            ? const EdgeInsets.fromLTRB(50, 0, 50, 0)
            : const EdgeInsets.fromLTRB(200, 0, 200, 8),
        decoration: const BoxDecoration(
          // The background of the login-screen
          image: DecorationImage(
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
                          style: const TextStyle(fontSize: 30),
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
                          style: const TextStyle(fontSize: 30),
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
                    environment.getVar<bool>('DEBUG')
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
                                environment.getVar<String>('USERNAME');
                            passwordCtrl.text =
                                environment.getVar<String>('PASSWORD');
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

  /// Returns the giraf logo
  Widget getLogo(bool keyboard, bool portrait) {
    if (keyboard && !portrait) {
      return Container();
    }

    return Container(
      child: const Image(
        image: AssetImage('assets/giraf_splash_logo.png'),
      ),
      padding: const EdgeInsets.only(bottom: 10),
    );
  }

  // Function to test connection to server,
  // it both checks for DEV API connection and to PROD API connection
  Future<bool> checkServerConnection() async {
    final String loginUrl = environment.getVar<String>('SERVER_HOST');
    try {
      final http.Response loginResponse =
      await http.get(loginUrl).timeout(Duration(seconds: 10));
      if (loginResponse.statusCode == 200) {
        return Future<bool>.value(true);
      } else {
        throw Exception('Authentication Error');
      }
    } catch (e) {
      print('Error:' + e.toString());
      return Future<bool>.value(false);
    }
  }

  // Function to test connection to internet
  Future<bool> checkInternetConnection() async {
    try {
      final List<InternetAddress> result = await InternetAddress.lookup(
          'google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return Future<bool>.value(true);
      }
      return null;
    } on SocketException catch (e) {
      print(e.message);
      return Future<bool>.value(false);
    }
  }

}

