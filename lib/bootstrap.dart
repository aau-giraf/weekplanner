import 'package:injector/injector.dart';
import 'package:weekplanner/blocs/activity_bloc.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/choose_citizen_bloc.dart';
import 'package:weekplanner/blocs/copy_weekplan_bloc.dart';
import 'package:weekplanner/blocs/edit_weekplan_bloc.dart';
import 'package:weekplanner/blocs/new_citizen_bloc.dart';
import 'package:weekplanner/blocs/new_weekplan_bloc.dart';
import 'package:weekplanner/blocs/pictogram_bloc.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/blocs/take_image_with_camera_bloc.dart';
import 'package:weekplanner/blocs/upload_from_gallery_bloc.dart';
import 'package:weekplanner/blocs/timer_bloc.dart';
import 'package:weekplanner/blocs/weekplan_selector_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/blocs/add_activity_bloc.dart';
import 'package:weekplanner/blocs/weekplan_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:api_client/api/api.dart';
import 'package:weekplanner/providers/environment_provider.dart' as environment;
import 'package:weekplanner/blocs/copy_activities_bloc.dart';
import 'package:weekplanner/blocs/copy_resolve_bloc.dart';

/// Bootstrap the project
class Bootstrap {
  /// Register all dependencies here. Here the construction of everything that
  /// can be injected with the container.
  ///
  /// NB:
  /// Singleton restricts the instantiation of a class to one 'single' instance
  static void register() {
    final Injector i = Injector();
    di.registerSingleton(() {
      return Api(environment.getVar('SERVER_HOST'));
    });

    di.registerSingleton<AuthBloc>(() {

      return AuthBloc(i.get<Api>());
    });

    di.registerDependency<WeekplanBloc>(() {
      return WeekplanBloc(i.get<Api>());
    });

    di.registerDependency<WeekplansBloc>(() {
      return WeekplansBloc(i.get<Api>());
    });

    di.registerDependency<ToolbarBloc>(() {
      return ToolbarBloc();
    });
    di.registerDependency<ChooseCitizenBloc>(() {
      return ChooseCitizenBloc(i.get<Api>());
    });

    di.registerDependency<PictogramBloc>(() {
      return PictogramBloc(i.get<Api>());
    });

    di.registerDependency<PictogramImageBloc>(() {
      return PictogramImageBloc(i.get<Api>());
    });

    di.registerSingleton<NewWeekplanBloc>(() {
      return NewWeekplanBloc(i.get<Api>());
    });

    di.registerSingleton<NewCitizenBloc>(() {
      return NewCitizenBloc(i.get<Api>());
    });

    di.registerDependency<EditWeekplanBloc>(() {
      return EditWeekplanBloc(i.get<Api>());
    });

    di.registerDependency<AddActivityBloc>(() {
      return AddActivityBloc();
    });

    di.registerDependency<ActivityBloc>(() {
      return ActivityBloc(i.get<Api>());
    });

    di.registerDependency<SettingsBloc>(() {
      return SettingsBloc(i.get());
    });

    di.registerDependency<UploadFromGalleryBloc>(() {
      return UploadFromGalleryBloc(i.get<Api>());
    });

    di.registerDependency<CopyActivitiesBloc>(() {
      return CopyActivitiesBloc();
    });

    di.registerDependency<TimerBloc>(() {
      return TimerBloc(i.get<Api>());
    });

    di.registerDependency<CopyWeekplanBloc>(() {
      return CopyWeekplanBloc(i.get<Api>());
    });

    di.registerDependency<CopyResolveBloc>(() {
      return CopyResolveBloc(i.get<Api>());
    });

    di.registerDependency<TakePictureWithCameraBloc>(() {
      return TakePictureWithCameraBloc(i.get<Api>());
    });

  }
}
