import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:weekplanner/providers/api/api.dart';

/// All about Authentication. Login, logout, etc.
class AuthBloc extends BlocBase {

  /// Default Constructor
  AuthBloc(this._api);

  Api api;

  /// String is used then changing from citizen to guardian mode
  /// the username is saved so only the password is needed.
  String loggedInUsername;


  final Api _api;

  /// Whether or not the user is logged in
  Stream<bool> get loggedIn => _loggedIn.stream;

  /// Start with providing false as the logged in status
  final BehaviorSubject<bool> _loggedIn = BehaviorSubject<bool>.seeded(false);

  /// Authenticates the user with the given [username] and [password]
  void authenticate(String username, String password) {
    _api.account.login(username, password).take(1).listen((bool status) {
      _loggedIn.add(status);
      loggedInUsername =username;
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
