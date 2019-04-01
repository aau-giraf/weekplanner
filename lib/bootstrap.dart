import 'package:injector/injector.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/choose_citizen_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/providers/environment_provider.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/providers/api/api.dart';

/// Bootstrap the project
class Bootstrap {
  /// Register all dependencies here. Here the construction of everything that
  /// can be injected with the container.
  ///
  /// NB:
  /// Singleton restricts the instantiation of a class to one "single" instance
  static Future<void> register() async {
    di.registerSingleton((Injector i) {
      return Api(Environment.getVar('SERVER_HOST'));
    });

    di.registerSingleton((Injector i) {
      return AuthBloc(i.getDependency<Api>());
    });

    di.registerSingleton<SettingsBloc>((_) {
      return SettingsBloc();
    });
    di.registerSingleton<ChooseCitizenBloc>((Injector i) {
      return ChooseCitizenBloc(i.getDependency<Api>());
    });
  }
}
