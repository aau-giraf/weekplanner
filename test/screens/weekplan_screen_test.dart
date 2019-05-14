import 'dart:async';
import 'package:api_client/api/api.dart';
import 'package:api_client/api/pictogram_api.dart';
import 'package:api_client/api/week_api.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/enums/activity_state_enum.dart';
import 'package:api_client/models/enums/weekday_enum.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/weekday_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/activity_bloc.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/copy_activities_bloc.dart';
import 'package:weekplanner/blocs/pictogram_bloc.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/blocs/timer_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/blocs/weekplan_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';
import 'package:weekplanner/models/enums/weekplan_mode.dart';
import 'package:weekplanner/screens/show_activity_screen.dart';
import 'package:weekplanner/screens/weekplan_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/giraf_confirm_dialog.dart';
import 'package:weekplanner/widgets/giraf_copy_activities_dialog.dart';

import '../test_image.dart';

class MockWeekApi extends Mock implements WeekApi {}

class MockPictogramApi extends Mock implements PictogramApi {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockAuthBlock extends AuthBloc {
  MockAuthBlock(Api api) : super(api);

  @override
  void authenticateFromPopUp(String username, String password) {
    if (password == 'password') {
      setAttempt(true);
      setMode(WeekplanMode.guardian);
    }
  }
}

void main() {
  WeekplanBloc bloc;
  Api api;
  AuthBloc authBloc;
  MockWeekApi weekApi;
  MockPictogramApi pictogramApi;

  final PictogramModel pictogramModel = PictogramModel(
      id: 1,
      lastEdit: null,
      title: null,
      accessLevel: null,
      imageUrl: 'http://any.tld',
      imageHash: null);

  ActivityModel newActivity(int id) {
    return ActivityModel(
        id: id,
        pictogram: pictogramModel,
        isChoiceBoard: true,
        state: null,
        order: 1);
  }

  final WeekModel weekModel = WeekModel(name: 'test', days: <WeekdayModel>[
    WeekdayModel(
        day: Weekday.Monday, activities: <ActivityModel>[newActivity(1)]),
    WeekdayModel(
        day: Weekday.Tuesday, activities: <ActivityModel>[newActivity(2)]),
    WeekdayModel(
        day: Weekday.Wednesday, activities: <ActivityModel>[newActivity(3)]),
    WeekdayModel(
        day: Weekday.Thursday, activities: <ActivityModel>[newActivity(4)]),
    WeekdayModel(
        day: Weekday.Friday, activities: <ActivityModel>[newActivity(5)]),
    WeekdayModel(
        day: Weekday.Saturday, activities: <ActivityModel>[newActivity(6)]),
    WeekdayModel(
        day: Weekday.Sunday, activities: <ActivityModel>[newActivity(7)]),
  ]);

  ActivityModel getActivity(Weekday day) {
    return weekModel.days[day.index].activities.first;
  }

  final UsernameModel user =
      UsernameModel(name: 'test', id: 'test', role: 'test');

  setUp(() {
    api = Api('any');
    weekApi = MockWeekApi();
    pictogramApi = MockPictogramApi();
    api.pictogram = pictogramApi;
    api.week = weekApi;
    bloc = WeekplanBloc(api);
    authBloc = MockAuthBlock(api);

    when(pictogramApi.getImage(pictogramModel.id))
        .thenAnswer((_) => BehaviorSubject<Image>.seeded(sampleImage));

    when(api.week.update(any, any, any, any)).thenAnswer((_) {
      return Observable<WeekModel>.just(weekModel);
    });

    di.clearAll();
    di.registerDependency<TimerBloc>((_) => TimerBloc(api));
    di.registerDependency<PictogramBloc>((_) => PictogramBloc(api));
    di.registerDependency<AuthBloc>((_) => authBloc);
    di.registerDependency<PictogramImageBloc>((_) => PictogramImageBloc(api));
    di.registerDependency<ToolbarBloc>((_) => ToolbarBloc());
    di.registerDependency<WeekplanBloc>((_) => bloc);
    di.registerDependency<ActivityBloc>((_) => ActivityBloc(api));
    di.registerDependency<CopyActivitiesBloc>((_) => CopyActivitiesBloc());
  });

  testWidgets('The screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
  });

  testWidgets('The screen has a Giraf App Bar', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));

    expect(find.byWidgetPredicate((Widget widget) => widget is GirafAppBar),
        findsOneWidget);
  });

  testWidgets('Has all days of the week', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pump();

    const List<String> days = <String>[
      'Mandag',
      'Tirsdag',
      'Onsdag',
      'Torsdag',
      'Fredag',
      'Lørdag',
      'Søndag'
    ];

    for (String day in days) {
      expect(find.text(day), findsOneWidget);
    }
  });

  testWidgets('Pictograms are rendered', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('PictogramImage')), findsNWidgets(7));
  });

  testWidgets('Activity has checkmark when done', (WidgetTester tester) async {
    getActivity(Weekday.Monday).state = ActivityState.Completed;
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pump();

    expect(find.byKey(const Key('IconComplete')), findsOneWidget);
  });

  testWidgets('Activity has cancel icon when canceled',
      (WidgetTester tester) async {
    getActivity(Weekday.Monday).state = ActivityState.Canceled;
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pump();

    expect(find.byKey(const Key('IconCanceled')), findsOneWidget);
  });

  testWidgets('Activity has no icon overlay when Normal',
      (WidgetTester tester) async {
    getActivity(Weekday.Monday).state = ActivityState.Normal;
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pump();

    expect(find.byKey(const Key('IconComplete')), findsNothing);
  });

  testWidgets('Every add activitybutton is build', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('AddActivityButton')), findsNWidgets(7));
  });

  testWidgets('When in guardian mode I should see more than just switch mode',
      (WidgetTester tester) async {
    final Completer<bool> done = Completer<bool>();

    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pump();

    authBloc.mode.skip(1).listen((_) async {
      await tester.pump();

      final GirafAppBar widget =
          find.byType(GirafAppBar).evaluate().first.widget;

      if (widget != null) {
        expect(widget.appBarIcons.length, greaterThan(1));
        expect(widget.appBarIcons.keys.contains(AppBarIcon.changeToCitizen),
            isTrue);
      } else {
        fail('Could not find GirafAppBar');
      }

      done.complete();
    });

    authBloc.setMode(WeekplanMode.guardian);
    await done.future;
  });

  testWidgets('When in citizens mode I should only see switch mode icon',
      (WidgetTester tester) async {
    final Completer<bool> done = Completer<bool>();

    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pump();

    authBloc.mode.skip(1).listen((_) async {
      await tester.pump();

      final GirafAppBar widget =
          find.byType(GirafAppBar).evaluate().first.widget;

      if (widget != null) {
        expect(widget.appBarIcons.length, equals(1));
        expect(widget.appBarIcons.keys.contains(AppBarIcon.changeToGuardian),
            isTrue);
      } else {
        fail('Could not find GirafAppBar');
      }

      done.complete();
    });

    authBloc.setMode(WeekplanMode.citizen);
    await done.future;
  });

  testWidgets(
      'When switching to citizens mode the add activityButton should disappear',
      (WidgetTester tester) async {
    final Completer<bool> done = Completer<bool>();

    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));

    await tester.pumpAndSettle();

    // Ensure the buttons are present before the switch
    expect(find.byKey(const Key('AddActivityButton')), findsNWidgets(7));

    authBloc.mode.skip(1).listen((_) async {
      await tester.pump();
      // Ensure the buttons are not present after the switch
      expect(find.byKey(const Key('AddActivityButton')), findsNWidgets(0));
      done.complete();
    });

    authBloc.setMode(WeekplanMode.citizen);
    await done.future;
  });

  testWidgets('As a gaurdian I should be able to drag-n-drop activities',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pumpAndSettle();
    authBloc.setMode(WeekplanMode.guardian);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('DragTarget')), findsNWidgets(7));
  });

  testWidgets('Every drag target is build', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pump();

    expect(find.byKey(const Key('DragTarget')), findsNWidgets(7));
  });

  testWidgets('Every drag target is build', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pump();

    expect(find.byKey(const Key('GreyDragVisibleKey')), findsNWidgets(7));
  });

  testWidgets('Every drag target placeholder is build',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pump();

    bloc.setActivityPlaceholderVisible(true);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('DragTargetPlaceholder')), findsNWidgets(7));

    bloc.setActivityPlaceholderVisible(false);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('DragTargetPlaceholder')), findsNWidgets(0));
  });

  testWidgets('Click on edit icon toggles edit mode',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pumpAndSettle();
    bool resultValue = false;

    bloc.editMode.listen((bool editMode) {
      resultValue = editMode;
    });

    expect(resultValue, false);

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    expect(resultValue, true);

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    expect(resultValue, false);
  });

  testWidgets('Tap on an activity in edit mode marks it',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key(Weekday.Wednesday.index.toString() +
        getActivity(Weekday.Wednesday).id.toString())));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('isSelectedKey')), findsOneWidget);
  });

  testWidgets('Leaving editmode deselects all activities',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key(Weekday.Wednesday.index.toString() +
        getActivity(Weekday.Wednesday).id.toString())));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('isSelectedKey')), findsOneWidget);

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('isSelectedKey')), findsNothing);
  });

  testWidgets('Deletes activties when click on confirm in dialog',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pumpAndSettle();

    final Key selectedPictogram = Key(Weekday.Monday.index.toString() +
        getActivity(Weekday.Monday).id.toString());

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(selectedPictogram));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('DeleteActivtiesButton')));
    await tester.pumpAndSettle();

    expect(find.byType(GirafConfirmDialog), findsOneWidget);
    await tester.tap(find.byKey(const Key('ConfirmDialogConfirmButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(selectedPictogram), findsNothing);
  });

  testWidgets('Does not delete activties when click on cancel in dialog',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pumpAndSettle();

    final Key selectedPictogram = Key(Weekday.Tuesday.index.toString() +
        getActivity(Weekday.Tuesday).id.toString());

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(selectedPictogram));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('DeleteActivtiesButton')));
    await tester.pumpAndSettle();

    expect(find.byType(GirafConfirmDialog), findsOneWidget);
    await tester.tap(find.byKey(const Key('ConfirmDialogCancelButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(selectedPictogram), findsOneWidget);
  });

  testWidgets(
      'Check if ShowActivityScreen is pushed when a pictogram is tapped',
      (WidgetTester tester) async {
    final MockNavigatorObserver mockObserver = MockNavigatorObserver();

    await tester.pumpWidget(MaterialApp(
      home: WeekplanScreen(weekModel, user),
      navigatorObservers: <NavigatorObserver>[mockObserver],
    ));
    await tester.pump();

    await tester.tap(find.byKey(Key(Weekday.Tuesday.index.toString() +
        getActivity(Weekday.Tuesday).id.toString())));
    await tester.pumpAndSettle();

    verify(mockObserver.didPush(any, any));

    expect(find.byType(ShowActivityScreen), findsOneWidget);
  });

  testWidgets(
      'As a guardian tapping the switch to citizen a dialog should appear',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: WeekplanScreen(weekModel, user),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('IconChangeToCitizen')));
    await tester.pumpAndSettle();
    final Finder dialog = find.byType(GirafConfirmDialog);
    final GirafConfirmDialog dialogWidget = dialog.evaluate().first.widget;

    expect(dialog, findsOneWidget);
    expect(dialogWidget.title, equals('Skift til borger'));
    expect(
        dialogWidget.description, equals('Vil du skifte til borger tilstand?'));
    expect(dialogWidget.confirmButtonText, equals('Skift'));
    expect(
        dialogWidget.confirmButtonIcon,
        equals(
            const ImageIcon(AssetImage('assets/icons/changeToCitizen.png'))));
  });

  testWidgets(
      'In the switch to citizen dialog, confirming should switch mode and pop',
      (WidgetTester tester) async {
    final Completer<bool> done = Completer<bool>();
    final Completer<bool> tapComplete = Completer<bool>();
    final MockNavigatorObserver observer = MockNavigatorObserver();
    await tester.pumpWidget(MaterialApp(
      home: WeekplanScreen(weekModel, user),
      navigatorObservers: <NavigatorObserver>[observer],
    ));
    await tester.pumpAndSettle();
    authBloc.mode.skip(1).listen((WeekplanMode mode) async {
      await tapComplete.future;
      expect(WeekplanMode.citizen, equals(mode));
      done.complete();
    });
    await tester.tap(find.byKey(const Key('IconChangeToCitizen')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('ConfirmDialogConfirmButton')));
    await tester.pumpAndSettle();

    tapComplete.complete();

    final VerificationResult verificationResult =
        verify(observer.didPop(any, any));

    expect(verificationResult.callCount, equals(1));

    await done.future;
  });

  testWidgets(
      'As a citizen tapping the switch to gaurdian a dialog should appear',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: WeekplanScreen(weekModel, user),
    ));
    await tester.pumpAndSettle();
    authBloc.setMode(WeekplanMode.citizen);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('IconChangeToGuardian')));
    await tester.pumpAndSettle();
    final Finder dialog = find.byType(AlertDialog);
    final Finder passField = find.byKey(const Key('SwitchToGuardianPassword'));

    expect(dialog, findsOneWidget);
    expect(passField, findsOneWidget);
  });

  testWidgets(
      'In the switch to guardian dialog, wrong credentials should show '
          'error dialog and pop loadingspinner',
          (WidgetTester tester) async {
        final MockNavigatorObserver observer = MockNavigatorObserver();
        await tester.pumpWidget(MaterialApp(
          home: WeekplanScreen(weekModel, user),
          navigatorObservers: <NavigatorObserver>[observer],
        ));
        await tester.pumpAndSettle();

        authBloc.setMode(WeekplanMode.citizen);

        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('IconChangeToGuardian')));
        await tester.pumpAndSettle();

        await tester.enterText(
            find.byKey(const Key('SwitchToGuardianPassword')), 'abc');
        await tester.tap(find.byKey(const Key('SwitchToGuardianSubmit')));

        await tester.pumpAndSettle();

        // Only thing that should be popped is the loading spinner.
        verify(observer.didPop(any, any)).called(1);

        expect(find.byKey(const Key('WrongPasswordDialog')),
            findsOneWidget);
      });

  testWidgets(
      'In the switch to guardian dialog, wrong credentials should show '
          'not change mode and pop loadingspinner',
          (WidgetTester tester) async {
        final Completer<bool> done = Completer<bool>();
        final Completer<bool> tapComplete = Completer<bool>();
        final MockNavigatorObserver observer = MockNavigatorObserver();
        await tester.pumpWidget(MaterialApp(
          home: WeekplanScreen(weekModel, user),
          navigatorObservers: <NavigatorObserver>[observer],
        ));
        await tester.pumpAndSettle();

        authBloc.setMode(WeekplanMode.citizen);

        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('IconChangeToGuardian')));
        await tester.pumpAndSettle();

        await tester.enterText(
            find.byKey(const Key('SwitchToGuardianPassword')), 'abc');
        await tester.tap(find.byKey(const Key('SwitchToGuardianSubmit')));

        await tester.pumpAndSettle();
        tapComplete.complete();

        authBloc.mode.listen((WeekplanMode attempt) async {
          await tapComplete.future;
          // Expect that the mode is still citizen.
          expect(WeekplanMode.citizen, equals(WeekplanMode.citizen));
          done.complete();
        });

        // Only thing that should be popped is the loading spinner.
        verify(observer.didPop(any, any)).called(1);

        await done.future;
      });

  testWidgets(
      'In the switch to guardian dialog, confirming should switch mode and pop',
      (WidgetTester tester) async {
    final Completer<bool> done = Completer<bool>();
    final Completer<bool> tapComplete = Completer<bool>();
    final MockNavigatorObserver observer = MockNavigatorObserver();
    await tester.pumpWidget(MaterialApp(
      home: WeekplanScreen(weekModel, user),
      navigatorObservers: <NavigatorObserver>[observer],
    ));
    await tester.pumpAndSettle();

    // Skip twice, first for the seeded value, second for the
    // setMode call made during arranging of this test case.
    authBloc.mode.skip(2).listen((WeekplanMode mode) async {
      await tapComplete.future;
      expect(WeekplanMode.guardian, equals(mode));
      done.complete();
    });

    authBloc.setMode(WeekplanMode.citizen);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('IconChangeToGuardian')));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.byKey(const Key('SwitchToGuardianPassword')), 'password');

    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('SwitchToGuardianSubmit')));

    await tester.pumpAndSettle(const Duration(seconds:2));
    
    tapComplete.complete();

    // Should pop twice, first for the loading spinner, second for the popup.
    verify(observer.didPop(any, any)).called(2);

    expect(find.byKey(const Key('WrongPasswordDialog')),
        findsNothing);

    await done.future;
  });

  testWidgets('As a citizen I should not be able to drag-n-drop activities',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pumpAndSettle();
    authBloc.setMode(WeekplanMode.citizen);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('DragTarget')), findsNothing);
  });
  testWidgets('Bottom app is shown after clicking edit button',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    expect(find.byType(BottomAppBar), findsOneWidget);
  });

  testWidgets('Edit buttons are shown after clicking edit button',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    expect(find.byType(GirafButton), findsNWidgets(3));
  });

  testWidgets('Does not cancel activties when click on cancel in dialog',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pumpAndSettle();

    final Key selectedPictogram = Key(Weekday.Tuesday.index.toString() +
        getActivity(Weekday.Tuesday).id.toString());

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(selectedPictogram));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('CancelActivtiesButton')));
    await tester.pumpAndSettle();

    expect(find.byType(GirafConfirmDialog), findsOneWidget);
    await tester.tap(find.byKey(const Key('ConfirmDialogCancelButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('IconCanceled')), findsNothing);
  });

  testWidgets('Cancels activties when click on confirm in dialog',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pumpAndSettle();

    final Key selectedPictogram = Key(Weekday.Tuesday.index.toString() +
        getActivity(Weekday.Tuesday).id.toString());

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(selectedPictogram));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('CancelActivtiesButton')));
    await tester.pumpAndSettle();

    expect(find.byType(GirafConfirmDialog), findsOneWidget);
    await tester.tap(find.byKey(const Key('ConfirmDialogConfirmButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('IconCanceled')), findsOneWidget);
  });

  testWidgets('Copies activties when click on confirm in dialog',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pumpAndSettle();

    final Key selectedPictogram = Key(Weekday.Thursday.index.toString() +
        getActivity(Weekday.Thursday).id.toString());

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(selectedPictogram));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('CopyActivtiesButton')));
    await tester.pumpAndSettle();

    expect(find.byType(GirafCopyActivitiesDialog), findsOneWidget);

    await tester.tap(find.byKey(const Key('WedCheckbox')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('DialogConfirmButton')));
    await tester.pumpAndSettle();

    expect(weekModel.days[Weekday.Wednesday.index].activities.length, 2);
  });

  testWidgets('Does not cancel activties when click on cancel in dialog',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pumpAndSettle();

    final Key selectedPictogram = Key(Weekday.Tuesday.index.toString() +
        getActivity(Weekday.Tuesday).id.toString());

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(selectedPictogram));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('CopyActivtiesButton')));
    await tester.pumpAndSettle();

    expect(find.byType(GirafCopyActivitiesDialog), findsOneWidget);
    await tester.tap(find.byKey(const Key('FriCheckbox')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('DialogCancelButton')));
    await tester.pumpAndSettle();

    expect(weekModel.days[Weekday.Friday.index].activities.length, 1);
  });

}
