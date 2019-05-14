import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/enums/access_level_enum.dart';
import 'package:api_client/models/enums/activity_state_enum.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/models/timer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/timer_bloc.dart';
import 'package:weekplanner/widgets/giraf_activity_time_picker_dialog.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';

ActivityModel _activityModel = ActivityModel(
    id: 1,
    pictogram: PictogramModel(
        accessLevel: AccessLevel.PUBLIC,
        id: 1,
        imageHash: 'testHash',
        imageUrl: 'http://any.tld',
        lastEdit: DateTime.now(),
        title: 'testTitle'),
    order: 1,
    state: ActivityState.Normal,
    isChoiceBoard: true);

MockTimerBloc _mockTimerBloc = MockTimerBloc();

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
          return GirafActivityTimerPickerDialog(_activityModel, _mockTimerBloc);
        });
  }
}

class MockTimerBloc extends Mock implements TimerBloc {
  @override
  Observable<double> get timerProgressStream => _timerProgressStream.stream;
  final BehaviorSubject<double> _timerProgressStream =
      BehaviorSubject<double>.seeded(0.0);

  @override
  Observable<bool> get timerIsInstantiated => _timerInstantiatedStream.stream;
  final BehaviorSubject<bool> _timerInstantiatedStream =
      BehaviorSubject<bool>.seeded(false);

  @override
  void addTimer(Duration duration) {
    _activityModel.timer = TimerModel(
        startTime: DateTime.now(),
        progress: 0,
        fullLength: duration.inMilliseconds,
        paused: true);
    _timerInstantiatedStream.add(true);
    _timerProgressStream.add(0);
  }
}

void main() {
  testWidgets('Test if Time Picker Dialog is shown',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MockScreen()));
    await tester.tap(find.byKey(const Key('TimePickerOpenButton')));
    await tester.pump();
    expect(find.byType(GirafActivityTimerPickerDialog), findsOneWidget);
  });

  testWidgets('Tests if all textfields are rendered',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MockScreen()));
    await tester.tap(find.byKey(const Key('TimePickerOpenButton')));
    await tester.pump();
    expect(find.byType(GirafActivityTimerPickerDialog), findsOneWidget);
    expect(find.byKey(const Key('SekunderTextFieldKey')), findsOneWidget);
    expect(find.byKey(const Key('MinutterTextFieldKey')), findsOneWidget);
    expect(find.byKey(const Key('TimerTextFieldKey')), findsOneWidget);
  });

  testWidgets('Tests if both buttons are rendered',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MockScreen()));
    await tester.tap(find.byKey(const Key('TimePickerOpenButton')));
    await tester.pump();
    expect(find.byType(GirafActivityTimerPickerDialog), findsOneWidget);
    expect(
        find.byKey(const Key('TimePickerDialogCancelButton')), findsOneWidget);
    expect(
        find.byKey(const Key('TimePickerDialogAcceptButton')), findsOneWidget);
  });

  testWidgets('Test if Confirm Dialog is closed when tapping X button',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MockScreen()));
    await tester.tap(find.byKey(const Key('TimePickerOpenButton')));
    await tester.pump();
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
    await tester.enterText(find.byKey(const Key('SekunderTextFieldKey')), '1');
    await tester.pump();
    await tester.tap(find.byKey(const Key('TimePickerDialogAcceptButton')));
    await tester.pump();
    expect(find.byType(GirafActivityTimerPickerDialog), findsNothing);
  });

  testWidgets('Test that input from textfields are given to the timerBloc',
      (WidgetTester tester) async {
    const int hours = 1;
    const int minutes = 2;
    const int seconds = 3;
    await tester.pumpWidget(MaterialApp(home: MockScreen()));
    await tester.tap(find.byKey(const Key('TimePickerOpenButton')));
    await tester.pump();
    await tester.enterText(
        find.byKey(const Key('TimerTextFieldKey')), hours.toString());
    await tester.pump();
    await tester.enterText(
        find.byKey(const Key('MinutterTextFieldKey')), minutes.toString());
    await tester.pump();
    await tester.enterText(
        find.byKey(const Key('SekunderTextFieldKey')), seconds.toString());
    await tester.pump();
    await tester.tap(find.byKey(const Key('TimePickerDialogAcceptButton')));
    await tester.pump();
    _mockTimerBloc.timerIsInstantiated.listen((bool b) {
      expect(b, true);
    });
    expect(
        _activityModel.timer.fullLength,
        const Duration(hours: hours, minutes: minutes, seconds: seconds)
            .inMilliseconds);
  });

  testWidgets(
      'Test that wrong 0 time input on textfields prompts a notify dialog'
          'with correct message', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MockScreen()));
    await tester.tap(find.byKey(const Key('TimePickerOpenButton')));
    await tester.pump();
    await tester.enterText(find.byKey(const Key('TimerTextFieldKey')), '0');
    await tester.pump();
    await tester.enterText(
        find.byKey(const Key('MinutterTextFieldKey')), '0');
    await tester.pump();
    await tester.enterText(
        find.byKey(const Key('SekunderTextFieldKey')), '0');
    await tester.pump();
    await tester.tap(find.byKey(const Key('TimePickerDialogAcceptButton')));
    await tester.pump();
    expect(find.text('Den valgte tid må ikke være 0'), findsOneWidget);
  });

  testWidgets(
      'Test that no input on textfields prompts a notify dialog'
          'with correct message', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MockScreen()));
    await tester.tap(find.byKey(const Key('TimePickerOpenButton')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('TimePickerDialogAcceptButton')));
    await tester.pump();
    expect(find.text('Den valgte tid må ikke være 0'), findsOneWidget);
  });
}
