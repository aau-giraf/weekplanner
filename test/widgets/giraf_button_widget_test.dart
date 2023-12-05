import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart' as rx_dart;
import 'package:weekplanner/widgets/giraf_button_widget.dart';

const ImageIcon acceptIcon = ImageIcon(AssetImage('assets/icons/accept.png'));

class MockScreen extends StatelessWidget {
  final rx_dart.BehaviorSubject<bool> isPressed =
      rx_dart.BehaviorSubject<bool>.seeded(false);
  final rx_dart.BehaviorSubject<bool> btnEnabled =
      rx_dart.BehaviorSubject<bool>.seeded(false);
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
              isPressed.add(true);
            },
            icon: acceptIcon,
            isEnabledStream: btnEnabled,
          ),
        ],
      )),
    );
  }
}

void main() {
  testWidgets('Test if GirafButton is shown', (WidgetTester tester) async {
    // Opens the MockScreen widget
    await tester.pumpWidget(MaterialApp(home: MockScreen()));
    // Checks that the GirafButton exists on the MockScreen
    expect(find.byType(GirafButton), findsOneWidget);
  });

  testWidgets('GirafButton has a title', (WidgetTester tester) async {
    // Opens the MockScreen widget
    await tester.pumpWidget(MaterialApp(home: MockScreen()));
    // Checks that the text PressButton exists on the MockScreen
    expect(find.text('PressButton'), findsOneWidget);
  });

  testWidgets('GirafButton has an icon', (WidgetTester tester) async {
    // Opens the MockScreen widget
    await tester.pumpWidget(MaterialApp(home: MockScreen()));
    // Checks that the acceptIcon widget exists on the MockScreen
    expect(find.byWidget(acceptIcon), findsOneWidget);
  });


  testWidgets(
      'GirafButton is pressed and'
      ' works when enabled', (WidgetTester tester) async {
        // TODO; Skal revuderes, mange af disse ting er nok unødvendige
    final Completer<bool> done = Completer<bool>();
    final MockScreen screen = MockScreen();
    // Opens the MockScreen widget and enables the GirafButton
    await tester.pumpWidget(MaterialApp(home: screen));
    screen.btnEnabled.add(true);
    // Runs all stacked frames and finds widget with Button key
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('Button')));
    //Runs next frame and creates listener for isPressed
    await tester.pump();
    screen.isPressed.listen((bool status) {
      // Checks that the status of the button is true
      expect(status, isTrue);
      done.complete(true);
    });
    await done.future;
  });

  testWidgets(
      'GirafButton is pressed and'
      ' does not work when disabled', (WidgetTester tester) async {
    // TODO; Skal revuderes, mange af disse ting er nok unødvendige
    final Completer<bool> done = Completer<bool>();
    final MockScreen screen = MockScreen();
    // Opens the MockScreen widget and enables the GirafButton
    await tester.pumpWidget(MaterialApp(home: screen));
    await tester.pump();
    // Finds the widget with key Button and runs next frame
    await tester.tap(find.byKey(const Key('Button')));
    //Runs next frame and creates listener for isPressed
    await tester.pump();
    screen.isPressed.listen((bool status) {
      // Checks that the status of the button is false
      expect(status, isFalse);
      done.complete(true);
    });
    await done.future;
  });
}
