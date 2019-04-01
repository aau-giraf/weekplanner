import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:weekplanner/main.dart';
import 'package:weekplanner/screens/login_screen.dart';
import 'package:weekplanner/widgets/giraf_notify_dialog.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  testWidgets('Notify dialog pops on confirmation',
          (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: GirafNotifyDialog(
            title: 'TestingTitle',
            description: 'This description is for testing',
        )
      )
    );
    await tester.tap(find.byKey(const Key('NotifyDialogOkayButton')));
    await tester.pumpAndSettle();
    expect(GirafNotifyDialog, findsNothing);
  });
}
