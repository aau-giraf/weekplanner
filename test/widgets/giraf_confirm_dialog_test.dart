import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/giraf_confirm_dialog.dart';

class MockScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        children: <Widget>[
          GirafButton(
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
              confirmButtonIcon: const ImageIcon(null),
              confirmOnPressed: () {
                Routes.pop(context);
              });
        });
  }
}

void main() {
  testWidgets('Test if Confirm Dialog is shown', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MockScreen()));
    await tester.tap(find.byKey(const Key('FirstButton')));
    await tester.pumpAndSettle();
    expect(find.byType(GirafConfirmDialog), findsOneWidget);
  });

  testWidgets('Test if Confirm Dialog is closed when tapping Cancel button',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MockScreen()));
    await tester.tap(find.byKey(const Key('FirstButton')));
    await tester.pump();
    expect(find.byType(GirafConfirmDialog), findsOneWidget);
    await tester.tap(find.byKey(const Key('ConfirmDialogCancelButton')));
    await tester.pumpAndSettle();
    expect(find.byType(GirafConfirmDialog), findsNothing);
  });

  //In this case, the confirmed action is closing the widget
  testWidgets(
      'Test if confirmed action is performed when tapping Confirm button',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MockScreen()));
    await tester.tap(find.byKey(const Key('FirstButton')));
    await tester.pump();
    expect(find.byType(GirafConfirmDialog), findsOneWidget);
    await tester.tap(find.byKey(const Key('ConfirmDialogConfirmButton')));
    await tester.pumpAndSettle();
    expect(find.byType(GirafConfirmDialog), findsNothing);
  });
}
