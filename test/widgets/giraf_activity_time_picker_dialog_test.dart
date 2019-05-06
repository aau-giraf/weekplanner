import 'package:api_client/models/activity_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weekplanner/blocs/timer_bloc.dart';
import 'package:weekplanner/widgets/giraf_activity_time_picker_dialog.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';

class MockScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        children: <Widget>[
          GirafButton(
              key: const Key('TimePickerOpenButton'),
              onPressed: () {
                timePickerDialog(context);
              }),
        ],
      )),
    );
  }

  void timePickerDialog(BuildContext context) {
    showDialog<Center>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return GirafActivityTimerPickerDialog(
              MockActivityModel(), MockTimerBloc());
        });
  }
}

class MockTimerBloc extends Mock implements TimerBloc {}

class MockActivityModel extends Mock implements ActivityModel {}

void main() {
  testWidgets('Test if Time Picker Dialog is shown',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MockScreen()));
    await tester.tap(find.byKey(const Key('TimePickerOpenButton')));
    await tester.pump();
    expect(find.byType(GirafActivityTimerPickerDialog), findsOneWidget);
  });

  testWidgets('Test if Confirm Dialog is closed when tapping X button',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: MockScreen()));
        await tester.tap(find.byKey(const Key('TimePickerOpenButton')));
        await tester.pump();
        expect(find.byType(GirafActivityTimerPickerDialog), findsOneWidget);
        await tester.tap(find.byKey(const Key('TimePickerDialogCancelButton')));
        await tester.pump();
        expect(find.byType(GirafActivityTimerPickerDialog), findsNothing);
      });

  testWidgets(
      'Test if Time Picker Dialog no longer is shown after pressing accept',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: MockScreen()));
        await tester.tap(find.byKey(const Key('TimePickerOpenButton')));
        await tester.pump();
        expect(find.byType(GirafActivityTimerPickerDialog), findsOneWidget);
        await tester.tap(find.byKey(const Key('TimePickerDialogAcceptButton')));
        await tester.pump();
        expect(find.byType(GirafActivityTimerPickerDialog), findsNothing);
      });
}
