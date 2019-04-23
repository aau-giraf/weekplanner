import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:flutter/material.dart';

class MockScreenButtonTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        children: <Widget>[
          GirafButton(
              key: const Key('Button'),
              text: 'PressButton',
              onPressed: () {},
              icon: const Icon(Icons.fastfood),
              isEnabledStream: Observable<bool>.just(false)
          ),
        ],
      )),
    );
  }
}

void main() {
  testWidgets('Test if GirafButton is shown', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MockScreenButtonTest()));
    expect(find.byType(GirafButton), findsOneWidget);
  });

  testWidgets('GirafButton has a title and an icon',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MockScreenButtonTest()));

    expect(find.text('PressButton'), findsOneWidget);
    expect(find.byIcon(Icons.fastfood), findsOneWidget);
  });

  //This test is not done
  testWidgets('GirafButton is enabled',
  (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MockScreenButtonTest()));
  final Finder submit = find.widgetWithText(GirafButton, 'PressButton');

  expect(tester.widget<GirafButton>(submit).isEnabled,
  isTrue);
  });

}
