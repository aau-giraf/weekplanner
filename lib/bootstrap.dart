import 'package:injector/injector.dart';
import 'package:weekplanner/blocs/application_bloc.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/blocs/weekplan_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/providers/api/api.dart';

class Bootstrap {
  /// Register all dependencies here. Here the construction of everything that
  /// can be injected with the container.
  ///
  /// NB:
  /// Singleton restricts the instantiation of a class to one "single" instance
  static void register() {
    di.registerSingleton((_) {
      // TODO: move the server URL into .env file
      return Api("http://web.giraf.cs.aau.dk:5000");
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

    di.registerSingleton<WeekplanBloc>((Injector i) {
      return WeekplanBloc(i.getDependency<Api>());
    });

    di.registerDependency<PictogramImageBloc>((Injector i) {
      return PictogramImageBloc(i.getDependency<Api>());
    });
  }
}
