import 'package:api_client/api/api.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/giraf_theme_enum.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:rxdart/rxdart.dart' as RxDart;
import 'package:weekplanner/blocs/bloc_base.dart';

/// Bloc to get settings for a user
/// Set settings, and listen for changes in them.
class SettingsBloc extends BlocBase {
  /// Default constructor
  SettingsBloc(this._api);

  final Api _api;

  /// Settings stream
  Stream<SettingsModel> get settings => _settings.stream;

  /// Currently selected theme
  Stream<GirafTheme> get theme => _theme.stream;

  /// List of available themes
  Stream<List<GirafTheme>> get themeList => _themeList.stream;
  final RxDart.BehaviorSubject<List<GirafTheme>> _themeList =
      RxDart.BehaviorSubject<List<GirafTheme>>.seeded(<GirafTheme>[]);

  final RxDart.BehaviorSubject<GirafTheme> _theme =
      RxDart.BehaviorSubject<GirafTheme>.seeded(null);

  final RxDart.BehaviorSubject<SettingsModel> _settings =
      RxDart.BehaviorSubject<SettingsModel>();

  /// Load the settings for a user
  void loadSettings(DisplayNameModel user) {
    _api.user.getSettings(user.id).listen((SettingsModel settingsModel) {
      _settings.add(settingsModel);
    });
  }

  /// Update an existing settingsModel
  Stream<SettingsModel> updateSettings(
      String userId, SettingsModel settingsModel) {
    return _api.user
        .updateSettings(userId, settingsModel);
  }

  /// Set the theme to be used
  void setTheme(GirafTheme theme) {
    _theme.add(theme);
  }

  @override
  void dispose() {
    _settings.close();
  }
}
