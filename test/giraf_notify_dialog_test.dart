import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:weekplanner/main.dart';
import 'package:weekplanner/widgets/giraf_notify_dialog.dart';

void main() {
  testWidgets('Notify dialog pops on confirmation', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: GirafNotifyDialog(title: "TestingTitle", description: "This description is for testing"),
      )
    );
    await tester.press(find.byKey(Key("NotifyDialogOkayButton")));

    expect(find.byKey(Key("NotifyDialogKey")), findsOneWidget);
  });
}
