import 'package:flutter_test/flutter_test.dart';
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
              icon: const Icon(Icons.fastfood)),
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

  testWidgets('Has GirafButton a title and an icon',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MockScreenButtonTest()));

    expect(find.text('PressButton'), findsOneWidget);
    expect(find.byIcon(Icons.fastfood), findsOneWidget);
  });
  
  testWidgets('Test if GirafButton is in default state',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MockScreenButtonTest()));
    await tester.pump();
  });
}
