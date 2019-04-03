import 'package:injector/injector.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/new_weekplan_bloc.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/blocs/weekplans_bloc.dart';
import 'package:weekplanner/blocs/pictogram_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/blocs/weekplan_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/providers/api/api.dart';

/// Bootstrap the project
class Bootstrap {
  /// Register all dependencies here. Here the construction of everything that
  /// can be injected with the container.
  ///
  /// NB:
  /// Singleton restricts the instantiation of a class to one "single" instance
  static void register() {
    di.registerSingleton((_) {
      // TODO(boginw): move the server URL into .env file
      return Api('srv.giraf.cs.aau.dk/API/');
    });

    di.registerSingleton((Injector i) {
      return AuthBloc(i.getDependency<Api>());
    });

    di.registerDependency<WeekplanBloc>((Injector i) {
      return WeekplanBloc();
    });

    di.registerDependency((Injector i) {
      return WeekplansBloc(i.getDependency<Api>());
    });
    
    di.registerSingleton<ToolbarBloc>((_) {
      return ToolbarBloc();
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
  }
}
