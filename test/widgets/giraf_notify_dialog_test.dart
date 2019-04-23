import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/widgets/giraf_notify_dialog.dart';

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
                    notifyDialog(context);
                  }),
            ],
          )),
    );
  }

  void notifyDialog(BuildContext context) {
    showDialog<Center>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return const GirafNotifyDialog(
              title: 'testTitle',
              description: 'testDescription');
        });
  }
}

void main() {
  testWidgets('Test if Notify Dialog is shown', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MockScreen()));
    await tester.tap(find.byKey(const Key('FirstButton')));
    await tester.pump();
    expect(find.byType(GirafNotifyDialog), findsOneWidget);
  });

  testWidgets('Test if Notify Dialog is closed when tapping Okay button',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: MockScreen()));
        await tester.tap(find.byKey(const Key('FirstButton')));
        await tester.pump();
        await tester.tap(find.byKey(const Key('NotifyDialogOkayButton')));
        await tester.pump();
        expect(find.byType(GirafNotifyDialog), findsNothing);
      });

}