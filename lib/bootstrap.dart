import 'package:injector/injector.dart';
import 'package:weekplanner/blocs/activity_bloc.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/choose_citizen_bloc.dart';
import 'package:weekplanner/blocs/new_weekplan_bloc.dart';
import 'package:weekplanner/blocs/pictogram_bloc.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/blocs/weekplans_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/blocs/add_activity_bloc.dart';
import 'package:weekplanner/blocs/weekplan_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:api_client/api/api.dart';
import 'package:weekplanner/providers/environment_provider.dart' as environment;

import 'blocs/timer_bloc.dart';


/// Bootstrap the project
class Bootstrap {
  /// Register all dependencies here. Here the construction of everything that
  /// can be injected with the container.
  ///
  /// NB:
  /// Singleton restricts the instantiation of a class to one 'single' instance
  static void register() {
    di.registerSingleton((_) {
      return Api(environment.getVar('SERVER_HOST'));
    });

    di.registerSingleton((Injector i) {
      return AuthBloc(i.getDependency<Api>());
    });

    di.registerDependency<WeekplanBloc>((Injector i) {
      return WeekplanBloc(i.getDependency<Api>());
    });

    di.registerDependency((Injector i) {
      return WeekplansBloc(i.getDependency<Api>());
    });

    di.registerSingleton<ToolbarBloc>((_) {
      return ToolbarBloc();
    });
    di.registerDependency<ChooseCitizenBloc>((Injector i) {
      return ChooseCitizenBloc(i.getDependency<Api>());
    });

    di.registerDependency<PictogramBloc>((Injector i) {
      return PictogramBloc(i.getDependency<Api>());
    });

    di.registerDependency<PictogramImageBloc>((Injector i) {
      return PictogramImageBloc(i.getDependency<Api>());
    });

    di.registerSingleton<NewWeekplanBloc>((Injector i) {
      return NewWeekplanBloc(i.getDependency<Api>());
    });
    
    di.registerDependency<AddActivityBloc>((_) {
      return AddActivityBloc();
    });

    di.registerDependency<ActivityBloc>((Injector i) {
      return ActivityBloc(i.getDependency<Api>());
    });

    di.registerDependency<SettingsBloc>((Injector i) {
      return SettingsBloc();
    });
  }
}
