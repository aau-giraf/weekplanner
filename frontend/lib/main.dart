import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import 'package:weekplanner/app.dart';
import 'package:weekplanner/config/api_config.dart';
import 'package:weekplanner/core/routing/go_router_refresh_stream.dart';
import 'package:weekplanner/features/auth/data/repositories/auth_repository.dart';
import 'package:weekplanner/features/auth/presentation/auth_cubit.dart';
import 'package:weekplanner/features/auth/presentation/login_cubit.dart';
import 'package:weekplanner/features/organisation_picker/data/repositories/organisation_repository.dart';
import 'package:weekplanner/features/organisation_picker/presentation/organisation_picker_cubit.dart';
import 'package:weekplanner/features/weekplan/data/repositories/activity_repository.dart';
import 'package:weekplanner/features/weekplan/data/repositories/pictogram_repository.dart';
import 'package:weekplanner/features/weekplan/domain/repositories/activity_repository.dart';
import 'package:weekplanner/features/weekplan/domain/repositories/pictogram_repository.dart';
import 'package:weekplanner/shared/interceptors/token_refresh_interceptor.dart';
import 'package:weekplanner/shared/services/activity_api_service.dart';
import 'package:weekplanner/shared/services/auth_service.dart';
import 'package:weekplanner/shared/services/log_service.dart';
import 'package:weekplanner/shared/services/organisation_api_service.dart';
import 'package:weekplanner/shared/services/pictogram_api_service.dart';
import 'package:weekplanner/shared/services/token_manager.dart';

Dio _createDio(String baseUrl) => Dio(BaseOptions(
      baseUrl: baseUrl,
      headers: {'Content-Type': 'application/json'},
    ));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLogging();

  // Dio instances — created here so the refresh interceptor can be shared.
  final coreDio = _createDio(ApiConfig.coreBaseUrl);
  final activityDio = _createDio(ApiConfig.weekplannerBaseUrl);

  // AuthService gets its own Dio without the refresh interceptor —
  // login 401s must NOT trigger a token refresh cycle.
  final authDio = _createDio(ApiConfig.coreBaseUrl);
  const storage = FlutterSecureStorage();

  // Services — each focused on one giraf-core domain.
  // OrganisationApiService and PictogramApiService share coreDio.
  final authService = AuthService(dio: authDio, storage: storage);
  final organisationApiService = OrganisationApiService(dio: coreDio);
  final pictogramApiService = PictogramApiService(dio: coreDio);
  final activityApiService = ActivityApiService(dio: activityDio);

  // Repositories
  final authRepository = AuthRepositoryImpl(authService: authService);
  final organisationRepository = OrganisationRepositoryImpl(
    apiService: organisationApiService,
  );
  final activityRepository = ActivityRepositoryImpl(
    apiService: activityApiService,
  );
  final pictogramRepository = PictogramRepositoryImpl(
    apiService: pictogramApiService,
  );

  // Token distribution
  final tokenManager = TokenManager(
    consumers: [organisationApiService, pictogramApiService, activityApiService],
  );

  // Auth cubit + router refresh adapter
  final authCubit = AuthCubit(
    repository: authRepository,
    tokenManager: tokenManager,
  );
  final refreshListenable = GoRouterRefreshStream(authCubit.stream);

  // Token refresh interceptor — handles 401s by refreshing the access token
  // and retrying the failed request. Shared across core and activity Dio.
  final refreshDio = _createDio(ApiConfig.coreBaseUrl);
  final tokenInterceptor = TokenRefreshInterceptor(
    refreshDio: refreshDio,
    storage: storage,
    protectedDios: [coreDio, activityDio],
    onTokenRefreshed: (token) => authCubit.authenticated(token),
    onRefreshFailed: () => authCubit.logout(),
  );
  coreDio.interceptors.add(tokenInterceptor);
  activityDio.interceptors.add(tokenInterceptor);

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
  );

  runApp(
    MultiProvider(
      providers: [
        // Services
        Provider.value(value: authService),
        Provider.value(value: organisationApiService),
        Provider.value(value: pictogramApiService),
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

        // Repositories (plain providers — cubits are created in route builders)
        Provider<ActivityRepository>.value(value: activityRepository),
        Provider<PictogramRepository>.value(value: pictogramRepository),
      ],
      child: WeekplannerApp(router: router),
    ),
  );
}
