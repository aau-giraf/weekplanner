import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/loading_spinner_widget.dart';

class MockScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        children: <Widget>[
          RaisedButton(
              key: const Key('FirstButton'),
              onPressed: () {
                loadingSpinner(context);
              }),
          RaisedButton(
              key: const Key('SecondButton'),
              onPressed: () {
                Routes.pop(context);
              }),
        ],
      )),
    );
  }

  void loadingSpinner(BuildContext context) {
    showLoadingSpinner(context, true);
  }
}

void main() {
  testWidgets('Test if Loading Spinner is shown', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MockScreen()));
    await tester.tap(find.byKey(const Key('FirstButton')));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Test if Loading Spinner is removed again',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MockScreen()));
    await tester.tap(find.byKey(const Key('FirstButton')));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump();
    await tester.tap(find.byKey(const Key('SecondButton')));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
