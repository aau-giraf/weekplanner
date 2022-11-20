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
  final AuthBloc authBloc = di.getDependency<AuthBloc>();
  final Api _api = di.getDependency<Api>();
  BuildContext currentContext;
  bool loginStatus = false; //ignore: public_member_api_docs

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
                          key: const Key('OldPasswordKey'),
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
                          key: const Key('NewPasswordKey'),
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
                          key: const Key('RepeatedPasswordKey'),
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
                            key: const Key('ChangePasswordBtnKey'),
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

  void ChangePassword(
      DisplayNameModel user, String oldPassword, String newPassword) async {
    bool loginStatus = false;
    //Checks if user is logged in
    await authBloc
        .authenticate(authBloc.loggedInUsername, oldPassword)
        .then((dynamic result) {
      StreamSubscription<bool> loginListener;
      loginListener = authBloc.loggedIn.listen((bool snapshot) {
        loginStatus = snapshot;
        if (snapshot) {
          //This method, found in the account_api, handles the password change, when the "Gem"-button is clicked
          _api.account
              .changePasswordWithOld(user.id, oldPassword, newPassword)
              .listen((_) {})
              .onDone(() {
            CreateDialog("Kodeord ændret", "Dit kodeord er blevet ændret",
                Key("PasswordChanged"));
          });
        }

        /// Stop listening for future logins
        loginListener.cancel();
      });
    }).catchError((Object error) {
      if (error is ApiException) {
        CreateDialog("Forkert adgangskode",
            "Den nuværende adgangskode er forkert", Key("WrongPassword"));
      } else {
        print(error.toString());
        CreateDialog(
            "Fejl", "Der skete en ukendt fejl", Key("UnknownErrorOccured"));
      }
    });
  }

  ///Functionality for validating whether input fields are empty
  ///and whether the repeated password for confirmation is the same as the new password
  void validatePasswords(BuildContext context) async {
    currentContext = context;

    if (newPasswordCtrl.text != repeatNewPasswordCtrl.text)
      CreateDialog("Fejl", "Den gentagne adgangskode stemmer ikke overens",
          Key("NewPasswordNotRepeated"));
    else if (currentPasswordCtrl.text == "" ||
        newPasswordCtrl.text == "" ||
        repeatNewPasswordCtrl == "") {
      CreateDialog(
          "Fejl", "Udfyld venligst alle felterne", Key("NewPasswordEmpty"));
    } else if (newPasswordCtrl.text == currentPasswordCtrl.text) {
      CreateDialog(
          "Fejl",
          "Det nye kodeord må ikke være det samme som det gamle",
          Key("NewPasswordSameAsOld"));
    } else {
      ChangePassword(_user, currentPasswordCtrl.text, newPasswordCtrl.text);
    }
  }

  void CreateDialog(String title, String description, Key key) {
    /// Show the new NotifyDialog
    showDialog<Center>(
        barrierDismissible: false,
        context: currentContext,
        builder: (BuildContext context) {
          return GirafNotifyDialog(
              title: title, description: description, key: key);
        });
  }
}
