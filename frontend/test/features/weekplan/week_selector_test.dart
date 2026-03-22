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
          onSelectDate: onSelectDate ?? (_) {},
        ),
      ),
    );
  }

  group('WeekSelector', () {
    testWidgets('renders week number text', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('Uge 13'), findsOneWidget);
    });

    testWidgets('renders 7 day buttons with correct short labels',
        (tester) async {
      await tester.pumpWidget(buildSubject());

      for (final label in ['Man', 'Tir', 'Ons', 'Tor', 'Fre', 'Lør', 'Søn']) {
        expect(find.text(label), findsOneWidget);
      }
    });

    testWidgets('tapping a day button calls onSelectDate with the correct date',
        (tester) async {
      DateTime? captured;
      await tester.pumpWidget(buildSubject(onSelectDate: (d) => captured = d));

      // Tap the day button for the 25th (Wednesday)
      await tester.tap(find.text('25'));
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
  });
}
