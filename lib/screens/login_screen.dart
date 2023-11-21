import 'dart:async';
import 'dart:io';

import 'package:api_client/api/api_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/exceptions/custom_exceptions.dart';
import 'package:weekplanner/providers/environment_provider.dart' as environment;
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/pictogram_login_screen.dart';
import 'package:weekplanner/style/font_size.dart';
import 'package:weekplanner/widgets/giraf_notify_dialog.dart';
import 'package:weekplanner/widgets/loading_spinner_widget.dart';

import '../style/custom_color.dart' as theme;

/// Logs the user in
class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

/// This is the login state
class LoginScreenState extends State<LoginScreen> {
  /// AuthBloC used to communicate with API
  final AuthBloc authBloc = di.get<AuthBloc>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// This is the username control, that allows for username extraction
  final TextEditingController usernameCtrl = TextEditingController();

  /// This is the password control, that allows for password extraction
  final TextEditingController passwordCtrl = TextEditingController();

  /// Stores the context
  BuildContext currentContext;

  /// Stores the login status, used for dismissing the LoadingSpinner
  bool loginStatus = false;

  /// Controls whether we should show the pictogram login screen or use default text-based login
  bool showPictogram = false;

  /// A simple lock for disabling re-clicking of the pictogram switch
  bool pictogramLock = false;

  /// This is called when login should be triggered
  void loginAction(BuildContext context) {
    showLoadingSpinner(context, true);
    currentContext = context;
    loginStatus = false;
    authBloc
        .authenticate(usernameCtrl.value.text, passwordCtrl.value.text)
        .then((dynamic result) {
      StreamSubscription<bool> loginListener;
      loginListener = authBloc.loggedIn.listen((bool snapshot) {
        loginStatus = snapshot;
        // Return if logging out
        if (snapshot) {
          // Pop the loading spinner
          Routes().goHome(context);
        }
        // Stop listening for future logins
        loginListener.cancel();
      });
    }).catchError((Object error) {
      if (error is ApiException) {
        creatingNotifyDialog('Forkert brugernavn og/eller adgangskode.',
            error.errorKey.toString());
      } else if (error is SocketException) {
        authBloc.checkInternetConnection().then((bool hasInternetConnection) {
          //Not sure this try-catch statement will
          //ever fail and therefore catch anything
          try {
            if (hasInternetConnection) {
              // Checking server connection, if true check username/password
              authBloc.getApiConnection().then((bool hasServerConnection) {
                if (hasServerConnection) {
                  creatingNotifyDialog(
                      'Der er forbindelse'
                      ' til serveren, men der opstod et problem',
                      error.message);
                } else {
                  creatingNotifyDialog(
                      'Der er i øjeblikket'
                          ' ikke forbindelse til serveren.',
                      'ServerConnectionError');
                }
              }).catchError((Object error) {
                unknownErrorDialog(error.toString());
              });
            } else {
              creatingNotifyDialog(
                  'Der er ingen forbindelse'
                      ' til internettet.',
                  'NoConnectionToInternet');
            }
          } catch (err) {
            throw ServerException(
                'There was an error with the server' '\n Error: ',
                err.toString());
          }
        });
      } else {
        unknownErrorDialog('The error is neither an Api problem nor'
            'a socket problem');
      }
    });
  }

  /// Function that creates the notify dialog,
  /// depeninding which login error occured
  void creatingNotifyDialog(String description, String key) {
    /// Remove the loading spinner
    Routes().pop(currentContext);

    /// Show the new NotifyDialog
    showDialog<Center>(
        barrierDismissible: false,
        context: currentContext,
        builder: (BuildContext context) {
          return GirafNotifyDialog(
              title: 'Fejl', description: description, key: Key(key));
        });
  }

  /// Create an unknown error dialog
  void unknownErrorDialog(String key) {
    creatingNotifyDialog(
        'Der skete en ukendt fejl, prøv igen eller '
            'kontakt en administrator',
        'key');
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool portrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    ///Used to check if the keyboard is visible
    final bool keyboard = MediaQuery.of(context).viewInsets.bottom > 0;

    final ButtonStyle girafButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: theme.GirafColors.loginButtonColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              height: screenSize.height,
             child: Image.asset(
               'assets/icons/giraf_orange_long.png',
               repeat: ImageRepeat.repeat,
               fit: BoxFit.cover,
             ),
            )
          ),
          Expanded(
            flex: 5,
            child: Container(
              width: screenSize.width,
              height: screenSize.height,
              padding: portrait
                  ? const EdgeInsets.fromLTRB(50, 0, 50, 0)
                  : const EdgeInsets.fromLTRB(200, 0, 200, 8),
              decoration: const BoxDecoration(
                color: Colors.white,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 40, 20, 40),
                                  child: Transform.scale(
                                   scale: 1.5,
                                   child: const Icon(
                                     Icons.text_fields_rounded,
                                   )
                                  )
                              ),
                              Container(
                                child: Transform.scale(
                                  scale: 2,
                                  child: Switch(
                                    value: showPictogram,
                                    key: const Key("PictogramSwitch"),
                                    thumbColor: const MaterialStatePropertyAll<Color>(Colors.green),
                                    onChanged: (bool value) {
                                      // Do nothing if the lock is enabled
                                      if (pictogramLock) {
                                        return;
                                      }

                                      setState(() {
                                        showPictogram = value;

                                        if (showPictogram) {
                                          // Add pictogram lock to prevent spamming the switch during animation
                                          pictogramLock = true;

                                          // Show pictogram screen after a short delay until a better UI solution is implemented
                                          // This avoids instant popup of the pictogram login screen before switch animation is finished
                                          Future.delayed(const Duration(milliseconds: 300), () {
                                            Routes().push(context, PictogramLoginScreen()).then((value) {
                                              // Reset the switch widget when we return from the picogram screen
                                              setState(() {
                                                showPictogram = false;

                                                // Release the lock
                                                pictogramLock = false;
                                              });
                                            });
                                          });
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 40, 0, 40),
                                  child: Transform.scale(
                                    scale: 1.5,
                                    child: const Icon(
                                      Icons.photo_outlined,
                                    )
                                  )
                              ),
                            ],
                          ),
                          Padding(
                            padding: portrait
                                ? const EdgeInsets.fromLTRB(0, 20, 0, 10)
                                : const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                    child: Text(
                                      'Brugernavn',
                                      style: TextStyle(fontSize: GirafFont.medium),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: theme.GirafColors.grey, width: 1),
                                      borderRadius:
                                      const BorderRadius.all(Radius.circular(10.0)),
                                      color: theme.GirafColors.white),
                                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                                  child: TextField(
                                    key: const Key('UsernameKey'),
                                    style: const TextStyle(fontSize: GirafFont.large),
                                    controller: usernameCtrl,
                                    keyboardType: TextInputType.text,
                                    // Use email input type for emails.
                                    decoration: const InputDecoration.collapsed(
                                      hintStyle: TextStyle(
                                          color: theme.GirafColors.loginFieldText),
                                      fillColor: theme.GirafColors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                    child: Text(
                                      'Kodeord',
                                      style: TextStyle(fontSize: GirafFont.medium),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: theme.GirafColors.grey, width: 1),
                                      borderRadius:
                                      const BorderRadius.all(Radius.circular(10.0)),
                                      color: theme.GirafColors.white),
                                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                                  child: TextField(
                                    key: const Key('UsernameKey'),
                                    style: const TextStyle(fontSize: GirafFont.large),
                                    controller: usernameCtrl,
                                    keyboardType: TextInputType.text,
                                    // Use email input type for emails.
                                    decoration: const InputDecoration.collapsed(
                                      hintStyle: TextStyle(
                                          color: theme.GirafColors.loginFieldText),
                                      fillColor: theme.GirafColors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 25, 0, 5),
                            child: Container(
                              child: Transform.scale(
                                scale: 1.5,
                                child: ElevatedButton(
                                  key: const Key('LoginBtnKey'),
                                  style: girafButtonStyle,
                                  child: const Text(
                                    'LOGIN',
                                    style: TextStyle(color: theme.GirafColors.white, fontSize: GirafFont.large),
                                  ),
                                  onPressed: () {
                                    loginAction(context);
                                  },
                                ),
                              ),
                            ),
                          ),
                          // Autologin button, only used for debugging
                          environment.getVar<bool>('DEBUG')
                              ? Container(
                            child: Transform.scale(
                              scale: 1.2,
                              child: ElevatedButton(
                                style: girafButtonStyle,
                                child: const Text(
                                  'AUTO-LOGIN',
                                  key: Key('AutoLoginKey'),
                                  style: TextStyle(color: theme.GirafColors.white, fontSize: GirafFont.large),
                                ),
                                onPressed: () {
                                  usernameCtrl.text =
                                      environment.getVar<String>('USERNAME');
                                  passwordCtrl.text =
                                      environment.getVar<String>('PASSWORD');
                                  loginAction(context);
                                },
                              ),
                            ),
                          )
                              : Container(),
                        ],
                      ),
                    )
                  ]),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: screenSize.height,
              child: Image.asset(
                'assets/icons/giraf_blue_long.png',
                repeat: ImageRepeat.repeat,
                fit: BoxFit.cover,
              ),
            )
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: screenSize.height,
              child: Image.asset(
                'assets/icons/giraf_green_long.png',
                repeat: ImageRepeat.repeat,
                fit: BoxFit.cover,
              ),
            )
          )
        ],
      )
    );
  }

  /// Returns the giraf logo
  Widget getLogo(bool keyboard, bool portrait) {
    if (keyboard && !portrait) {
      return Container();
    }

    return Container(
      child: const Image(
        image: AssetImage('assets/icons/login_logo.png'),
      ),
      padding: const EdgeInsets.only(bottom: 10),
    );
  }
}
