import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/giraf_3button_dialog.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';

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
          return Giraf3ButtonDialog(
            title: 'test',
            description: 'test',
            option1Text: 'testOpt1',
            option1Icon: const ImageIcon(null),
            option1OnPressed: () {
              Routes().pop(context);
            },
            option2Text: 'testOpt2',
            option2Icon: const ImageIcon(null),
            option2OnPressed: () {
              Routes().pop(context);
            });
        });
  }
}

void main() {
  testWidgets('Test if 3 button Dialog is shown', (WidgetTester tester) async {
    //Pumps the MockScreen widget (calls the runApp on the widget) and finds the
    // button with the key FirsButton and triggers that frame
    //
    await tester.pumpWidget(MaterialApp(home: MockScreen()));
    await tester.tap(find.byKey(const Key('FirstButton')));
    await tester.pump();
    //Checks that the widget (Giraf3ButtonDialog) can be found
    expect(find.byType(Giraf3ButtonDialog), findsOneWidget);
  });

  testWidgets('Test if 3 button Dialog is closed when tapping Cancel button',
          (WidgetTester tester) async {
    //Pumps the MockScreen widget (calls the runApp on the widget) and finds the
    // button with the key FirsButton and triggers that frame
    await tester.pumpWidget(MaterialApp(home: MockScreen()));
    await tester.tap(find.byKey(const Key('FirstButton')));
    await tester.pump();
    //Checks that the widget (Giraf3ButtonDialog) can be found
    expect(find.byType(Giraf3ButtonDialog), findsOneWidget);
    // Finds the confirmDialogCancelButton and triggers it
    // Pumps the frame stack (To make sure that the frame activating the
    // confirmDialogCancelButton has been run)
    await tester.tap(find.byKey(const Key('ConfirmDialogCancelButton')));
    await tester.pump();
    // Checks that 3 button dialog has been closed after activating the
    // cancel button
    expect(find.byType(Giraf3ButtonDialog), findsNothing);
  });

  //In this case, the confirmed action is closing the widget
  testWidgets(
      'Test if action 1 is performed when pressing option1',
          (WidgetTester tester) async {
        //Activates the widget MockScreen and finds the first button
        await tester.pumpWidget(MaterialApp(home: MockScreen()));
        await tester.tap(find.byKey(const Key('FirstButton')));
        //Makes sure that the frame has been run
        await tester.pump();
        // Checks that the Griaf3ButtonDialog exists once.
        expect(find.byType(Giraf3ButtonDialog), findsOneWidget);
        // Clicks the Option1Button and run the frame
        await tester.tap(find.byKey(const Key('Option1Button')));
        await tester.pump();
        // Checks that the Griaf3ButtonDialog has been removed
        expect(find.byType(Giraf3ButtonDialog), findsNothing);
      });

  testWidgets(
      'Test if action 2 is performed when pressing option2',
          (WidgetTester tester) async {
        // Activates the MockScreen and clicks the FirstButton.
        // Also run the frame
        await tester.pumpWidget(MaterialApp(home: MockScreen()));
        await tester.tap(find.byKey(const Key('FirstButton')));
        await tester.pump();
        // Expects Girfat3ButtonDialog to exist only once
        expect(find.byType(Giraf3ButtonDialog), findsOneWidget);
        // Clicks the option2Button and runs the frame
        await tester.tap(find.byKey(const Key('Option2Button')));
        await tester.pump();
        //Checks that the Giraf3ButtonDialog has been closed
        expect(find.byType(Giraf3ButtonDialog), findsNothing);
      });
}