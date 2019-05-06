import 'dart:async';

import 'package:api_client/api/api.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/enums/weekday_enum.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/weekday_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/activity_bloc.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/pictogram_bloc.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/blocs/weekplan_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:api_client/models/enums/activity_state_enum.dart';
import 'package:api_client/models/username_model.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';
import 'package:weekplanner/models/enums/weekplan_mode.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/show_activity_screen.dart';
import 'package:weekplanner/screens/weekplan_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_confirm_dialog.dart';
import '../blocs/pictogram_bloc_test.dart';
import '../blocs/weekplan_bloc_test.dart';
import '../test_image.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}
class MockAuthBlock extends AuthBloc{
  MockAuthBlock(Api api) : super(api);

  @override
  void authenticateFromPopUp(String username, String password,
                             BuildContext context) {
    if(password == 'password'){
      setMode(WeekplanMode.guardian);
      Routes.pop(context);
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

  final ActivityModel activity = ActivityModel(
      id: 1,
      pictogram: pictogramModel,
      isChoiceBoard: true,
      state: ActivityState.Completed,
      order: 1);

  final WeekModel weekModel = WeekModel(name: 'test', days: <WeekdayModel>[
    WeekdayModel(day: Weekday.Monday, activities: <ActivityModel>[activity]),
    WeekdayModel(day: Weekday.Tuesday, activities: <ActivityModel>[activity]),
    WeekdayModel(day: Weekday.Wednesday, activities: <ActivityModel>[activity]),
    WeekdayModel(day: Weekday.Thursday, activities: <ActivityModel>[activity]),
    WeekdayModel(day: Weekday.Friday, activities: <ActivityModel>[activity]),
    WeekdayModel(day: Weekday.Saturday, activities: <ActivityModel>[activity]),
    WeekdayModel(day: Weekday.Sunday, activities: <ActivityModel>[activity]),
  ]);

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

    di.clearAll();
    di.registerDependency<PictogramBloc>((_) => PictogramBloc(api));
    di.registerDependency<AuthBloc>((_) => authBloc);
    di.registerDependency<PictogramImageBloc>((_) => PictogramImageBloc(api));
    di.registerDependency<ToolbarBloc>((_) => ToolbarBloc());
    di.registerDependency<WeekplanBloc>((_) => bloc);
    di.registerDependency<ActivityBloc>((_) => ActivityBloc(api));
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

  testWidgets('pictograms are rendered', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pump();
    await tester.pump();

    expect(find.byKey(const Key('PictogramImage')), findsNWidgets(7));
  });

  testWidgets('Activity has checkmark when done', (WidgetTester tester) async {
    activity.state = ActivityState.Completed;
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pump();

    expect(find.byKey(const Key('IconComplete')), findsNWidgets(7));
  });

  testWidgets('Activity has no checkmark when Normal',
      (WidgetTester tester) async {
    activity.state = ActivityState.Normal;
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

      final GirafAppBar widget = find
          .byType(GirafAppBar)
          .evaluate()
          .first
          .widget;

      if (widget != null) {
        expect(widget.appBarIcons.length, greaterThan(1));
        expect(widget.appBarIcons.contains(AppBarIcon.changeToCitizen), isTrue);
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

      final GirafAppBar widget = find
          .byType(GirafAppBar)
          .evaluate()
          .first
          .widget;

      if (widget != null) {
        expect(widget.appBarIcons.length, equals(1));
        expect(widget.appBarIcons.contains(AppBarIcon.changeToGuardian),
            isTrue
        );
      } else {
        fail('Could not find GirafAppBar');
      }

      done.complete();
    });

    authBloc.setMode(WeekplanMode.citizen);
    await done.future;
  });

  testWidgets(
      'When switching to citizens mode the add activityButton should disappear'
      ,
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

  testWidgets(
      'Check if ShowActivityScreen is pushed when a pictogram is tapped',
      (WidgetTester tester) async {
    final MockNavigatorObserver mockObserver = MockNavigatorObserver();

    await tester.pumpWidget(MaterialApp(
      home: WeekplanScreen(weekModel, user),
      navigatorObservers: <NavigatorObserver>[mockObserver],
    ));
    await tester.pump();

    await tester.tap(find
        .byKey(Key(Weekday.Tuesday.index.toString() + activity.id.toString())));
    await tester.pumpAndSettle();

    verify(mockObserver.didPush(any, any));

    expect(find.byType(ShowActivityScreen), findsOneWidget);
  });

  testWidgets(
      'As a guardian tapping the switch to citizen a dialog should appear',
          (WidgetTester tester) async {
            await tester.pumpWidget(
                MaterialApp(
                    home: WeekplanScreen(weekModel, user),
                )
            );
            await tester.pumpAndSettle();
            await tester.tap(find.byKey(const Key('IconChangeToCitizen')));
            await tester.pumpAndSettle();
            final Finder dialog = find.byType(GirafConfirmDialog);
            final GirafConfirmDialog dialogWidget = dialog
                .evaluate().first.widget;

            expect(dialog, findsOneWidget);
            expect(dialogWidget.title, equals('Skift til borger'));
            expect(
                dialogWidget.description,
                equals('Vil du skifte til borger tilstand?')
            );
            expect(dialogWidget.confirmButtonText, equals('Skift'));
            expect(
                dialogWidget.confirmButtonIcon,
                equals(const ImageIcon(
                    AssetImage('assets/icons/changeToCitizen.png')
                  )
                )
            );
          });

  testWidgets(
    'In the switch to citizen dialog, confirming should switch mode and pop',
      (WidgetTester tester) async {
        final Completer<bool> done = Completer<bool>();
        final Completer<bool> tapComplete = Completer<bool>();
        final MockNavigatorObserver observer = MockNavigatorObserver();
        await tester.pumpWidget(
            MaterialApp(
              home: WeekplanScreen(weekModel, user),
              navigatorObservers: <NavigatorObserver>[observer],
            )
        );
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
      }
  );

  testWidgets(
    'As a citizen tapping the switch to gaurdian a dialog should appear',
      (WidgetTester tester) async {
        await tester.pumpWidget(
            MaterialApp(
              home: WeekplanScreen(weekModel, user),
            )
        );
        await tester.pumpAndSettle();
        authBloc.setMode(WeekplanMode.citizen);
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('IconChangeToGuardian')));
        await tester.pumpAndSettle();
        final Finder dialog = find.byType(AlertDialog);
        final Finder passField =
          find.byKey(const Key('SwitchToGuardianPassword'));

        expect(dialog, findsOneWidget);
        expect(passField, findsOneWidget);
      }
  );

  testWidgets(
      'In the switch to guardian dialog, confirming should switch mode and pop',
      (WidgetTester tester) async {
        final Completer<bool> done = Completer<bool>();
        final Completer<bool> tapComplete = Completer<bool>();

        await tester.pumpWidget(
            MaterialApp(
              home: WeekplanScreen(weekModel, user)
            )
        );
        await tester.pumpAndSettle();

        // We need to skip 2 this time, first skip the seeded value
        // second skip the switch to citizen mode (which is part of the arrange
        // step for this test)
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
            find.byKey(const Key('SwitchToGuardianPassword')),
            'password'
        );
        await tester.tap(find.byKey(const Key('SwitchToGuardianSubmit')));

        // Waiting 1 second to let the timer used internally in
        // the confirmation button to finish before signaling the tap is done.
        await tester.pumpAndSettle(Duration(seconds:1));

        tapComplete.complete();

        await done.future;
      }
  );

  testWidgets('As a gaurdian I should be able to drag-n-drop activities',
          (WidgetTester tester) async {
        await tester.pumpWidget(
            MaterialApp(
                home: WeekplanScreen(weekModel, user)
            )
        );
        await tester.pumpAndSettle();
        authBloc.setMode(WeekplanMode.guardian);
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('DragTarget')), findsNWidgets(7));
      }
  );

  testWidgets('As a citizen I should not be able to drag-n-drop activities',
      (WidgetTester tester) async {
        await tester.pumpWidget(
            MaterialApp(
              home: WeekplanScreen(weekModel, user)
            )
        );
        await tester.pumpAndSettle();
        authBloc.setMode(WeekplanMode.citizen);
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('DragTarget')), findsNothing);
      }
  );
}
