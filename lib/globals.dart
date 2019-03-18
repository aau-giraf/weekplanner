import 'package:weekplanner/blocs/application_bloc.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/providers/api/api.dart';

class Globals {
  static final api = new Api(ServerUrl + ":" + ServerPort);
  static final ApplicationBloc appBloc = ApplicationBloc(authBloc);
  static final AuthBloc authBloc = AuthBloc(api);
  static final SettingsBloc settingsBloc = SettingsBloc();
  // Used for showing debug features
  // such as AutoLogin button
  static bool get isInDebugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

  static final ServerUrl = "http://web.giraf.cs.aau.dk";
  static final ServerPort = "9999";
}
