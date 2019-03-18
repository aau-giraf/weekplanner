import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:weekplanner/providers/api/api.dart';

class AuthBloc extends BlocBase {
  Api api;

  AuthBloc(this.api);

  Stream<bool> get loggedIn => _loggedIn.stream;

  BehaviorSubject<bool> _loggedIn = BehaviorSubject.seeded(false);

  void authenticate(String username, String password) {
    api.account.login(username, password).take(1).listen((status) {
      _loggedIn.add(status);
    });
  }

  void logout() {
    api.account.logout().take(1).listen((status) {
      _loggedIn.add(false);
    });
  }

  @override
  void dispose() {
    _loggedIn.close();
  }
}
