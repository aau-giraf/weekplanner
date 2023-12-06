import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/loading_spinner_widget.dart';

//Creates a mock for the test
class MockScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        children: <Widget>[
          ElevatedButton(
              key: const Key('FirstButton'),
              onPressed: () {
                loadingSpinner(context);
              },
              child: const Text('')),
          ElevatedButton(
              key: const Key('SecondButton'),
              onPressed: () {
                Routes().pop(context);
              },
              child: const Text('')),
        ],
      )),
    );
  }

  //Function for showing the loading spinner
  void loadingSpinner(BuildContext context) {
    showLoadingSpinner(context, true);
  }
}

void main() {
  testWidgets('Test if Loading Spinner is shown', (WidgetTester tester) async {
    //Pumps the MockScreen and tries to find the "FirstButton" with tester.tap
    await tester.pumpWidget(MaterialApp(home: MockScreen()));
    await tester.tap(find.byKey(const Key('FirstButton')));
    await tester.pump();
    // As the "FirstButton" is set to toggle the loading spinner
    // (can be seen in the mock above),
    // It is now expected that the loading spinner is being shown
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Test if Loading Spinner is removed again',
      (WidgetTester tester) async {
    //Line 51-54 is the same as above, toggling the loading spinner on
    await tester.pumpWidget(MaterialApp(home: MockScreen()));
    await tester.tap(find.byKey(const Key('FirstButton')));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump();
    //Finds the "SecondButton" which toggles the loading spinner off again
    await tester.tap(find.byKey(const Key('SecondButton')),
        warnIfMissed: false);
    await tester.pump();
    //Checks to see if the loading spinner is removed
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
