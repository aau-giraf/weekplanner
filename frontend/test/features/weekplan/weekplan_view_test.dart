import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/features/weekplan/domain/weekplan_state.dart';
import 'package:weekplanner/features/weekplan/presentation/views/weekplan_view.dart';
import 'package:weekplanner/features/weekplan/presentation/weekplan_cubit.dart';
import 'package:weekplanner/shared/models/activity.dart';

class MockWeekplanCubit extends MockCubit<WeekplanState>
    implements WeekplanCubit {}

void main() {
  late MockWeekplanCubit mockCubit;

  final testDate = DateTime(2026, 3, 22);
  final testWeekDates = List.generate(7, (i) => testDate.subtract(Duration(days: testDate.weekday - 1 - i)));

  setUp(() {
    mockCubit = MockWeekplanCubit();
    when(() => mockCubit.weekNumber).thenReturn(12);
  });

  Widget buildSubject({String? subjectName}) {
    return MaterialApp(
      theme: girafTheme,
      home: BlocProvider<WeekplanCubit>.value(
        value: mockCubit,
        child: WeekplanView(
          citizenId: 42,
          isCitizen: true,
          orgId: 1,
          subjectName: subjectName,
        ),
      ),
    );
  }

  group('WeekplanView', () {
    testWidgets('shows CircularProgressIndicator in loading state',
        (tester) async {
      when(() => mockCubit.state).thenReturn(WeekplanLoading(
        selectedDate: testDate,
        weekDates: testWeekDates,
      ));

      await tester.pumpWidget(buildSubject());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows activity list items when loaded with activities',
        (tester) async {
      final activities = [
        Activity(
          activityId: 1,
          date: DateTime(2026, 3, 22),
          startTime: const (hour: 8, minute: 0),
          endTime: const (hour: 9, minute: 0),
        ),
        Activity(
          activityId: 2,
          date: DateTime(2026, 3, 22),
          startTime: const (hour: 10, minute: 0),
          endTime: const (hour: 11, minute: 0),
        ),
      ];
      when(() => mockCubit.state).thenReturn(WeekplanLoaded(
        selectedDate: testDate,
        weekDates: testWeekDates,
        activities: activities,
      ));

      await tester.pumpWidget(buildSubject());

      // Both activity items should be visible
      expect(find.text('08:00 - 09:00'), findsOneWidget);
      expect(find.text('10:00 - 11:00'), findsOneWidget);
    });

    testWidgets('shows empty message when loaded with no activities',
        (tester) async {
      when(() => mockCubit.state).thenReturn(WeekplanLoaded(
        selectedDate: testDate,
        weekDates: testWeekDates,
        activities: const [],
      ));

      await tester.pumpWidget(buildSubject());

      expect(find.byIcon(Icons.event_busy), findsOneWidget);
    });

    testWidgets('shows error message and retry button in error state',
        (tester) async {
      when(() => mockCubit.state).thenReturn(WeekplanError(
        message: 'Netværksfejl',
        selectedDate: testDate,
        weekDates: testWeekDates,
      ));

      await tester.pumpWidget(buildSubject());

      expect(find.text('Netværksfejl'), findsOneWidget);
      expect(find.text('Prøv igen'), findsOneWidget);
    });

    testWidgets('tapping retry calls loadActivities', (tester) async {
      when(() => mockCubit.state).thenReturn(WeekplanError(
        message: 'Fejl',
        selectedDate: testDate,
        weekDates: testWeekDates,
      ));
      when(() => mockCubit.loadActivities()).thenAnswer((_) async {});

      await tester.pumpWidget(buildSubject());
      await tester.tap(find.text('Prøv igen'));

      verify(() => mockCubit.loadActivities()).called(1);
    });

    testWidgets('shows citizen name in app bar when provided', (tester) async {
      when(() => mockCubit.state).thenReturn(WeekplanLoading(
        selectedDate: testDate,
        weekDates: testWeekDates,
      ));

      await tester.pumpWidget(buildSubject(subjectName: 'Anders'));

      expect(find.text('Ugeplan — Anders'), findsOneWidget);
    });

    testWidgets('shows generic title when no citizen name', (tester) async {
      when(() => mockCubit.state).thenReturn(WeekplanLoading(
        selectedDate: testDate,
        weekDates: testWeekDates,
      ));

      await tester.pumpWidget(buildSubject());

      expect(find.text('Ugeplan'), findsOneWidget);
    });

    testWidgets('delete via selection mode shows confirmation dialog',
        (tester) async {
      final activities = [
        Activity(
          activityId: 1,
          date: DateTime(2026, 3, 22),
          title: 'Morgenmad',
        ),
      ];
      when(() => mockCubit.state).thenReturn(WeekplanLoaded(
        selectedDate: testDate,
        weekDates: testWeekDates,
        activities: activities,
      ));

      await tester.pumpWidget(buildSubject());

      // Long-press to enter selection mode (auto-selects the activity)
      await tester.longPress(find.text('Morgenmad'));
      await tester.pumpAndSettle();

      // Tap "Slet" in the selection action bar
      await tester.tap(find.text('Slet'));
      await tester.pumpAndSettle();

      // Confirmation dialog should appear
      expect(find.text('Slet aktiviteter'), findsOneWidget);
      expect(find.text('Annuller'), findsOneWidget);
    });

    testWidgets('delete confirmation confirm hides activity and shows undo snackbar',
        (tester) async {
      final activity = Activity(
        activityId: 1,
        date: DateTime(2026, 3, 22),
        title: 'Morgenmad',
      );
      when(() => mockCubit.state).thenReturn(WeekplanLoaded(
        selectedDate: testDate,
        weekDates: testWeekDates,
        activities: [activity],
      ));
      when(() => mockCubit.hideActivity(any())).thenReturn(activity);

      await tester.pumpWidget(buildSubject());

      // Long-press → select → Slet → confirm
      await tester.longPress(find.text('Morgenmad'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Slet'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Slet').last);
      await tester.pumpAndSettle();

      verify(() => mockCubit.hideActivity(1)).called(1);
      // Undo snackbar should be visible
      expect(find.text('Fortryd'), findsOneWidget);
    });

    testWidgets('tapping undo in snackbar restores activity',
        (tester) async {
      final activity = Activity(
        activityId: 1,
        date: DateTime(2026, 3, 22),
        title: 'Morgenmad',
      );
      when(() => mockCubit.state).thenReturn(WeekplanLoaded(
        selectedDate: testDate,
        weekDates: testWeekDates,
        activities: [activity],
      ));
      when(() => mockCubit.hideActivity(any())).thenReturn(activity);

      await tester.pumpWidget(buildSubject());

      // Long-press → select → Slet → confirm
      await tester.longPress(find.text('Morgenmad'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Slet'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Slet').last);
      await tester.pumpAndSettle();

      // Tap undo
      await tester.tap(find.text('Fortryd'));
      await tester.pumpAndSettle();

      verify(() => mockCubit.restoreActivity(activity)).called(1);
    });

    testWidgets('delete confirmation cancel does not delete', (tester) async {
      final activities = [
        Activity(
          activityId: 1,
          date: DateTime(2026, 3, 22),
          title: 'Morgenmad',
        ),
      ];
      when(() => mockCubit.state).thenReturn(WeekplanLoaded(
        selectedDate: testDate,
        weekDates: testWeekDates,
        activities: activities,
      ));

      await tester.pumpWidget(buildSubject());

      // Long-press → select → Slet → cancel
      await tester.longPress(find.text('Morgenmad'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Slet'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Annuller'));
      await tester.pumpAndSettle();

      // hideActivity should NOT have been called
      verifyNever(() => mockCubit.hideActivity(any()));
    });

    testWidgets('shows week view toggle button', (tester) async {
      when(() => mockCubit.state).thenReturn(WeekplanLoading(
        selectedDate: testDate,
        weekDates: testWeekDates,
      ));

      await tester.pumpWidget(buildSubject());

      expect(find.byIcon(Icons.view_week), findsOneWidget);
      expect(find.byTooltip('Ugeoversigt'), findsOneWidget);
    });

    testWidgets('tapping toggle switches to week view and calls loadWeekActivities',
        (tester) async {
      when(() => mockCubit.state).thenReturn(WeekplanLoaded(
        selectedDate: testDate,
        weekDates: testWeekDates,
        activities: const [],
        weekActivities: const {},
      ));
      when(() => mockCubit.loadWeekActivities())
          .thenAnswer((_) async {});

      await tester.pumpWidget(buildSubject());

      await tester.tap(find.byIcon(Icons.view_week));
      await tester.pump();

      verify(() => mockCubit.loadWeekActivities()).called(1);
      // Icon should switch to day view
      expect(find.byIcon(Icons.view_day), findsOneWidget);
    });
    testWidgets('long-press enters selection mode with checkboxes',
        (tester) async {
      final activities = [
        Activity(
          activityId: 1,
          date: DateTime(2026, 3, 22),
          title: 'Morgenmad',
        ),
        Activity(
          activityId: 2,
          date: DateTime(2026, 3, 22),
          title: 'Frokost',
        ),
      ];
      when(() => mockCubit.state).thenReturn(WeekplanLoaded(
        selectedDate: testDate,
        weekDates: testWeekDates,
        activities: activities,
      ));

      await tester.pumpWidget(buildSubject());

      // Long-press first activity
      await tester.longPress(find.text('Morgenmad'));
      await tester.pumpAndSettle();

      // Selection mode indicators
      expect(find.text('1 valgt'), findsOneWidget);
      expect(find.text('Vælg alle'), findsOneWidget);
      expect(find.byType(Checkbox), findsWidgets);
    });

    testWidgets('Rediger button is enabled when exactly one activity selected',
        (tester) async {
      final activities = [
        Activity(
          activityId: 1,
          date: DateTime(2026, 3, 22),
          title: 'Morgenmad',
        ),
        Activity(
          activityId: 2,
          date: DateTime(2026, 3, 22),
          title: 'Frokost',
        ),
      ];
      when(() => mockCubit.state).thenReturn(WeekplanLoaded(
        selectedDate: testDate,
        weekDates: testWeekDates,
        activities: activities,
      ));

      await tester.pumpWidget(buildSubject());

      await tester.longPress(find.text('Morgenmad'));
      await tester.pumpAndSettle();

      final rediger = find.widgetWithText(TextButton, 'Rediger');
      expect(rediger, findsOneWidget);
      expect(tester.widget<TextButton>(rediger).onPressed, isNotNull);
    });

    testWidgets('Rediger button is disabled when multiple activities selected',
        (tester) async {
      final activities = [
        Activity(
          activityId: 1,
          date: DateTime(2026, 3, 22),
          title: 'Morgenmad',
        ),
        Activity(
          activityId: 2,
          date: DateTime(2026, 3, 22),
          title: 'Frokost',
        ),
      ];
      when(() => mockCubit.state).thenReturn(WeekplanLoaded(
        selectedDate: testDate,
        weekDates: testWeekDates,
        activities: activities,
      ));

      await tester.pumpWidget(buildSubject());

      await tester.longPress(find.text('Morgenmad'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Vælg alle'));
      await tester.pumpAndSettle();

      final rediger = find.widgetWithText(TextButton, 'Rediger');
      expect(rediger, findsOneWidget);
      expect(tester.widget<TextButton>(rediger).onPressed, isNull);
    });

    testWidgets('close button exits selection mode', (tester) async {
      final activities = [
        Activity(
          activityId: 1,
          date: DateTime(2026, 3, 22),
          title: 'Morgenmad',
        ),
      ];
      when(() => mockCubit.state).thenReturn(WeekplanLoaded(
        selectedDate: testDate,
        weekDates: testWeekDates,
        activities: activities,
      ));

      await tester.pumpWidget(buildSubject());

      // Enter selection mode
      await tester.longPress(find.text('Morgenmad'));
      await tester.pumpAndSettle();
      expect(find.text('1 valgt'), findsOneWidget);

      // Close selection
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Back to normal mode
      expect(find.text('1 valgt'), findsNothing);
    });
  });
}
