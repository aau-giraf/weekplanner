import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/features/auth/data/repositories/auth_repository.dart';
import 'package:weekplanner/features/auth/presentation/views/login_view.dart';
import 'package:weekplanner/features/organisation_picker/presentation/views/citizen_picker_view.dart';
import 'package:weekplanner/features/organisation_picker/presentation/views/organisation_picker_view.dart';
import 'package:weekplanner/features/weekplan/data/repositories/activity_repository.dart';
import 'package:weekplanner/features/weekplan/data/repositories/pictogram_repository.dart';
import 'package:weekplanner/features/weekplan/presentation/view_models/activity_form_view_model.dart';
import 'package:weekplanner/features/weekplan/presentation/view_models/weekplan_view_model.dart';
import 'package:weekplanner/features/weekplan/presentation/views/add_activity_view.dart';
import 'package:weekplanner/features/weekplan/presentation/views/edit_activity_view.dart';
import 'package:weekplanner/features/weekplan/presentation/views/weekplan_view.dart';

class WeekplannerApp extends StatefulWidget {
  const WeekplannerApp({super.key});

  @override
  State<WeekplannerApp> createState() => _WeekplannerAppState();
}

class _WeekplannerAppState extends State<WeekplannerApp> {
  late final GoRouter _router;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  GoRouter _createRouter(AuthRepository authRepo) {
    return GoRouter(
      initialLocation: '/login',
      refreshListenable: authRepo,
      redirect: (context, state) {
        final isAuthenticated = authRepo.isAuthenticated;
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
          builder: (context, state) => const OrganisationPickerView(),
        ),
        GoRoute(
          path: '/organisations/:orgId/citizens',
          builder: (context, state) {
            final orgId = int.parse(state.pathParameters['orgId']!);
            return CitizenPickerView(orgId: orgId);
          },
        ),
        GoRoute(
          path: '/weekplan/:citizenId',
          builder: (context, state) {
            final citizenId = int.parse(state.pathParameters['citizenId']!);
            final type = state.uri.queryParameters['type'] ?? 'citizen';
            final isCitizen = type == 'citizen';
            return ChangeNotifierProvider(
              create: (_) => WeekplanViewModel(
                activityRepository: context.read<ActivityRepository>(),
                pictogramRepository: context.read<PictogramRepository>(),
                subjectId: citizenId,
                isCitizen: isCitizen,
              ),
              child: WeekplanView(citizenId: citizenId, isCitizen: isCitizen),
            );
          },
          routes: [
            GoRoute(
              path: 'add',
              builder: (context, state) {
                final citizenId = int.parse(state.pathParameters['citizenId']!);
                final type = state.uri.queryParameters['type'] ?? 'citizen';
                final isCitizen = type == 'citizen';
                return ChangeNotifierProvider(
                  create: (_) => ActivityFormViewModel(
                    activityRepository: context.read<ActivityRepository>(),
                    pictogramRepository: context.read<PictogramRepository>(),
                    subjectId: citizenId,
                    isCitizen: isCitizen,
                    initialDate: DateTime.now(),
                  ),
                  child: const AddActivityView(),
                );
              },
            ),
            GoRoute(
              path: 'edit/:actId',
              builder: (context, state) {
                final citizenId = int.parse(state.pathParameters['citizenId']!);
                final type = state.uri.queryParameters['type'] ?? 'citizen';
                final isCitizen = type == 'citizen';
                final activityRepo = context.read<ActivityRepository>();
                final actId = int.parse(state.pathParameters['actId']!);
                final existing = activityRepo.activities
                    .where((a) => a.activityId == actId)
                    .firstOrNull;
                return ChangeNotifierProvider(
                  create: (_) => ActivityFormViewModel(
                    activityRepository: activityRepo,
                    pictogramRepository: context.read<PictogramRepository>(),
                    existingActivity: existing,
                    subjectId: citizenId,
                    isCitizen: isCitizen,
                    initialDate: DateTime.now(),
                  ),
                  child: const EditActivityView(),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final authRepo = context.read<AuthRepository>();
    _router = _createRouter(authRepo);
    return MaterialApp.router(
      title: 'GIRAF Ugeplan',
      theme: girafTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
