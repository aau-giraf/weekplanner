import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:weekplanner/app.dart';
import 'package:weekplanner/core/routing/go_router_refresh_stream.dart';
import 'package:weekplanner/features/auth/data/repositories/auth_repository.dart';
import 'package:weekplanner/features/auth/presentation/auth_cubit.dart';
import 'package:weekplanner/features/auth/presentation/login_cubit.dart';
import 'package:weekplanner/features/organisation_picker/data/repositories/organisation_repository.dart';
import 'package:weekplanner/features/organisation_picker/presentation/organisation_picker_cubit.dart';
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
  final authRepository = AuthRepository(authService: authService);
  final organisationRepository = OrganisationRepository(
    coreApiService: coreApiService,
  );
  final activityRepository = ActivityRepository(
    apiService: activityApiService,
  );
  final pictogramRepository = PictogramRepository(
    coreApiService: coreApiService,
  );

  // Auth cubit + router refresh adapter
  final authCubit = AuthCubit(
    repository: authRepository,
    coreApiService: coreApiService,
    activityApiService: activityApiService,
  );
  final refreshListenable = GoRouterRefreshStream(authCubit.stream);

  // Try to restore session
  authCubit.tryRestoreSession();

  // Organisation picker cubit
  final orgPickerCubit = OrganisationPickerCubit(
    repository: organisationRepository,
  );

  final router = createRouter(
    authCubit: authCubit,
    refreshListenable: refreshListenable,
    orgPickerCubit: orgPickerCubit,
    activityRepo: activityRepository,
    pictogramRepo: pictogramRepository,
  );

  runApp(
    MultiProvider(
      providers: [
        // Services
        Provider.value(value: authService),
        Provider.value(value: coreApiService),
        Provider.value(value: activityApiService),

        // Auth (BLoC)
        BlocProvider.value(value: authCubit),
        BlocProvider(
          create: (_) => LoginCubit(
            authRepository: authRepository,
            authCubit: authCubit,
          ),
        ),

        // Organisation picker (BLoC)
        BlocProvider.value(value: orgPickerCubit),

        // Repositories (still ChangeNotifier — migrated in later branches)
        ChangeNotifierProvider.value(value: activityRepository),
        ChangeNotifierProvider.value(value: pictogramRepository),
      ],
      child: WeekplannerApp(router: router),
    ),
  );
}
