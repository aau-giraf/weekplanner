import 'package:api_client/api/api.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:api_client/models/username_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';

import '../di.dart';

/// Bloc to get settings for a user
/// Set settings, and listen for changes in them.
class SettingsBloc extends BlocBase {

  /// Default constructor
  SettingsBloc(this._api);

  final Api _api;
  UsernameModel _user;

  /// Loads all settings for a given [user]
  void load(UsernameModel user) {
    _api.user.get(_user.id);
  }

  Observable<SettingsModel> get settings => _settings.stream;

  BehaviorSubject<SettingsModel> _settings =
  BehaviorSubject<SettingsModel>();

  void loadSettings(SettingsModel settings, UsernameModel user) {
    _settings = _api.user.getSettings(user.id);
  }


  @override
  void dispose() {
    // TODO: implement dispose
  }

}


/*
  /// Currently selected theme
  Stream<GirafTheme> get theme => _theme.stream;

  /// List of available themes
  Stream<List<GirafTheme>> get themeList => _themeList.stream;

  final BehaviorSubject<List<GirafTheme>> _themeList =
      BehaviorSubject<List<GirafTheme>>.seeded(<GirafTheme>[]);

  final BehaviorSubject<GirafTheme> _theme =
      BehaviorSubject<GirafTheme>.seeded(null);

  /// Set the theme to be used
  void setTheme(GirafTheme theme) {
    _theme.add(theme);
  }

  @override
  void dispose() {}
}

*/