import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/features/auth/presentation/auth_cubit.dart';
import 'package:weekplanner/features/auth/presentation/views/login_view.dart';
import 'package:weekplanner/features/organisation_picker/presentation/organisation_picker_cubit.dart';
import 'package:weekplanner/features/organisation_picker/presentation/views/citizen_picker_view.dart';
import 'package:weekplanner/features/organisation_picker/presentation/views/organisation_picker_view.dart';
import 'package:weekplanner/features/weekplan/data/repositories/activity_repository.dart';
import 'package:weekplanner/features/weekplan/data/repositories/pictogram_repository.dart';
import 'package:weekplanner/features/weekplan/presentation/view_models/activity_form_view_model.dart';
import 'package:weekplanner/features/weekplan/presentation/view_models/weekplan_view_model.dart';
import 'package:weekplanner/features/weekplan/presentation/views/activity_form_view.dart';
import 'package:weekplanner/features/weekplan/presentation/views/weekplan_view.dart';

/// Creates the app router with all dependencies injected explicitly.
///
/// Dependencies are passed in rather than read from context so the router
/// can be built once in [main] and handed to the stateless [WeekplannerApp].
GoRouter createRouter({
  required AuthCubit authCubit,
  required Listenable refreshListenable,
  required OrganisationPickerCubit orgPickerCubit,
  required ActivityRepository activityRepo,
  required PictogramRepository pictogramRepo,
}) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final isAuthenticated = authCubit.isAuthenticated;
      final isLoginRoute = state.matchedLocation == '/login';

      if (!isAuthenticated && !isLoginRoute) return '/login';
      if (isAuthenticated && isLoginRoute) return '/organisations';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/organisations',
        builder: (context, state) {
          orgPickerCubit.loadOrganisations();
          return const OrganisationPickerView();
        },
      ),
      GoRoute(
        path: '/organisations/:orgId/citizens',
        redirect: (context, state) {
          final orgId = int.tryParse(state.pathParameters['orgId'] ?? '');
          if (orgId == null) return '/organisations';
          return null;
        },
        builder: (context, state) {
          final orgId = int.parse(state.pathParameters['orgId']!);
          orgPickerCubit.selectOrganisationById(orgId);
          return CitizenPickerView(orgId: orgId);
        },
      ),
      GoRoute(
        path: '/weekplan/:citizenId',
        redirect: (context, state) {
          final citizenId =
              int.tryParse(state.pathParameters['citizenId'] ?? '');
          if (citizenId == null) return '/organisations';
          return null;
        },
        builder: (context, state) {
          final citizenId = int.parse(state.pathParameters['citizenId']!);
          final type = state.uri.queryParameters['type'] ?? 'citizen';
          final isCitizen = type == 'citizen';
          final orgId =
              int.tryParse(state.uri.queryParameters['orgId'] ?? '');
          return ChangeNotifierProvider(
            create: (_) => WeekplanViewModel(
              activityRepository: activityRepo,
              pictogramRepository: pictogramRepo,
              subjectId: citizenId,
              isCitizen: isCitizen,
            )..loadActivities(),
            child: WeekplanView(
                citizenId: citizenId, isCitizen: isCitizen, orgId: orgId),
          );
        },
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) {
              final citizenId =
                  int.parse(state.pathParameters['citizenId']!);
              final type = state.uri.queryParameters['type'] ?? 'citizen';
              final isCitizen = type == 'citizen';
              final orgId =
                  int.tryParse(state.uri.queryParameters['orgId'] ?? '');
              return ChangeNotifierProvider(
                create: (_) => ActivityFormViewModel(
                  activityRepository: activityRepo,
                  pictogramRepository: pictogramRepo,
                  subjectId: citizenId,
                  isCitizen: isCitizen,
                  organizationId: orgId,
                  initialDate: DateTime.now(),
                ),
                child: const ActivityFormView(
                  title: 'Tilføj aktivitet',
                  submitLabel: 'Tilføj',
                ),
              );
            },
          ),
          GoRoute(
            path: 'edit/:actId',
            redirect: (context, state) {
              final actId =
                  int.tryParse(state.pathParameters['actId'] ?? '');
              if (actId == null) return '/organisations';
              return null;
            },
            builder: (context, state) {
              final citizenId =
                  int.parse(state.pathParameters['citizenId']!);
              final type = state.uri.queryParameters['type'] ?? 'citizen';
              final isCitizen = type == 'citizen';
              final orgId =
                  int.tryParse(state.uri.queryParameters['orgId'] ?? '');
              final actId = int.parse(state.pathParameters['actId']!);
              final existing = activityRepo.activities
                  .where((a) => a.activityId == actId)
                  .firstOrNull;
              return ChangeNotifierProvider(
                create: (_) => ActivityFormViewModel(
                  activityRepository: activityRepo,
                  pictogramRepository: pictogramRepo,
                  existingActivity: existing,
                  subjectId: citizenId,
                  isCitizen: isCitizen,
                  organizationId: orgId,
                  initialDate: DateTime.now(),
                ),
                child: const ActivityFormView(
                  title: 'Rediger aktivitet',
                  submitLabel: 'Gem ændringer',
                ),
              );
            },
          ),
        ],
      ),
    ],
  );
}

/// Root widget of the Weekplanner app.
class WeekplannerApp extends StatelessWidget {
  const WeekplannerApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GIRAF Ugeplan',
      theme: girafTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
