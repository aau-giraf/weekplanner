import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekplanner/app.dart';
import 'package:weekplanner/features/auth/data/repositories/auth_repository.dart';
import 'package:weekplanner/features/auth/presentation/view_models/login_view_model.dart';
import 'package:weekplanner/features/organisation_picker/data/repositories/organisation_repository.dart';
import 'package:weekplanner/features/organisation_picker/presentation/view_models/organisation_picker_view_model.dart';
import 'package:weekplanner/features/weekplan/data/repositories/activity_repository.dart';
import 'package:weekplanner/features/weekplan/data/repositories/pictogram_repository.dart';
import 'package:weekplanner/shared/services/activity_api_service.dart';
import 'package:weekplanner/shared/services/auth_service.dart';
import 'package:weekplanner/shared/services/core_api_service.dart';
import 'package:weekplanner/shared/services/log_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLogging();

  // Services
  final authService = AuthService();
  final coreApiService = CoreApiService();
  final activityApiService = ActivityApiService();

  // Repositories
  final authRepository = AuthRepository(
    authService: authService,
    coreApiService: coreApiService,
    activityApiService: activityApiService,
  );
  final organisationRepository = OrganisationRepository(
    coreApiService: coreApiService,
  );
  final activityRepository = ActivityRepository(
    apiService: activityApiService,
  );
  final pictogramRepository = PictogramRepository(
    coreApiService: coreApiService,
  );

  // Try to restore session
  authRepository.tryRestoreSession();

  // ViewModels needed by the router
  final organisationPickerVm = OrganisationPickerViewModel(
    repository: organisationRepository,
  );

  final router = createRouter(
    authRepo: authRepository,
    orgPickerVm: organisationPickerVm,
    activityRepo: activityRepository,
    pictogramRepo: pictogramRepository,
  );

  runApp(
    MultiProvider(
      providers: [
        // Services (available for DI)
        Provider.value(value: authService),
        Provider.value(value: coreApiService),
        Provider.value(value: activityApiService),

        // Repositories
        ChangeNotifierProvider.value(value: authRepository),
        ChangeNotifierProvider.value(value: organisationRepository),
        ChangeNotifierProvider.value(value: activityRepository),
        ChangeNotifierProvider.value(value: pictogramRepository),

        // ViewModels
        ChangeNotifierProvider(
          create: (_) => LoginViewModel(authRepository: authRepository),
        ),
        ChangeNotifierProvider.value(value: organisationPickerVm),
      ],
      child: WeekplannerApp(router: router),
    ),
  );
}
