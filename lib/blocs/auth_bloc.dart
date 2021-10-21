import 'dart:async';
import 'package:api_client/api/api.dart';
import 'package:rxdart/rxdart.dart' as rx_dart;
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:weekplanner/models/enums/weekplan_mode.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

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
  final rx_dart.BehaviorSubject<bool> _loggedIn
  = rx_dart.BehaviorSubject<bool>.seeded(false);

  /// Reflect the current clearence level of the user
  final rx_dart.BehaviorSubject<WeekplanMode> _mode =
  rx_dart.BehaviorSubject<WeekplanMode>.seeded(WeekplanMode.guardian);

  /// The stream that emits the current clearance level
  Stream<WeekplanMode> get mode => _mode.stream;

  /// Stream that streams status of last login attemp from popup.
  Stream<bool> get loginAttempt =>_loginAttempt.stream;

  final rx_dart.BehaviorSubject<bool> _loginAttempt =
  rx_dart.BehaviorSubject<bool>.seeded(false);

  /// Authenticates the user with the given [username] and [password]
  Future<void> authenticate(String username, String password) async {
    // Show the Loading Spinner, with a callback of 2 seconds.
    // Call the API login function
    final Completer<void> completer = Completer<void>();
    _api.account.login(username, password).listen((bool status) {
      // Set the status
      // If there is a successful login, remove the loading spinner,
      // and push the status to the stream
      if (status) {
        _loggedIn.add(status);
        loggedInUsername = username;
        setMode(WeekplanMode.guardian);
      }
      completer.complete();
    }).onError((Object error){
      completer.completeError(error);
    });

    Future.wait(<Future<void>>[completer.future]);
    return completer.future;
  }

  /// Authenticates the user only by password when signing-in from PopUp.
  Future<void> authenticateFromPopUp(String username, String password) async {
    final Completer<void> completer = Completer<void>();
    _api.account.login(username, password).listen((bool status) {
      if (status) {
        // Get the role of a specific user
        _api.account.role(username).listen((String role){
          if (role == 'guardian'){
            setMode(WeekplanMode.guardian);
          }
          else if(role == 'trustee'){
            setMode(WeekplanMode.trustee);
          }
          else{
            setMode(WeekplanMode.citizen);
          }
          _loginAttempt.add(status);
        });
      }

    completer.complete();
    }).onError((Object error) {
      completer.completeError(error);
    } );
    Future.wait(<Future<void>>[completer.future]);
    return completer.future;
  }

  ///Checks if theres is a connection to the api server
  Future<bool> getApiConnection(){
    final Completer<bool> completer = Completer<bool>();
    _api.status.status().listen((bool status) {
      completer.complete(status);
    }).onError((Object error){
      completer.complete(false);
    });
    Future.wait(<Future<bool>>[completer.future]);
    return completer.future;
  }
  /// Checks if there is an internet connection
  Future<bool> checkInternetConnection() async{
    final bool hasConnection = await DataConnectionChecker().hasConnection;
    return Future<bool>.value(hasConnection);
  }

  /// Logs the currently logged in user out
  void logout() {
    _api.account.logout().listen((dynamic _) {
      _loggedIn.add(false);
    });
  }
  /// Updates the mode of the weekplan
  void setMode(WeekplanMode mode) {
    _mode.add(mode);
  }

  /// Set status of last login attempt
  void setAttempt(bool attempt){
    _loginAttempt.add(attempt);
  }

  @override
  void dispose() {
    _loggedIn.close();
    _mode.close();
    _loginAttempt.close();
  }
}