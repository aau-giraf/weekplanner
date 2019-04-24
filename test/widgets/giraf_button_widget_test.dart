import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:flutter/material.dart';

class MockScreen extends StatelessWidget {
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
                Routes.pop(context);
              },
              icon: const ImageIcon(AssetImage('assets/icons/accept.png')),
              isEnabledStream: Observable<bool>.just(false)),
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
}
