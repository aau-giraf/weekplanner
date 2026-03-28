import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
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
import 'package:weekplanner/features/weekplan/domain/repositories/activity_repository.dart';
import 'package:weekplanner/features/weekplan/domain/repositories/pictogram_repository.dart';
import 'package:weekplanner/shared/models/auth_tokens.dart';
import 'package:weekplanner/shared/models/citizen.dart';
import 'package:weekplanner/shared/models/grade.dart';
import 'package:weekplanner/shared/models/organisation.dart';
import 'package:weekplanner/shared/models/paginated_response.dart';
import 'package:weekplanner/shared/services/activity_api_service.dart';
import 'package:weekplanner/shared/services/auth_service.dart';
import 'package:weekplanner/shared/services/core_api_service.dart';
import 'package:weekplanner/shared/services/token_manager.dart';

import '../test/helpers/jwt_test_helper.dart';

class _MockAuthService extends Mock implements AuthService {}

class _MockCoreApiService extends Mock implements CoreApiService {}

class _MockActivityApiService extends Mock implements ActivityApiService {}

class _MockTokenManager extends Mock implements TokenManager {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late _MockAuthService mockAuthService;
  late _MockCoreApiService mockCoreApiService;
  late _MockActivityApiService mockActivityApiService;
  late _MockTokenManager mockTokenManager;

  setUp(() {
    mockAuthService = _MockAuthService();
    mockCoreApiService = _MockCoreApiService();
    mockActivityApiService = _MockActivityApiService();
    mockTokenManager = _MockTokenManager();

    // Default stubs: no stored session
    when(() => mockAuthService.getStoredAccessToken())
        .thenAnswer((_) async => null);
    when(() => mockAuthService.getSavedCredentials())
        .thenAnswer((_) async => (email: null, password: null));
  });

  /// Builds the full app with mocked services, mirroring [main.dart].
  Widget buildApp() {
    final authRepository = AuthRepositoryImpl(authService: mockAuthService);
    final organisationRepository =
        OrganisationRepositoryImpl(coreApiService: mockCoreApiService);
    final activityRepository =
        ActivityRepositoryImpl(apiService: mockActivityApiService);
    final pictogramRepository =
        PictogramRepositoryImpl(coreApiService: mockCoreApiService);

    final authCubit = AuthCubit(
      repository: authRepository,
      tokenManager: mockTokenManager,
    );
    final refreshListenable = GoRouterRefreshStream(authCubit.stream);
    final orgPickerCubit =
        OrganisationPickerCubit(repository: organisationRepository);

    authCubit.tryRestoreSession();

    final router = createRouter(
      authCubit: authCubit,
      refreshListenable: refreshListenable,
      orgPickerCubit: orgPickerCubit,
    );

    return MultiProvider(
      providers: [
        Provider<AuthService>.value(value: mockAuthService),
        Provider<CoreApiService>.value(value: mockCoreApiService),
        Provider<ActivityApiService>.value(value: mockActivityApiService),
        BlocProvider<AuthCubit>.value(value: authCubit),
        BlocProvider<LoginCubit>(
          create: (_) => LoginCubit(
            authRepository: authRepository,
            authCubit: authCubit,
          ),
        ),
        BlocProvider<OrganisationPickerCubit>.value(value: orgPickerCubit),
        Provider<ActivityRepository>.value(value: activityRepository),
        Provider<PictogramRepository>.value(value: pictogramRepository),
      ],
      child: WeekplannerApp(router: router),
    );
  }

  testWidgets('login → organisations → citizens → weekplan flow',
      (tester) async {
    // Arrange: stub a successful login
    final jwt = createValidJwt();
    when(() => mockAuthService.login(any(), any())).thenAnswer(
      (_) async => AuthTokens(
        access: jwt,
        refresh: 'refresh-token',
        orgRoles: {'1': 'admin'},
      ),
    );
    when(() => mockAuthService.clearSavedCredentials())
        .thenAnswer((_) async {});
    when(() => mockAuthService.logout()).thenAnswer((_) async {});

    // Stub organisations
    when(() => mockCoreApiService.fetchOrganisations()).thenAnswer(
      (_) async => PaginatedResponse(
        items: [const Organisation(id: 1, name: 'Test Org')],
        count: 1,
      ),
    );

    // Stub citizens + grades for org 1
    when(() => mockCoreApiService.fetchCitizens(1)).thenAnswer(
      (_) async => PaginatedResponse(
        items: [
          const Citizen(id: 10, firstName: 'Anders', lastName: 'Hansen'),
        ],
        count: 1,
      ),
    );
    when(() => mockCoreApiService.fetchGrades(1)).thenAnswer(
      (_) async => PaginatedResponse<Grade>(items: [], count: 0),
    );

    // Stub token propagation (called by AuthCubit.authenticated via TokenManager)
    when(() => mockTokenManager.setToken(any())).thenReturn(null);

    // Stub activities for citizen 10 (any date string)
    when(() => mockActivityApiService.fetchActivitiesByCitizen(10, any()))
        .thenAnswer((_) async => []);

    // Act: launch app
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    // Assert: login screen is shown
    expect(find.text('Log ind'), findsOneWidget);

    // Enter email and password
    final textFields = find.byType(TextField);
    await tester.enterText(textFields.first, 'test@test.dk');
    await tester.enterText(textFields.last, 'password');

    // Submit
    await tester.tap(find.text('Log ind'));
    await tester.pumpAndSettle();

    // Assert: redirected to organisations
    expect(find.text('Test Org'), findsOneWidget);

    // Tap the organisation
    await tester.tap(find.text('Test Org'));
    await tester.pumpAndSettle();

    // Assert: citizen list shown
    expect(find.text('Anders Hansen'), findsOneWidget);

    // Tap the citizen
    await tester.tap(find.text('Anders Hansen'));
    await tester.pumpAndSettle();

    // Assert: weekplan screen shown
    expect(find.text('Ugeplan'), findsOneWidget);
  });
}
