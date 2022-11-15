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
  void register(Api api) {

    di.registerSingleton(() {
      return Api(environment.getVar('SERVER_HOST'));
    });

    di.registerSingleton<AuthBloc>(() {

      return AuthBloc(api);
    });

    di.registerDependency<WeekplanBloc>(() {
      return WeekplanBloc(api);
    });

    di.registerDependency<WeekplansBloc>(() {
      return WeekplansBloc(api);
    });

    di.registerDependency<ToolbarBloc>(() {
      return ToolbarBloc();
    });
    di.registerDependency<ChooseCitizenBloc>(() {
      return ChooseCitizenBloc(api);
    });

    di.registerDependency<PictogramBloc>(() {
      return PictogramBloc(api);
    });

    di.registerDependency<PictogramImageBloc>(() {
      return PictogramImageBloc(api);
    });

    di.registerSingleton<NewWeekplanBloc>(() {
      return NewWeekplanBloc(api);
    });

    di.registerSingleton<NewCitizenBloc>(() {
      return NewCitizenBloc(api);
    });

    di.registerDependency<EditWeekplanBloc>(() {
      return EditWeekplanBloc(api);
    });

    di.registerDependency<AddActivityBloc>(() {
      return AddActivityBloc();
    });

    di.registerDependency<ActivityBloc>(() {
      return ActivityBloc(api);
    });

    di.registerDependency<SettingsBloc>(() {
      return SettingsBloc(api);
    });

    di.registerDependency<UploadFromGalleryBloc>(() {
      return UploadFromGalleryBloc(api);
    });

    di.registerDependency<CopyActivitiesBloc>(() {
      return CopyActivitiesBloc();
    });

    di.registerDependency<TimerBloc>(() {
      return TimerBloc(api);
    });

    di.registerDependency<CopyWeekplanBloc>(() {
      return CopyWeekplanBloc(api);
    });

    di.registerDependency<CopyResolveBloc>(() {
      return CopyResolveBloc(api);
    });

    di.registerDependency<TakePictureWithCameraBloc>(() {
      return TakePictureWithCameraBloc(api);
    });

  }
}
