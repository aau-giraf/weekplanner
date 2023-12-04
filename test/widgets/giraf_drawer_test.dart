import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weekplanner/widgets/giraf_drawer.dart';
import 'package:weekplanner/widgets/navigation_menu.dart';

import 'giraf_3button_dialog_test.dart';

class MockScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GirafDrawer(),
    );
  }
}

void main() {
  testWidgets('Has internal Drawer', (WidgetTester tester) async {
    MockScreen screen = MockScreen();
    await tester.pumpWidget(MaterialApp(home: screen));

    expect(find.byType(Drawer), findsOneWidget);
  });

  testWidgets('Has back option', (WidgetTester tester) async {
    MockScreen screen = MockScreen();
    await tester.pumpWidget(MaterialApp(home: screen));

    expect(find.byKey(const Key('Back')), findsOneWidget);
  });

  testWidgets('Has profile option', (WidgetTester tester) async {
    MockScreen screen = MockScreen();
    await tester.pumpWidget(MaterialApp(home: screen));

    expect(find.byKey(const Key('Profile')), findsOneWidget);
  });

  testWidgets('Has change user option', (WidgetTester tester) async {
    MockScreen screen = MockScreen();
    await tester.pumpWidget(MaterialApp(home: screen));

    expect(find.byKey(const Key('Change user')), findsOneWidget);
  });

  testWidgets('Has log off option', (WidgetTester tester) async {
    MockScreen screen = MockScreen();
    await tester.pumpWidget(MaterialApp(home: screen));

    expect(find.byKey(const Key('Log off')), findsOneWidget);
  });
}