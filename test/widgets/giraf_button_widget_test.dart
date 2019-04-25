import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:flutter/material.dart';

class MockScreen extends StatelessWidget {
  bool isPressed = false;
  BehaviorSubject<bool> btnEnabled = BehaviorSubject<bool>.seeded(false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        children: <Widget>[
          GirafButton(
            key: const Key('Button'),
            text: 'PressButton',
            onPressed: () {
              isPressed = true;
            },
            icon: const ImageIcon(AssetImage('assets/icons/accept.png')),
            isEnabledStream: btnEnabled,
          ),
        ],
      )),
    );
  }
}

void main() {
  testWidgets('Test if GirafButton is shown', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MockScreen()));
    expect(find.byType(GirafButton), findsOneWidget);
  });

  testWidgets('GirafButton has a title', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MockScreen()));

    expect(find.text('PressButton'), findsOneWidget);
  });

  testWidgets('GirafButton has an icon', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MockScreen()));

    expect(
        find.byWidget(const ImageIcon(AssetImage('assets/icons/accept.png'))),
        findsOneWidget);
  });

  testWidgets(
      'GirafButton is pressed and'
      ' works when enabled', (WidgetTester tester) async {
    MockScreen screen = MockScreen();
    await tester.pumpWidget(MaterialApp(home: screen));
    screen.btnEnabled.add(true);
    await tester.pumpAndSettle();
    expect(screen.isPressed, isFalse);
    await tester.tap(find.byKey(const Key('Button')));
    await tester.pump();
    expect(screen.isPressed, isTrue);
  });

  testWidgets(
      'GirafButton is pressed and'
      ' does not work when disabled', (WidgetTester tester) async {
    MockScreen screen = MockScreen();
    await tester.pumpWidget(MaterialApp(home: screen));
    await tester.pump();
    expect(screen.isPressed, isFalse);
    await tester.tap(find.byKey(const Key('Button')));
    await tester.pump();
    expect(screen.isPressed, isFalse);
  });
}
