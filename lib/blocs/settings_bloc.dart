import 'dart:async';
import 'dart:io';

import 'package:api_client/api/api.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/giraf_theme_enum.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:rxdart/rxdart.dart' as rx_dart;
import 'package:weekplanner/blocs/bloc_base.dart';

import 'blocs_api_exceptions.dart';

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
  final rx_dart.BehaviorSubject<List<GirafTheme>> _themeList =
      rx_dart.BehaviorSubject<List<GirafTheme>>.seeded(<GirafTheme>[]);

  final rx_dart.BehaviorSubject<GirafTheme> _theme =
      rx_dart.BehaviorSubject<GirafTheme>.seeded(null);

  final rx_dart.BehaviorSubject<SettingsModel> _settings =
      rx_dart.BehaviorSubject<SettingsModel>();

  /// Load the settings for a user
  void loadSettings(DisplayNameModel user) {
    try{
      _api.user.getSettings(user.id).listen((SettingsModel settingsModel) {
        _settings.add(settingsModel);
      });
    }on SocketException{throw BlocsApiException('Sock');}
    on HttpException{throw BlocsApiException('Http');}
    on TimeoutException{throw BlocsApiException('Time');}
    on FormatException{throw BlocsApiException('Form');}
    on Error catch(error)
    {throw BlocsApiException('spec', '', error);}

  }

  /// Update an existing settingsModel
  Stream<SettingsModel> updateSettings(
      String userId, SettingsModel settingsModel) {
    try{
      return _api.user
          .updateSettings(userId, settingsModel);
    }on SocketException{throw BlocsApiException('Sock');}
    on HttpException{throw BlocsApiException('Http');}
    on TimeoutException{throw BlocsApiException('Time');}
    on FormatException{throw BlocsApiException('Form');}
    on Error catch(error)
    {throw BlocsApiException('spec', '', error);}
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
