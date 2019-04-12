import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:weekplanner/providers/api/api.dart';
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
  Stream<bool> get loggedIn => _loggedIn.stream;

  /// Start with providing false as the logged in status
  final BehaviorSubject<bool> _loggedIn = BehaviorSubject<bool>.seeded(false);

  /// This is the current state of login, made available across methods
  bool loginStatus = false;

  /// This is the BuildContext on which to show the
  /// loadingSpinner and NotifyDialog
  BuildContext buildContext;

  /// Authenticates the user with the given [username] and [password]
  void authenticate(String username, String password, BuildContext context) {
    // Show the Loading Spinner, with a callback of 2 seconds.
    showLoadingSpinner(context, false, showNotifyDialog, 2000);
    // Call the API login function
    _api.account.login(username, password).take(1).listen((bool status) {
      // Set the status
      loginStatus = status;
      buildContext = context;
      // If there is a successful login, remove the loading spinner,
      // and push the status to the stream
      if (status) {
        Routes.pop(buildContext);
        _loggedIn.add(status);
        loggedInUsername = username;
      }
    });
  }

  /// This is the callback method of the loading spinner to show the dialog
  void showNotifyDialog() {
    if (!loginStatus) {
      // Remove the loading spinner
      Routes.pop(buildContext);
      // Show the new NotifyDialog
      showDialog<Center>(
          barrierDismissible: false,
          context: buildContext,
          builder: (BuildContext context) {
            return const GirafNotifyDialog(
                title: 'Fejl!',
                description: 'Forkert brugernavn og/eller adgangskode',
                key: Key('WrongUsernameOrPassword'));
          }).then((_) {
        // When the user dismisses the NotifyDialog,
        // add the status to the stream
        _loggedIn.add(loginStatus);
      });
    }
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
