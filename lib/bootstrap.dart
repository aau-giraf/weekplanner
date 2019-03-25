import 'package:injector/injector.dart';
import 'package:weekplanner/blocs/application_bloc.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/choose_citizen_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/providers/environment_provider.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/providers/api/api.dart';

class Bootstrap {
  /// Register all dependencies here. Here the construction of everything that
  /// can be injected with the container.
  ///
  /// NB:
  /// Singleton restricts the instantiation of a class to one "single" instance
  static Future<void> register() async {
    di.registerSingleton((Injector i) {
      String host = Environment.getVar("SERVER_HOST");
      return Api(host);
    });

    di.registerSingleton((Injector i) {
      return AuthBloc(i.getDependency<Api>());
    });

    di.registerSingleton<ApplicationBloc>((Injector i) {
      return ApplicationBloc(i.getDependency<AuthBloc>());
    });

    di.registerSingleton<SettingsBloc>((_) {
      return SettingsBloc();
    });
    di.registerSingleton<ChooseCitizenBloc>((Injector i) {
      return ChooseCitizenBloc(i.getDependency<Api>());
    });
  }
}
