import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/features/weekplan/presentation/widgets/week_selector.dart';
import 'package:weekplanner/shared/utils/date_utils.dart';

void main() {
  final weekDates = GirafDateUtils.getWeekDates(DateTime(2026, 3, 23));
  final selectedDate = DateTime(2026, 3, 25);

  Widget buildSubject({
    VoidCallback? onPreviousWeek,
    VoidCallback? onNextWeek,
    VoidCallback? onGoToToday,
    ValueChanged<DateTime>? onSelectDate,
  }) {
    return MaterialApp(
      theme: girafTheme,
      home: Scaffold(
        body: WeekSelector(
          weekNumber: 13,
          weekDates: weekDates,
          selectedDate: selectedDate,
          onPreviousWeek: onPreviousWeek ?? () {},
          onNextWeek: onNextWeek ?? () {},
          onGoToToday: onGoToToday ?? () {},
          onSelectDate: onSelectDate ?? (_) {},
        ),
      ),
    );
  }

  group('WeekSelector', () {
    testWidgets('renders week number pill', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('Uge 13'), findsOneWidget);
    });

    testWidgets('renders a pill for each weekday with short name and date',
        (tester) async {
      await tester.pumpWidget(buildSubject());

      for (var i = 0; i < weekDates.length; i++) {
        final date = weekDates[i];
        final label =
            '${GirafDateUtils.dayNameShort(date.weekday)} ${date.day}';
        expect(find.text(label), findsOneWidget,
            reason: 'Expected chip labelled "$label"');
      }
    });

    testWidgets('tapping a day pill calls onSelectDate with the correct date',
        (tester) async {
      DateTime? captured;
      await tester.pumpWidget(buildSubject(onSelectDate: (d) => captured = d));

      // Tap the Wednesday pill ("Ons 25")
      await tester.tap(find.text('Ons 25'));
      await tester.pump();

      expect(captured, equals(DateTime(2026, 3, 25)));
    });

    testWidgets('tapping chevron_left calls onPreviousWeek', (tester) async {
      var callCount = 0;
      await tester.pumpWidget(buildSubject(onPreviousWeek: () => callCount++));

      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pump();

      expect(callCount, 1);
    });

    testWidgets('tapping chevron_right calls onNextWeek', (tester) async {
      var callCount = 0;
      await tester.pumpWidget(buildSubject(onNextWeek: () => callCount++));

      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pump();

      expect(callCount, 1);
    });

    testWidgets('shows "I dag" pill when not on today', (tester) async {
      // selectedDate is 2026-03-25, which is not today
      await tester.pumpWidget(buildSubject());

      expect(find.text('I dag'), findsOneWidget);
    });

    testWidgets('tapping "I dag" calls onGoToToday', (tester) async {
      var callCount = 0;
      await tester.pumpWidget(buildSubject(onGoToToday: () => callCount++));

      await tester.tap(find.text('I dag'));
      await tester.pump();

      expect(callCount, 1);
    });

    testWidgets('shows today-indicator border on today\'s day chip',
        (tester) async {
      final now = DateTime.now();
      final todayWeekDates = GirafDateUtils.getWeekDates(now);
      final otherDay = todayWeekDates.firstWhere((d) => d.day != now.day);

      await tester.pumpWidget(MaterialApp(
        theme: girafTheme,
        home: Scaffold(
          body: WeekSelector(
            weekNumber: GirafDateUtils.getWeekNumber(now),
            weekDates: todayWeekDates,
            selectedDate: otherDay,
            onPreviousWeek: () {},
            onNextWeek: () {},
            onGoToToday: () {},
            onSelectDate: (_) {},
          ),
        ),
      ));

      final todayLabel =
          '${GirafDateUtils.dayNameShort(now.weekday)} ${now.day}';
      final todayText = find.text(todayLabel);
      expect(todayText, findsOneWidget);

      final container = tester.widget<AnimatedContainer>(
        find
            .ancestor(of: todayText, matching: find.byType(AnimatedContainer))
            .first,
      );
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration, isNotNull);
      expect(decoration?.border, isNotNull);
      expect(
        (decoration!.border as Border).top.color,
        equals(GirafColors.brownDark),
      );
    });
  });
}
