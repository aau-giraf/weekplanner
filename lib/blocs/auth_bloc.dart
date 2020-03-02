import 'package:api_client/api/api.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:weekplanner/models/enums/weekplan_mode.dart';

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

  /// Reflect the current clearence level of the user
  final BehaviorSubject<WeekplanMode> _mode =
      BehaviorSubject<WeekplanMode>.seeded(WeekplanMode.guardian);

  /// The stream that emits the current clearance level
  Observable<WeekplanMode> get mode => _mode.stream;

  /// Stream that streams status of last login attemp from popup.
  Observable<bool> get loginAttempt => _loginAttempt.stream;

  final BehaviorSubject<bool> _loginAttempt =
      BehaviorSubject<bool>.seeded(false);

  /// Authenticates the user with the given [username] and [password]
  void authenticate(String username, String password) {
    // Show the Loading Spinner, with a callback of 2 seconds.
    // Call the API login function
    _api.account.login(username, password).listen((bool status) {
      // Set the status
      // If there is a successful login, remove the loading spinner,
      // and push the status to the stream
      if (status) {
        _loggedIn.add(status);
        loggedInUsername = username;
        setMode(WeekplanMode.guardian);
      }
    });
  }

  /// Authenticates the user only by password when signing-in from PopUp.
  void authenticateFromPopUp(String username, String password) {
    _api.account.login(username, password).listen((bool status) {
      if (status) {
        _loginAttempt.add(status);
        setMode(WeekplanMode.guardian);
      }
    });
  }

  /// Logs the currently logged in user out
  void logout() {
    _api.account.logout().listen((_) {
      _loggedIn.add(false);
    });
  }

  /// Updates the mode of the weekplan
  void setMode(WeekplanMode mode) {
    _mode.add(mode);
  }

  /// Set status of last login attempt
  void setAttempt(bool attempt) {
    _loginAttempt.add(attempt);
  }

  @override
  void dispose() {
    _loggedIn.close();
    _mode.close();
    _loginAttempt.close();
  }
}
