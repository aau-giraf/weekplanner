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

  Widget buildSubject() {
    return MaterialApp(
      theme: girafTheme,
      home: BlocProvider<WeekplanCubit>.value(
        value: mockCubit,
        child: const WeekplanView(
          citizenId: 42,
          isCitizen: true,
          orgId: 1,
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
  });
}
