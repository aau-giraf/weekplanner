import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:api_client/api/api.dart';
import 'package:api_client/api/api_exception.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/providers/environment_provider.dart' as environment;
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/login_screen.dart';
import 'package:weekplanner/style/font_size.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/giraf_notify_dialog.dart';
import 'package:weekplanner/widgets/giraf_title_header.dart';
import 'package:weekplanner/widgets/loading_spinner_widget.dart';
import '../../style/custom_color.dart' as theme;

/// Screen for changing username
class ChangeUsernameScreen  extends StatefulWidget {
  /// Constructor
  ChangeUsernameScreen(DisplayNameModel user) : _user = user {
    _settingsBloc.loadSettings(_user);
  }

  final DisplayNameModel _user;
  final SettingsBloc _settingsBloc = di.getDependency<SettingsBloc>();
  @override State<StatefulWidget> createState() =>  ChangeUsernameScreenState();
}

/// State for ChangeUsernameScreen
class ChangeUsernameScreenState  extends State<ChangeUsernameScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();

  /// This is the username control, that allows for username extraction
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController newUsernameCtrl = TextEditingController();
  final TextEditingController confirmUsernameCtrl = TextEditingController();

  /// Using the authBloc makes it possible to find the user that is logged in.
  final AuthBloc authBloc = di.getDependency<AuthBloc>();

  final Api _api = di.getDependency<Api>();
  BuildContext currentContext;
  bool loginStatus = false;

  /// Function that creates a dialog that confirms the user.
  void UsernameConfirmationDialog(Stream<GirafUserModel> girafUser){
    showDialog<Center>(
        barrierDismissible: false,
        context: currentContext,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: const EdgeInsets.all(0.0),
            title: Center(
                child: GirafTitleHeader( title: "Verificer bruger", )),
            content: Form(
              key: _formKey1,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Text('For at skifte brugernavn, indtast dit kodeord for \n${authBloc.loggedInUsername}',
                      style: TextStyle(
                        fontSize: GirafFont.small,
                      ),
                    ),
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: confirmUsernameCtrl,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'Kodeord',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.fromLTRB(0, 15, 0, 0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GirafButton(
                          text: "Fortryd",
                          width: 121,
                          icon: const ImageIcon(
                            AssetImage('assets/icons/cancel.png'),
                            color: theme.GirafColors.transparentBlack,),
                          onPressed: () => Navigator.pop(context)
                      ),
                      GirafButton(
                          key: const Key('UsernameConfirmationDialogSaveButton'),
                          text: "Gem",
                          width: 121,
                          icon: const ImageIcon(
                              AssetImage('assets/icons/accept.png'),
                              color: theme.GirafColors.transparentBlack
                          ),
                          onPressed: () async {
                            loginStatus = false;

                            /// This authenticates the user with username and password.
                            await authBloc.authenticateFromPopUp(authBloc.loggedInUsername, confirmUsernameCtrl.text)
                                .then((dynamic result) {
                              StreamSubscription<bool> loginListener;
                              loginListener = authBloc.loggedIn.listen((bool snapshot) {
                                loginStatus = snapshot;
                                // Return if logging out
                                if (snapshot) {
                                  /// Pop the loading spinner doesnt work because we are in a pop-up

                                  UpdateUser(girafUser);
                                  newUsernameCtrl.clear();
                                  Routes.pop(currentContext);
                                }
                                /// Stop listening for future logins
                                loginListener.cancel();
                              });
                            }).catchError((Object error) {
                                if(error is ApiException){
                                  creatingErrorDialog("Forkert adgangskode.", error.errorKey.toString());
                                } else if(error is SocketException){
                                  authBloc.checkInternetConnection().then((bool hasInternetConnection) {
                                    if (hasInternetConnection) {
                                      /// Checking server connection, if true check username/password
                                      authBloc.getApiConnection().then((bool hasServerConnection) {
                                        if (hasServerConnection) {
                                          unknownErrorDialog(error.message);
                                        }
                                        else{
                                          creatingErrorDialog(
                                              'Der er i øjeblikket ikke forbindelse til serveren.',
                                              'ServerConnectionError');
                                        }
                                      }).catchError((Object error){
                                        unknownErrorDialog(error.toString());
                                      });
                                    } else {
                                      creatingErrorDialog(
                                          'Der er ingen forbindelse til internettet.',
                                          'NoConnectionToInternet');
                                    }
                                  });
                                } else {
                                  unknownErrorDialog('UnknownError');
                                }
                            });
                          }
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }
        );
  }

  /// Function that creates the notify dialog,
  /// depeninding which login error occured
  void creatingErrorDialog(String description, String key) {
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
  void unknownErrorDialog(String key){
    creatingErrorDialog('Der skete en ukendt fejl, prøv igen eller '
        'kontakt en administrator', 'key');
  }

  /// Updates the user with new username
  Future UpdateUser(Stream<GirafUserModel> userStream) async{
    await for (final value in userStream){
      value.username = newUsernameCtrl.text;
      value.displayName = newUsernameCtrl.text;
      _api.user.update(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GirafAppBar(title: 'Skift brugernavn på bruger: ' + widget._user.displayName),
        body: buildUsernameChange(context));
  }

  Widget buildUsernameChange(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool portrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    ///Used to check if the keyboard is visible
    final bool keyboard = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        padding: portrait
            ? const EdgeInsets.fromLTRB(50, 0, 50, 0)
            : const EdgeInsets.fromLTRB(200, 0, 200, 8),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const Text(
                      'Nyt brugernavn',
                      style: TextStyle(
                        fontSize: GirafFont.large,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: theme.GirafColors.grey, width: 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20.0)),
                            color: theme.GirafColors.white),
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          key: const Key('UsernameKey'),
                          style: const TextStyle(fontSize: GirafFont.large),
                          controller: newUsernameCtrl,
                          obscureText: false,
                          decoration:
                            InputDecoration.collapsed(
                              hintText: widget._user.displayName,
                              hintStyle: TextStyle(
                                  color: theme.GirafColors.loginFieldText),
                            fillColor: theme.GirafColors.white,
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
                              'Gem',
                              style: TextStyle(color: theme.GirafColors.white),
                            ),
                            onPressed: () {
                              UpdateUsername(context);
                            },
                            color: theme.GirafColors.dialogButton,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ]),
      ),
    );
  }

  void UpdateUsername(BuildContext context) async {
    currentContext = context;
    Stream<GirafUserModel> girafUser = await _api.user.get(widget._user.id);

    if(await _api.user.getUserByName(newUsernameCtrl.text).isEmpty != null)
      creatingErrorDialog("Brugernavnet ${newUsernameCtrl.text} er allerede taget.", "");
    ///Missing check for if the new username is already in the database.
    if (newUsernameCtrl.text == widget._user.displayName)
      creatingErrorDialog("Nyt brugernavn må ikke være det samme som det nuværende brugernavn.", "");
    else if (newUsernameCtrl.text == "")
      creatingErrorDialog("Udfyld venligst nyt brugernavn.", "");
    else if (newUsernameCtrl.text != widget._user.displayName) {
      UsernameConfirmationDialog(girafUser);
    }
  }
}