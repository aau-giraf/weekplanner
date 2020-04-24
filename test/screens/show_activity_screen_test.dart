import 'dart:async';
import 'dart:io';
import 'package:api_client/api/activity_api.dart';
import 'package:api_client/api/week_api.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:api_client/models/timer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/activity_bloc.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/blocs/timer_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/enums/access_level_enum.dart';
import 'package:api_client/models/enums/activity_state_enum.dart';
import 'package:api_client/models/enums/weekday_enum.dart';
import 'package:api_client/models/enums/cancel_mark_enum.dart';
import 'package:api_client/models/enums/complete_mark_enum.dart';
import 'package:api_client/models/enums/default_timer_enum.dart';
import 'package:api_client/models/enums/giraf_theme_enum.dart';
import 'package:api_client/models/enums/orientation_enum.dart' as orientation;
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/weekday_model.dart';
import 'package:api_client/api/api.dart';
import 'package:weekplanner/models/enums/timer_running_mode.dart';
import 'package:weekplanner/models/enums/weekplan_mode.dart';
import 'package:weekplanner/screens/show_activity_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';

import '../blocs/choose_citizen_bloc_test.dart';

class MockWeekApi extends Mock implements WeekApi {}

class MockAuth extends Mock implements AuthBloc {
  @override
  Observable<bool> get loggedIn => _loggedIn.stream;
  final BehaviorSubject<bool> _loggedIn = BehaviorSubject<bool>.seeded(true);

  @override
  Observable<WeekplanMode> get mode => _mode.stream;
  final BehaviorSubject<WeekplanMode> _mode =
      BehaviorSubject<WeekplanMode>.seeded(WeekplanMode.guardian);

  @override
  String loggedInUsername = 'Graatand';

  @override
  void authenticate(String username, String password) {
    // Mock the API and allow these 2 users to ?login?
    final bool status = (username == 'test' && password == 'test') ||
        (username == 'Graatand' && password == 'password');
    // If there is a successful login, remove the loading spinner,
    // and push the status to the stream
    if (status) {
      loggedInUsername = username;
    }
    _loggedIn.add(status);
    _mode.add(WeekplanMode.guardian);
  }

  @override
  void logout() {
    _loggedIn.add(false);
    _mode.add(WeekplanMode.citizen);
  }
}

class MockActivityApi extends Mock implements ActivityApi {
  @override
  Observable<ActivityModel> update(ActivityModel activity, String userId) {
    return BehaviorSubject<ActivityModel>.seeded(activity);
  }
}

final WeekModel mockWeek = WeekModel(
    weekYear: 2018,
    weekNumber: 21,
    name: 'Uge 1',
    thumbnail: PictogramModel(
        id: 25,
        title: 'grå',
        accessLevel: AccessLevel.PUBLIC,
        imageHash: null,
        imageUrl: null,
        lastEdit: null),
    days: mockWeekdayModels);

final List<WeekdayModel> mockWeekdayModels = <WeekdayModel>[
  WeekdayModel(activities: mockActivities, day: Weekday.Monday)
];

final List<ActivityModel> mockActivities = <ActivityModel>[
  ActivityModel(
      id: 1381,
      state: ActivityState.Normal,
      order: 0,
      isChoiceBoard: false,
      pictogram: PictogramModel(
          id: 25,
          title: 'grå',
          accessLevel: AccessLevel.PUBLIC,
          imageHash: null,
          imageUrl: null,
          lastEdit: null))
];

final UsernameModel mockUser = UsernameModel(id: '42', name: null, role: null);
final ActivityModel mockActivity = mockWeek.days[0].activities[0];

class MockScreen extends StatelessWidget {
  const MockScreen(this.activity);

  final ActivityModel activity;

  @override
  Widget build(BuildContext context) {
    return ShowActivityScreen(activity, mockUser);
  }
}

ActivityModel makeNewActivityModel() {
  return ActivityModel(
      id: 1381,
      state: ActivityState.Normal,
      order: 0,
      isChoiceBoard: false,
      pictogram: PictogramModel(
          id: 25,
          title: 'grå',
          accessLevel: AccessLevel.PUBLIC,
          imageHash: null,
          imageUrl: null,
          lastEdit: null));
}

ActivityModel mockActivityModelWithTimer() {
  return ActivityModel(
      id: 1381,
      state: ActivityState.Normal,
      order: 0,
      isChoiceBoard: false,
      pictogram: PictogramModel(
          id: 25,
          title: 'grå',
          accessLevel: AccessLevel.PUBLIC,
          imageHash: null,
          imageUrl: null,
          lastEdit: null),
      timer: TimerModel(
          startTime: DateTime.now(),
          progress: 0,
          fullLength: const Duration(seconds: 5).inMilliseconds,
          paused: true));
}

ActivityModel mockActivityModelWithCompletedTimer() {
  return ActivityModel(
      id: 1381,
      state: ActivityState.Normal,
      order: 0,
      isChoiceBoard: false,
      pictogram: PictogramModel(
          id: 25,
          title: 'grå',
          accessLevel: AccessLevel.PUBLIC,
          imageHash: null,
          imageUrl: null,
          lastEdit: null),
      timer: TimerModel(
          startTime: DateTime.now(),
          progress: const Duration(seconds: 5).inMilliseconds,
          fullLength: const Duration(seconds: 5).inMilliseconds,
          paused: true));
}

final SettingsModel mockSettings = SettingsModel(
  orientation: orientation.Orientation.Portrait,
  completeMark: CompleteMark.Checkmark,
  cancelMark: CancelMark.Cross,
  defaultTimer: DefaultTimer.AnalogClock,
  timerSeconds: 1,
  activitiesCount: 1,
  theme: GirafTheme.GirafYellow,
  nrOfDaysToDisplay: 1,
  weekDayColors: null,
  lockTimerControl: false,
);

final SettingsModel mockSettings2 = SettingsModel(
  orientation: orientation.Orientation.Portrait,
  completeMark: CompleteMark.Checkmark,
  cancelMark: CancelMark.Cross,
  defaultTimer: DefaultTimer.AnalogClock,
  timerSeconds: 1,
  activitiesCount: 1,
  theme: GirafTheme.GirafYellow,
  nrOfDaysToDisplay: 1,
  weekDayColors: null,
  lockTimerControl: true,
);

void main() {
  ActivityBloc bloc;
  Api api;
  MockWeekApi weekApi;
  AuthBloc authBloc;
  TimerBloc timerBloc;
  SettingsBloc settingsBloc;

  void setupApiCalls() {
    when(weekApi.update(
            mockUser.id, mockWeek.weekYear, mockWeek.weekNumber, mockWeek))
        .thenAnswer((_) => BehaviorSubject<WeekModel>.seeded(mockWeek));

    when(api.user.getSettings(any)).thenAnswer((_) {
      return Observable<SettingsModel>.just(mockSettings);
    });
  }

  setUp(() {
    api = Api('any');
    weekApi = MockWeekApi();
    api.user = MockUserApi();
    api.week = weekApi;
    api.activity = MockActivityApi();
    authBloc = AuthBloc(api);
    bloc = ActivityBloc(api);
    timerBloc = TimerBloc(api);
    timerBloc.load(mockActivity,
        user: UsernameModel(id: '10', name: 'Test', role: ''));
    setupApiCalls();

    di.clearAll();
    di.registerDependency<ActivityBloc>((_) => bloc);
    di.registerDependency<AuthBloc>((_) => authBloc);
    di.registerDependency<PictogramImageBloc>((_) => PictogramImageBloc(api));
    di.registerDependency<ToolbarBloc>((_) => ToolbarBloc());
    di.registerDependency<TimerBloc>((_) => timerBloc);
    settingsBloc = SettingsBloc(api);
    di.registerDependency<SettingsBloc>((_) => settingsBloc);
  });

  testWidgets('renders', (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: ShowActivityScreen(mockActivity, mockUser)));
  });

  testWidgets('Has Giraf App Bar', (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: ShowActivityScreen(mockActivity, mockUser)));

    expect(find.byType(GirafAppBar), findsOneWidget);
  });

  testWidgets('Activity pictogram is rendered', (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: ShowActivityScreen(mockActivity, mockUser)));
    await tester.pump(Duration.zero);

    expect(find.byKey(Key(mockActivity.id.toString())), findsOneWidget);
  });

  testWidgets('ButtonBar is rendered', (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: ShowActivityScreen(mockActivity, mockUser)));
    await tester.pump();

    expect(find.byKey(const Key('ButtonBarRender')), findsOneWidget);
  });

  testWidgets('Cancel activity button is rendered in guardian mode',
      (WidgetTester tester) async {
    authBloc.setMode(WeekplanMode.guardian);
    await tester.pumpWidget(
        MaterialApp(home: ShowActivityScreen(mockActivity, mockUser)));
    await tester.pump();

    expect(find.byKey(const Key('CancelStateToggleButton')), findsOneWidget);
  });

  testWidgets('Complete activity button is NOT rendered in guardian mode',
      (WidgetTester tester) async {
    authBloc.setMode(WeekplanMode.guardian);
    await tester.pumpWidget(
        MaterialApp(home: ShowActivityScreen(mockActivity, mockUser)));
    await tester.pump();

    expect(find.byKey(const Key('CompleteStateToggleButton')), findsNothing);
  });

  testWidgets('Cancel activity button is NOT rendered in citizen mode',
      (WidgetTester tester) async {
    authBloc.setMode(WeekplanMode.citizen);
    await tester.pumpWidget(
        MaterialApp(home: ShowActivityScreen(mockActivity, mockUser)));
    await tester.pump();

    expect(find.byKey(const Key('CancelStateToggleButton')), findsNothing);
  });

  testWidgets('Activity has checkmark icon when completed',
      (WidgetTester tester) async {
    mockActivity.state = ActivityState.Completed;
    await tester.pumpWidget(
        MaterialApp(home: ShowActivityScreen(mockActivity, mockUser)));
    await tester.pump();

    expect(find.byKey(const Key('IconCompleted')), findsOneWidget);
  });

  testWidgets('Activity has cancel icon when canceled',
      (WidgetTester tester) async {
    mockActivity.state = ActivityState.Canceled;
    await tester.pumpWidget(
        MaterialApp(home: ShowActivityScreen(mockActivity, mockUser)));
    await tester.pump();

    expect(find.byKey(const Key('IconCanceled')), findsOneWidget);
  });

  testWidgets('Activity has no checkmark when Normal',
      (WidgetTester tester) async {
    mockActivity.state = ActivityState.Normal;
    await tester.pumpWidget(
        MaterialApp(home: ShowActivityScreen(mockActivity, mockUser)));
    await tester.pump();

    expect(find.byKey(const Key('IconCompleted')), findsNothing);
  });

  testWidgets('Activity is set to completed and an activity checkmark is shown',
      (WidgetTester tester) async {
    authBloc.setMode(WeekplanMode.citizen);
    mockActivity.state = ActivityState.Normal;
    await tester.pumpWidget(
        MaterialApp(home: ShowActivityScreen(mockActivity, mockUser)));

    await tester.pump();
    await tester.tap(find.byKey(const Key('CompleteStateToggleButton')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('IconCompleted')), findsOneWidget);
  });

  testWidgets('Activity is set to canceled and an activity cross is shown',
      (WidgetTester tester) async {
    authBloc.setMode(WeekplanMode.guardian);
    mockActivity.state = ActivityState.Normal;
    await tester.pumpWidget(
        MaterialApp(home: ShowActivityScreen(mockActivity, mockUser)));

    await tester.pump();
    await tester.tap(find.byKey(const Key('CancelStateToggleButton')));

    await tester.pump();
    expect(find.byKey(const Key('IconCanceled')), findsOneWidget);
  });

  testWidgets('Activity is set to normal and no activity mark is shown',
      (WidgetTester tester) async {
    authBloc.setMode(WeekplanMode.citizen);
    mockActivity.state = ActivityState.Completed;
    await tester.pumpWidget(
        MaterialApp(home: ShowActivityScreen(mockActivity, mockUser)));

    await tester.pump();
    await tester.tap(find.byKey(const Key('CompleteStateToggleButton')));

    await tester.pump();
    expect(find.byKey(const Key('IconCompleted')), findsNothing);
    expect(find.byKey(const Key('IconCanceled')), findsNothing);
  });

  testWidgets('Test if timer box is shown.', (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: MockScreen(makeNewActivityModel())));
    await tester.pump();
    expect(find.byKey(const Key('OverallTimerBoxKey')), findsOneWidget);
  });

  testWidgets('Test that timer box is not shown in citizen mode.',
      (WidgetTester tester) async {
    authBloc.setMode(WeekplanMode.citizen);
    await tester
        .pumpWidget(MaterialApp(home: MockScreen(makeNewActivityModel())));
    await tester.pump();
    expect(find.byKey(const Key('OverallTimerBoxKey')), findsNothing);
  });

  testWidgets('Test rendering of content of non-initialized timer box',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: MockScreen(makeNewActivityModel())));
    await tester.pump();
    expect(find.byKey(const Key('TimerTitleKey')), findsOneWidget);
    expect(find.byKey(const Key('TimerNotInitGuardianKey')), findsOneWidget);
    expect(find.byKey(const Key('AddTimerButtonKey')), findsOneWidget);
    expect(find.byKey(const Key('TimerButtonRow')), findsNothing);
  });

  Future<void> _openTimePickerAndConfirm(
      WidgetTester tester, int seconds, int minutes, int hours) async {
    await tester.tap(find.byKey(const Key('AddTimerButtonKey')));
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
    await tester.pumpAndSettle();
  }

  testWidgets(
      'Test rendering of content of initialized timer box guardian mode',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: MockScreen(makeNewActivityModel())));
    await tester.pump();
    expect(find.byKey(const Key('AddTimerButtonKey')), findsOneWidget);
    await _openTimePickerAndConfirm(tester, 3, 2, 1);
    expect(find.byKey(const Key('TimerTitleKey')), findsOneWidget);
    expect(find.byKey(const Key('TimerInitKey')), findsOneWidget);
    expect(find.byKey(const Key('TimerButtonRow')), findsOneWidget);
  });

  testWidgets('Test rendering of content of initialized timer box citizen mode',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: MockScreen(makeNewActivityModel())));
    await tester.pump();
    expect(find.byKey(const Key('AddTimerButtonKey')), findsOneWidget);
    await _openTimePickerAndConfirm(tester, 3, 2, 1);
    authBloc.setMode(WeekplanMode.citizen);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('AddTimerButtonKey')), findsNothing);
    expect(find.byKey(const Key('TimerTitleKey')), findsOneWidget);
    expect(find.byKey(const Key('TimerInitKey')), findsOneWidget);
    expect(find.byKey(const Key('TimerButtonRow')), findsOneWidget);
  });

  testWidgets(
      'Test rendering of content of initialized timer buttons guardian mode',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: MockScreen(makeNewActivityModel())));
    await tester.pumpAndSettle();
    await _openTimePickerAndConfirm(tester, 3, 2, 1);
    expect(find.byKey(const Key('TimerPlayButtonKey')), findsOneWidget);
    expect(find.byKey(const Key('TimerStopButtonKey')), findsOneWidget);
    expect(find.byKey(const Key('TimerDeleteButtonKey')), findsOneWidget);
    await tester.tap(find.byKey(const Key('TimerPlayButtonKey')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('TimerPauseButtonKey')), findsOneWidget);
    await tester.tap(find.byKey(const Key('TimerPauseButtonKey')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('TimerPlayButtonKey')), findsOneWidget);
  });

  testWidgets(
      'Test rendering of content of initialized timer buttons citizen mode',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: MockScreen(makeNewActivityModel())));
    await tester.pumpAndSettle();
    await _openTimePickerAndConfirm(tester, 3, 2, 1);
    authBloc.setMode(WeekplanMode.citizen);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('TimerPlayButtonKey')), findsOneWidget);
    expect(find.byKey(const Key('TimerStopButtonKey')), findsOneWidget);
    expect(find.byKey(const Key('TimerDeleteButtonKey')), findsNothing);
    await tester.tap(find.byKey(const Key('TimerPlayButtonKey')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('TimerPauseButtonKey')), findsOneWidget);
    await tester.tap(find.byKey(const Key('TimerPauseButtonKey')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('TimerPlayButtonKey')), findsOneWidget);
  });

  testWidgets('Test that timer stop button pops a confirm dialog',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: MockScreen(makeNewActivityModel())));
    await tester.pumpAndSettle();
    await _openTimePickerAndConfirm(tester, 3, 2, 1);
    await tester.tap(find.byKey(const Key('TimerStopButtonKey')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('TimerStopConfirmDialogKey')), findsOneWidget);
  });

  testWidgets('Test that timer delete button pops a confirm dialog',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: MockScreen(makeNewActivityModel())));
    await tester.pumpAndSettle();
    await _openTimePickerAndConfirm(tester, 3, 2, 1);
    await tester.tap(find.byKey(const Key('TimerDeleteButtonKey')));
    await tester.pumpAndSettle();
    expect(
        find.byKey(const Key('TimerDeleteConfirmDialogKey')), findsOneWidget);
  });

  testWidgets('Test that timerbloc registers the timer initlization',
      (WidgetTester tester) async {
    final Completer<bool> done = Completer<bool>();
    await tester
        .pumpWidget(MaterialApp(home: MockScreen(makeNewActivityModel())));
    await tester.pumpAndSettle();
    final StreamSubscription<bool> listenForFalse =
        timerBloc.timerIsInstantiated.listen((bool init) {
      expect(init, isFalse);
      done.complete();
    });
    await done.future;
    listenForFalse.cancel();
    await tester.pumpAndSettle();
    await _openTimePickerAndConfirm(tester, 3, 2, 1);
    timerBloc.timerIsInstantiated.listen((bool init) {
      expect(init, isTrue);
    });
  });

  testWidgets(
      'Test that timerbloc knows whether the timer is running or paused',
      (WidgetTester tester) async {
    final Completer<bool> checkNotRun = Completer<bool>();
    final Completer<bool> checkRunning = Completer<bool>();
    await tester
        .pumpWidget(MaterialApp(home: MockScreen(makeNewActivityModel())));
    await tester.pumpAndSettle();
    await _openTimePickerAndConfirm(tester, 3, 2, 1);
    final StreamSubscription<TimerRunningMode> listenForNotInitialized =
        timerBloc.timerRunningMode.listen((TimerRunningMode running) {
      expect(running, TimerRunningMode.not_initialized);
      checkNotRun.complete();
    });
    await checkNotRun.future;
    listenForNotInitialized.cancel();

    await tester.tap(find.byKey(const Key('TimerPlayButtonKey')));
    await tester.pumpAndSettle();
    final StreamSubscription<TimerRunningMode> listenForRunningTrue =
        timerBloc.timerRunningMode.listen((TimerRunningMode running) {
      expect(running, TimerRunningMode.running);
      checkRunning.complete();
    });
    await checkRunning.future;
    listenForRunningTrue.cancel();
    await tester.tap(find.byKey(const Key('TimerPauseButtonKey')));
    await tester.pumpAndSettle();
    timerBloc.timerRunningMode.listen((TimerRunningMode running) {
      expect(running, TimerRunningMode.paused);
    });
  });

  testWidgets('Timer not visible when activity cancelled',
      (WidgetTester tester) async {
    mockActivity.state = ActivityState.Canceled;

    await tester.pumpWidget(
        MaterialApp(home: ShowActivityScreen(mockActivity, mockUser)));

    expect(find.byKey(const Key('OverallTimerBoxKey')), findsNothing);

    mockActivity.state = ActivityState.Normal;
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('OverallTimerBoxKey')), findsOneWidget);
  });

  testWidgets('Test that play button appears when timer is complete',
      (WidgetTester tester) async {
    final Completer<bool> checkCompleted = Completer<bool>();
    await tester
        .pumpWidget(MaterialApp(home: MockScreen(makeNewActivityModel())));
    await tester.pumpAndSettle();
    await _openTimePickerAndConfirm(tester, 1, 0, 0);
    await tester.tap(find.byKey(const Key('TimerPlayButtonKey')));
    sleep(const Duration(seconds: 2));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    final StreamSubscription<TimerRunningMode> listenForCompleted =
        timerBloc.timerRunningMode.listen((TimerRunningMode m) {
      expect(m, TimerRunningMode.completed);
      checkCompleted.complete();
    });
    await checkCompleted.future;
    listenForCompleted.cancel();

    expect(find.byKey(const Key('TimerPlayButtonKey')), findsOneWidget);
  });

  testWidgets('Test that restart dialog pops up when timer is restarted',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: MockScreen(makeNewActivityModel())));
    await tester.pumpAndSettle();
    await _openTimePickerAndConfirm(tester, 1, 0, 0);
    await tester.tap(find.byKey(const Key('TimerPlayButtonKey')));
    sleep(const Duration(seconds: 2));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.tap(find.byKey(const Key('TimerPlayButtonKey')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('TimerRestartDialogKey')), findsOneWidget);
  });

  testWidgets(
      'Only have a play button for timer when lockTimerControl is true',
      (WidgetTester tester) async {
    when(api.user.getSettings(any)).thenAnswer((_) {
      return Observable<SettingsModel>.just(mockSettings2);
    });
    await tester.runAsync(() async {
      authBloc.setMode(WeekplanMode.citizen);
      await tester.pumpWidget(
          MaterialApp(home: MockScreen(mockActivityModelWithTimer())));

      await tester.pumpAndSettle();
      expect(
          find.byWidgetPredicate((Widget widget) =>
              widget is GirafButton &&
              widget.icon.image == const AssetImage('assets/icons/play.png') &&
              widget.key == const Key('TimerPlayButtonKey')),
          findsOneWidget);
      expect(
          find.byWidgetPredicate((Widget widget) =>
              widget is GirafButton &&
              widget.icon.image == const AssetImage('assets/icons/pause.png') &&
              widget.key == const Key('TimerPauseButtonKey')),
          findsNothing);
      expect(
          find.byWidgetPredicate((Widget widget) =>
              widget is GirafButton &&
              widget.icon.image == const AssetImage('assets/icons/Stop.png') &&
              widget.key == const Key('TimerStopButtonKey')),
          findsNothing);
      expect(
          find.byWidgetPredicate((Widget widget) =>
              widget is GirafButton &&
              widget.icon.image ==
                  const AssetImage('assets/icons/delete.png') &&
              widget.key == const Key('TimerDeleteButtonKey')),
          findsNothing);
      await tester.tap(find.byKey(const Key('TimerPlayButtonKey')));
      await tester.pumpAndSettle();

      expect(
          find.byWidgetPredicate((Widget widget) =>
              widget is GirafButton &&
              widget.icon.image == const AssetImage('assets/icons/play.png') &&
              widget.key == const Key('TimerPlayButtonKey')),
          findsNothing);
      expect(
          find.byWidgetPredicate((Widget widget) =>
              widget is GirafButton &&
              widget.icon.image == const AssetImage('assets/icons/pause.png') &&
              widget.key == const Key('TimerPauseButtonKey')),
          findsNothing);
      expect(
          find.byWidgetPredicate((Widget widget) =>
              widget is GirafButton &&
              widget.icon.image == const AssetImage('assets/icons/Stop.png') &&
              widget.key == const Key('TimerStopButtonKey')),
          findsNothing);
      expect(
          find.byWidgetPredicate((Widget widget) =>
              widget is GirafButton &&
              widget.icon.image ==
                  const AssetImage('assets/icons/delete.png') &&
              widget.key == const Key('TimerDeleteButtonKey')),
          findsNothing);
    });
  });

  testWidgets(
      'No buttons for timer when an activity with a completed timer is chosen',
      (WidgetTester tester) async {
    when(api.user.getSettings(any)).thenAnswer((_) {
      return Observable<SettingsModel>.just(mockSettings2);
    });
    await tester.runAsync(() async {
      authBloc.setMode(WeekplanMode.citizen);
      await tester.pumpWidget(
          MaterialApp(home: MockScreen(mockActivityModelWithCompletedTimer())));
      await tester.pumpAndSettle();

      expect(
          find.byWidgetPredicate((Widget widget) =>
              widget is GirafButton &&
              widget.icon.image == const AssetImage('assets/icons/play.png') &&
              widget.key == const Key('TimerPlayButtonKey')),
          findsNothing);
      expect(
          find.byWidgetPredicate((Widget widget) =>
              widget is GirafButton &&
              widget.icon.image == const AssetImage('assets/icons/pause.png') &&
              widget.key == const Key('TimerPauseButtonKey')),
          findsNothing);
      expect(
          find.byWidgetPredicate((Widget widget) =>
              widget is GirafButton &&
              widget.icon.image == const AssetImage('assets/icons/Stop.png') &&
              widget.key == const Key('TimerStopButtonKey')),
          findsNothing);
      expect(
          find.byWidgetPredicate((Widget widget) =>
              widget is GirafButton &&
              widget.icon.image ==
                  const AssetImage('assets/icons/delete.png') &&
              widget.key == const Key('TimerDeleteButtonKey')),
          findsNothing);
    });
  });
}
