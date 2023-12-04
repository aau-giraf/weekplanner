import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/widgets/giraf_drawer.dart';
import 'package:weekplanner/widgets/navigation_menu.dart';

class MockScreen extends StatefulWidget {
  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  MockScreenState createState() => MockScreenState();
}

class MockScreenState extends State<MockScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: MockScreen._scaffoldKey,
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: InputNavigationMenu(),
          )
        ]
      ),
      drawer: GirafDrawer(),
    );
  }
}

void main() {
  testWidgets('Navigation button exists', (WidgetTester tester) async {
    MockScreen screen = MockScreen();
    await tester.pumpWidget(MaterialApp(home: screen));
    expect(find.byType(IconButton), findsOneWidget);
  });

  testWidgets('Navigation button has an icon', (WidgetTester tester) async {
    MockScreen screen = MockScreen();
    await tester.pumpWidget(MaterialApp(home: screen));
    expect(find.byType(IconButton), findsOneWidget);
  });

  testWidgets('Pressing the navigation button opens the drawer', (WidgetTester tester) async {
    MockScreen screen = MockScreen();
    await tester.pumpWidget(MaterialApp(home: screen));

    await tester.tap(find.byKey(const Key('NavigationMenu')));
    expect(MockScreen._scaffoldKey.currentState.isDrawerOpen, true);
  });
}