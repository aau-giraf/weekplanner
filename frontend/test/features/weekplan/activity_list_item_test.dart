import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/features/weekplan/presentation/widgets/activity_list_item.dart';
import 'package:weekplanner/shared/models/activity.dart';

void main() {
  const testActivity = Activity(
    activityId: 1,
    date: '2026-03-22',
    startTime: '08:00:00',
    endTime: '09:00:00',
  );

  Widget buildSubject({
    Activity activity = testActivity,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
    VoidCallback? onToggleStatus,
    String? imageUrl,
    String? soundUrl,
  }) {
    return MaterialApp(
      theme: girafTheme,
      home: Scaffold(
        body: ActivityListItem(
          activity: activity,
          onEdit: onEdit ?? () {},
          onDelete: onDelete ?? () {},
          onToggleStatus: onToggleStatus ?? () {},
          imageUrl: imageUrl,
          soundUrl: soundUrl,
        ),
      ),
    );
  }

  group('ActivityListItem', () {
    testWidgets('renders formatted time range', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('08:00 - 09:00'), findsOneWidget);
    });

    testWidgets('shows completed status icon when isCompleted is true',
        (tester) async {
      const completedActivity = Activity(
        activityId: 1,
        date: '2026-03-22',
        startTime: '08:00:00',
        endTime: '09:00:00',
        isCompleted: true,
      );

      await tester.pumpWidget(buildSubject(activity: completedActivity));

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('shows incomplete status icon when isCompleted is false',
        (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.byIcon(Icons.circle_outlined), findsOneWidget);
    });

    testWidgets('tapping the card calls onToggleStatus', (tester) async {
      var callCount = 0;

      await tester.pumpWidget(buildSubject(onToggleStatus: () => callCount++));

      await tester.tap(find.byType(InkWell).first);
      await tester.pump();

      expect(callCount, 1);
    });

    testWidgets('sound button is visible when soundUrl is provided',
        (tester) async {
      await tester.pumpWidget(
        buildSubject(soundUrl: 'http://test.mp3'),
      );

      expect(find.byIcon(Icons.volume_up), findsOneWidget);
    });

    testWidgets('sound button is hidden when soundUrl is null', (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.byIcon(Icons.volume_up), findsNothing);
    });

    testWidgets('sliding left reveals edit and delete actions', (tester) async {
      await tester.pumpWidget(buildSubject());

      await tester.drag(
        find.byType(Slidable),
        const Offset(-300, 0),
      );
      await tester.pumpAndSettle();

      expect(find.text('Rediger'), findsOneWidget);
      expect(find.text('Slet'), findsOneWidget);
    });

    testWidgets('shows pictogram placeholder icon when pictogramId is null',
        (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.byIcon(Icons.event), findsOneWidget);
    });

    // TODO: test audio playback with injected AudioPlayer
  });
}
