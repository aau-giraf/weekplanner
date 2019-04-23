import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/giraf_confirm_dialog.dart';

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
                confirmDialog(context);
              }),
        ],
      )),
    );
  }

  void confirmDialog(BuildContext context) {
    showDialog<Center>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return GirafConfirmDialog(
              title: 'test',
              description: 'test',
              confirmButtonText: 'test',
              confirmButtonIcon:
                  const ImageIcon(AssetImage('assets/icons/logout.png')),
              confirmOnPressed: () {
                Routes.pop(context);
              });
        });
  }
}

void main() {
  testWidgets('Test if Confirm Dialog is shown', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MockScreen()));
    await tester.pump();
    await tester.tap(find.byKey(const Key('FirstButton')));
    await tester.pumpAndSettle();
    expect(find.byType(GirafConfirmDialog), findsOneWidget);
  });

  /*testWidgets('Test if Confirm Dialog is closed again', (WidgetTester tester) {
    tester.pumpWidget(MaterialApp(home: MockScreen()));
    tester.tap(find.byKey(const Key('FirstButton')));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    tester.tap(find.byKey(const Key('SecondButton')));
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });*/
}
