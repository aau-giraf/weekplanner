import 'package:weekplanner/blocs/application_bloc.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/providers/api/api.dart';

class Globals{
  static final api = new Api("http://web.giraf.cs.aau.dk:5000");
  static final ApplicationBloc appBloc = ApplicationBloc(authBloc);
  static final AuthBloc authBloc = AuthBloc(api);
  static final SettingsBloc settingsBloc = SettingsBloc();
}