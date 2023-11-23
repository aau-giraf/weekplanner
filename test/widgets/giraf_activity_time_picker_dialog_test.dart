import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/enums/access_level_enum.dart';
import 'package:api_client/models/enums/activity_state_enum.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/models/timer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart' as rx_dart;
import 'package:weekplanner/blocs/timer_bloc.dart';
import 'package:weekplanner/widgets/giraf_activity_time_picker_dialog.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';

ActivityModel _activityModel = ActivityModel(
    id: 1,
    pictograms: <PictogramModel>[
      PictogramModel(
          accessLevel: AccessLevel.PUBLIC,
          id: 1,
          imageHash: 'testHash',
          imageUrl: 'http://any.tld',
          lastEdit: DateTime.now(),
          title: 'testTitle')
    ],
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
  Stream<double> get timerProgressStream => _timerProgressStream.stream;
  final rx_dart.BehaviorSubject<double> _timerProgressStream =
      rx_dart.BehaviorSubject<double>.seeded(0.0);

  @override
  Stream<bool> get timerIsInstantiated => _timerInstantiatedStream.stream;
  final rx_dart.BehaviorSubject<bool> _timerInstantiatedStream =
      rx_dart.BehaviorSubject<bool>.seeded(false);

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
    // Activates the MockScreen widget and click the TimePickerOpenButton widget
    await tester.pumpWidget(MaterialApp(home: MockScreen()));
    await tester.tap(find.byKey(const Key('TimePickerOpenButton')));
    //Run the next frame
    await tester.pump();
    //Checks that GirafActivityTimerPickerDialog exists in only once.
    expect(find.byType(GirafActivityTimerPickerDialog), findsOneWidget);
  });

  testWidgets('Tests if all textfields are rendered',
      (WidgetTester tester) async {
    // Activates the MockScreen widget and click the TimePickerOpenButton widget
    await tester.pumpWidget(MaterialApp(home: MockScreen()));
    await tester.tap(find.byKey(const Key('TimePickerOpenButton')));
    // Run the next frame
    await tester.pump();
    //Checks that GirafActivityTimerPickerDialog exists in only once, the
    // sekunderTextFildKey exists in only once,
    // the MinutterTextFieldKey exists in only once and
    // that TimerTextFieldKey exsits only once.
    expect(find.byType(GirafActivityTimerPickerDialog), findsOneWidget);
    expect(find.byKey(const Key('SekunderTextFieldKey')), findsOneWidget);
    expect(find.byKey(const Key('MinutterTextFieldKey')), findsOneWidget);
    expect(find.byKey(const Key('TimerTextFieldKey')), findsOneWidget);
  });

  testWidgets('Tests if both buttons are rendered',
      (WidgetTester tester) async {
    // Activates the MockScreen widget and click the TimePickerOpenButton widget
    await tester.pumpWidget(MaterialApp(home: MockScreen()));
    await tester.tap(find.byKey(const Key('TimePickerOpenButton')));
    // Run the next frame
    await tester.pump();
    //Checks that GirafActivityTimerPickerDialog exists in only once, the
    // TimePickerDialogCancelButton key exists in only once,
    // the TimePickerDialogAcceptButton key exists in only once and
    expect(find.byType(GirafActivityTimerPickerDialog), findsOneWidget);
    expect(
        find.byKey(const Key('TimePickerDialogCancelButton')), findsOneWidget);
    expect(
        find.byKey(const Key('TimePickerDialogAcceptButton')), findsOneWidget);
  });

  testWidgets('Test if Confirm Dialog is closed when tapping X button',
      (WidgetTester tester) async {
    // Activates the MockScreen widget and click the TimePickerOpenButton widget
    await tester.pumpWidget(MaterialApp(home: MockScreen()));
    await tester.tap(find.byKey(const Key('TimePickerOpenButton')));
    // Runs the next frame
    await tester.pump();
    // Clicks the widget with key TimePickerDialogCancelButton
    await tester.tap(find.byKey(const Key('TimePickerDialogCancelButton')));
    // Runs the next frame
    await tester.pump();
    //Checks that the GirafActivityTimerPickerDIalog does not exists
    expect(find.byType(GirafActivityTimerPickerDialog), findsNothing);
  });

  testWidgets(
      'Test if Time Picker Dialog no longer is shown after pressing accept',
      (WidgetTester tester) async {
    // Activates the MockScreen widget and click the TimePickerOpenButton widget
    await tester.pumpWidget(MaterialApp(home: MockScreen()));
    await tester.tap(find.byKey(const Key('TimePickerOpenButton')));
    // Runs the next frame
    await tester.pump();
    // enters the textfield with key 'sekunderTextFieldKey' and types '1'
    await tester.enterText(find.byKey(const Key('SekunderTextFieldKey')), '1');
    // Runs the next frame and clicks the
    // widget with key TimePickerDialogAcceptButton and runs the next frame
    await tester.pump();
    await tester.tap(find.byKey(const Key('TimePickerDialogAcceptButton')));
    await tester.pump();
    // Checks that the GirafActivityTimerPickerDialog does not exist
    expect(find.byType(GirafActivityTimerPickerDialog), findsNothing);
  });

  testWidgets('Test that input from textfields are given to the timerBloc',
      (WidgetTester tester) async {
    const int hours = 1;
    const int minutes = 2;
    const int seconds = 3;
    // Activates the MockScreen widget and click the TimePickerOpenButton widget
    await tester.pumpWidget(MaterialApp(home: MockScreen()));
    await tester.tap(find.byKey(const Key('TimePickerOpenButton')));
    // Runs next frame
    await tester.pump();
    // Enters the hours, minutes and seconds into their textfields
    await tester.enterText(
        find.byKey(const Key('TimerTextFieldKey')), hours.toString());
    await tester.pump();
    await tester.enterText(
        find.byKey(const Key('MinutterTextFieldKey')), minutes.toString());
    await tester.pump();
    await tester.enterText(
        find.byKey(const Key('SekunderTextFieldKey')), seconds.toString());
    // Runs next frame and clicks widget the with key
    // TimePickerDialogAcceptButton and runs the next frame
    await tester.pump();
    await tester.tap(find.byKey(const Key('TimePickerDialogAcceptButton')));
    await tester.pump();
    //Checks that the timer is instantiated with a listener
    _mockTimerBloc.timerIsInstantiated.listen((bool b) {
      expect(b, true);
    });
    // Checks that the timer and expected duration is equal in milliseconds.
    expect(
        _activityModel.timer.fullLength,
        const Duration(hours: hours, minutes: minutes, seconds: seconds)
            .inMilliseconds);
  });

  testWidgets(
      'Test that wrong 0 time input on textfields prompts a notify dialog'
          'with correct message', (WidgetTester tester) async {
    // Activates the MockScreen widget and click the TimePickerOpenButton widget
    await tester.pumpWidget(MaterialApp(home: MockScreen()));
    await tester.tap(find.byKey(const Key('TimePickerOpenButton')));
    // Runs next frame and enters the textfield with key TimerTextFieldKey and
    // types 0
    await tester.pump();
    await tester.enterText(find.byKey(const Key('TimerTextFieldKey')), '0');
    // Runs next frame and enters 0 in min and 0 sec into their textFields
    await tester.pump();
    await tester.enterText(
        find.byKey(const Key('MinutterTextFieldKey')), '0');
    await tester.pump();
    await tester.enterText(
        find.byKey(const Key('SekunderTextFieldKey')), '0');
    // Runs the next frame and clicks widget with
    // TimePickerDialogAcceptButton key
    await tester.pump();
    await tester.tap(find.byKey(const Key('TimePickerDialogAcceptButton')));
    // Runs next frame and checks that the text
    // 'Den valgte tid må ikke være 0' is found once
    await tester.pump();
    expect(find.text('Den valgte tid må ikke være 0'), findsOneWidget);
  });

  testWidgets(
      'Test that no input on textfields prompts a notify dialog'
          'with correct message', (WidgetTester tester) async {
    // Activates the MockScreen widget and click the TimePickerOpenButton widget
    await tester.pumpWidget(MaterialApp(home: MockScreen()));
    await tester.tap(find.byKey(const Key('TimePickerOpenButton')));
    // Runs next frame and click widget with key TimePickerDialogAcceptButton
    await tester.pump();
    await tester.tap(find.byKey(const Key('TimePickerDialogAcceptButton')));
    // Runs next frame and checks that the text
    // 'Den valgte tid må ikke være 0' is found once
    await tester.pump();
    expect(find.text('Den valgte tid må ikke være 0'), findsOneWidget);
  });
}
