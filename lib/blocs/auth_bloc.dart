import 'package:api_client/api/api.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/giraf_notify_dialog.dart';
import 'package:weekplanner/widgets/loading_spinner_widget.dart';

/// All about Authentication. Login, logout, etc.
class AuthBloc extends BlocBase {
  /// Default Constructor
  AuthBloc(this._api);

  /// String is used then changing from citizen to guardian mode
  /// the username is saved so only the password is needed.
  String loggedInUsername;

  final Api _api;

  /// Whether or not the user is logged in
  Observable<bool> get loggedIn => _loggedIn.stream;

  /// Start with providing false as the logged in status
  final BehaviorSubject<bool> _loggedIn = BehaviorSubject<bool>.seeded(false);

  /// Authenticates the user with the given [username] and [password]
  void authenticate(String username, String password) {
    // Show the Loading Spinner, with a callback of 2 seconds.
    // Call the API login function
    _api.account.login(username, password).take(1).listen((bool status) {
      // Set the status
      // If there is a successful login, remove the loading spinner,
      // and push the status to the stream
      if (status) {
        _loggedIn.add(status);
        loggedInUsername = username;
      }
    });
  }

  /// Indicates whether the last login attempt was succesfull.
  bool loginStatus = false;

  /// Shows a dialog when incorrect login in popup.
  void reactToLoginAttempt (BuildContext context) {
    // pops the loading spinner
    Routes.pop(context);

    // shows the dialog if the last login attempt was insuccessfull
    if (!loginStatus) {
      showFailureDialog(context);
    }
  }

  void showFailureDialog(BuildContext context){
    showDialog<Center>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return const GirafNotifyDialog(
              title: 'Fejl',
              description: 'Forkert brugernavn og/eller adgangskode',
              key: Key('WrongUsernameOrPasswordDialog'));
        });
  }

  /// Authenticates the user only by password when signing-in from PopUp.
  void authenticateFromPopUp(String username, String password,
                             BuildContext context) {
    // Make sure the status for the upcoming
    // login is false until proven otherwise
    loginStatus = false;
    showLoadingSpinner(context, false,
                       () => reactToLoginAttempt(context), 2000);

    _api.account.login(username, password).take(1).listen((bool status) {
      if (status){
        loginStatus = true;
        //Pop the popup
        Routes.pop(context);
        }
    });
    }


  /// Logs the currently logged in user out
  void logout() {
    _api.account.logout().take(1).listen((_) {
      _loggedIn.add(false);
    });
  }

  @override
  void dispose() {
    _loggedIn.close();
  }
}
