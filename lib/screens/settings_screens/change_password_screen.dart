import 'dart:async';
import 'dart:io';
import 'package:api_client/api/api.dart';
import 'package:api_client/api/api_exception.dart';
import 'package:api_client/http/http.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:flutter/material.dart';
import 'package:quiver/async.dart';
import 'package:weekplanner/api/errorcode_translater.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/providers/environment_provider.dart' as environment;
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/settings_screens/change_username_screen.dart';
import 'package:weekplanner/style/font_size.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_confirm_dialog.dart';
import 'package:weekplanner/widgets/giraf_notify_dialog.dart';
import 'package:weekplanner/widgets/loading_spinner_widget.dart';
import '../../style/custom_color.dart' as theme;

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen(DisplayNameModel user) : _user = user {}

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// This is the username control, that allows for username extraction
  final TextEditingController usernameCtrl = TextEditingController();

  /// This is the password control, that allows for password extraction
  final TextEditingController currentPasswordCtrl = TextEditingController();
  final TextEditingController newPasswordCtrl = TextEditingController();
  final TextEditingController repeatNewPasswordCtrl = TextEditingController();

  final DisplayNameModel _user;
  final SettingsBloc _settingsBloc = di.getDependency<SettingsBloc>();
  final AuthBloc authBloc = di.getDependency<AuthBloc>();
  final Api _api = di.getDependency<Api>();
  BuildContext currentContext;

  //const ChangePasswordScreen({Key key, this._user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GirafAppBar(title: 'Skift password'),
        body: buildPasswordChange(context));
  }

  Widget buildPasswordChange(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool portrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final bool landscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    ///Used to check if the keyboard is visible
    final bool keyboard = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        padding: portrait
            ? const EdgeInsets.fromLTRB(50, 300, 50, 0)
            : const EdgeInsets.fromLTRB(200, 125, 200, 8),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const Text(
                      'Nuværende adgangskode',
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
                          key: const Key('PasswordKey'),
                          style: const TextStyle(fontSize: GirafFont.large),
                          controller: currentPasswordCtrl,
                          obscureText: true,
                          decoration: const InputDecoration.collapsed(
                            hintText: 'Adgangskode',
                            hintStyle: TextStyle(
                                color: theme.GirafColors.loginFieldText),
                            fillColor: theme.GirafColors.white,
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      'Ny adgangskode',
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
                          key: const Key('PasswordKey'),
                          style: const TextStyle(fontSize: GirafFont.large),
                          controller: newPasswordCtrl,
                          obscureText: true,
                          decoration: const InputDecoration.collapsed(
                            hintText: 'Adgangskode',
                            hintStyle: TextStyle(
                                color: theme.GirafColors.loginFieldText),
                            fillColor: theme.GirafColors.white,
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      'Gentag ny adgangskode',
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
                          key: const Key('PasswordKey'),
                          style: const TextStyle(fontSize: GirafFont.large),
                          controller: repeatNewPasswordCtrl,
                          obscureText: true,
                          decoration: const InputDecoration.collapsed(
                            hintText: 'Gentag adgangskode',
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
                              validatePasswords(context);
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

  //This function, found in the account_api, handles the password change, when the "Gem"-button is clicked
  void ChangePassword(
      DisplayNameModel user, String oldPassword, String newPassword) async {
    //authBloc.authenticate(user.displayName, oldPassword);
    bool loginStatus = false;

    await authBloc
        .authenticate(authBloc.loggedInUsername, oldPassword)
        .then((dynamic result) {
      StreamSubscription<bool> loginListener;
      loginListener = authBloc.loggedIn.listen((bool snapshot) {
        loginStatus = snapshot;
        if (snapshot) {
          print("Snapshot: " + snapshot.toString());
          _api.account
              .changePasswordWithOld(user.id, oldPassword, newPassword)
              .listen((status) {
            print("Status: " + status.toString());
          });
        }

        /// Stop listening for future logins
        loginListener.cancel();
      });
    }).catchError((Object error) {
      if (error is ApiException) {
        print("ApiExceptionCaught: " + error.errorMessage);
        creatingErrorDialog("Forkert adgangskode", "WrongPassword");
      } else {
        print("Other error");
      }
    }).whenComplete(() => GirafNotifyDialog(
              key: (Key("PasswordChanged")),
              title: "Adgangskoden ændret.",
              description: "Adgangskoden er blevet ændret.",
            ));
  }

  /*Future ChangePasswordForAccount(Stream<bool> passStream) async {
      //Stream<bool>.fromFuture(Future.error(Exception()));
      await for (final value in passStream) {
        //print(value);
        //_api.account.changePasswordWithOld(guardian, "password", "password1");
      }
    }

    //GetGuardians(guardians);
    ChangePasswordForAccount(passStream);*/
  void validatePasswords(BuildContext context) async {
    //Stream<GirafUserModel> girafUser = await _api.user.get(_user.id);
    currentContext = context;

    //_api.user.getCitizens()
    // _api.user.getGuardians()

    /// This if-statement should be implemented when the getUserByName method is implemented correctly
    /// This should check if the new username is already in the database.
    //if(await _api.user.getUserByName(newUsernameCtrl.text).isEmpty != null)
    //creatingErrorDialog("Brugernavnet ${newUsernameCtrl.text} er allerede taget.", "");
    if (newPasswordCtrl.text != repeatNewPasswordCtrl.text)
      creatingErrorDialog("Den gentagne adgangskode stemmer ikke overens",
          "NewPasswordNotRepeated");
    else if (currentPasswordCtrl.text == "" ||
        newPasswordCtrl.text == "" ||
        repeatNewPasswordCtrl == "")
      creatingErrorDialog("Udfyld venligst.", "NewPasswordEmpty");
    else {
      ChangePassword(_user, currentPasswordCtrl.text, newPasswordCtrl.text);
    }
  }

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
}
