import 'package:api_client/api_client.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/activity_state_enum.dart';
import 'package:api_client/models/enums/cancel_mark_enum.dart';
import 'package:api_client/models/enums/complete_mark_enum.dart';
import 'package:api_client/models/enums/weekday_enum.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/weekday_color_model.dart';
import 'package:api_client/models/weekday_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:weekplanner/blocs/activity_bloc.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/copy_activities_bloc.dart';
import 'package:weekplanner/blocs/pictogram_bloc.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/blocs/timer_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/blocs/weekplan_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/enums/weekplan_mode.dart';
import 'package:weekplanner/screens/pictogram_search_screen.dart';
import 'package:weekplanner/screens/show_activity_screen.dart';
import 'package:weekplanner/screens/weekplan_screen.dart';
import 'package:weekplanner/widgets/weekplan_screen_widgets/activity_card.dart';
import 'package:weekplanner/widgets/bottom_app_bar_button_widget.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/giraf_confirm_dialog.dart';
import 'package:weekplanner/widgets/giraf_copy_activities_dialog.dart';
import 'package:weekplanner/widgets/pictogram_text.dart';

import '../mock_data.dart';

void main() {
  WeekModel mockWeek;
  SettingsModel mockSettings;
  List<ActivityModel> mockActivities;
  DisplayNameModel user;
  WeekplanBloc weekplanBloc;
  AuthBloc authBloc;

  setUp(() {
    MockData mockData;
    mockData = MockData();
    mockWeek = mockData.mockWeek;
    mockSettings = mockData.mockSettings;
    mockActivities = mockData.mockActivities;
    user = mockData.mockUser;

    final Api api = mockData.mockApi;
    authBloc = AuthBloc(api);
    authBloc.setMode(WeekplanMode.guardian);
    weekplanBloc = WeekplanBloc(api);

    di.clearAll();
    // We register the dependencies needed to build different widgets
    di.registerDependency<AuthBloc>((_) => authBloc);
    di.registerDependency<WeekplanBloc>((_) => weekplanBloc);
    di.registerDependency<SettingsBloc>((_) => SettingsBloc(api));
    di.registerDependency<ToolbarBloc>((_) => ToolbarBloc());
    di.registerDependency<PictogramImageBloc>((_) => PictogramImageBloc(api));
    di.registerDependency<TimerBloc>((_) => TimerBloc(api));
    di.registerDependency<ActivityBloc>((_) => ActivityBloc(api));
    di.registerDependency<PictogramBloc>((_) => PictogramBloc(api));
    di.registerDependency<CopyActivitiesBloc>((_) => CopyActivitiesBloc());
  });

  testWidgets('WeekplanScreen renders', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();
    expect(find.byType(WeekplanScreen), findsOneWidget);
  });

  testWidgets('Has Giraf App Bar', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();
    expect(find.byType(GirafAppBar), findsOneWidget);
  });

  testWidgets('Has edit/rediger button', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Rediger'), findsOneWidget);
  });

  testWidgets('Click on edit icon toggles edit mode',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    bool currentEditMode = false;
    weekplanBloc.editMode.listen((bool editMode) {
      currentEditMode = editMode;
    });
    // Initial edit mode should be false
    expect(currentEditMode, false);

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pump();

    weekplanBloc.editMode.listen((bool editMode) {
      currentEditMode = editMode;
    });
    // After tapping the button edit mode should be true
    expect(currentEditMode, true);

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pump();
    weekplanBloc.editMode.listen((bool editMode) {
      currentEditMode = editMode;
    });
    // After tapping the button agian it should be false
    expect(currentEditMode, false);
  });

  testWidgets('No activity cards when no activities are added',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();
    // After tapping the button edit mode should be true
    expect(find.byType(ActivityCard), findsNothing);
  });

  testWidgets('Each added activity gets an activity card',
      (WidgetTester tester) async {
    // We add an activity to monday and one to tuesday
    mockWeek.days[0].activities.add(mockActivities[0]);
    mockWeek.days[1].activities.add(mockActivities[1]);
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    // After tapping the button edit mode should be true
    expect(find.byType(ActivityCard), findsNWidgets(2));
  });

  testWidgets('Tapping activity when not in edit mode pushes activity screen',
      (WidgetTester tester) async {
    mockWeek.days[0].activities.add(mockActivities[0]);
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ActivityCard));
    await tester.pumpAndSettle();
    expect(find.byType(ShowActivityScreen), findsOneWidget);
  });

  testWidgets('Tapping activity in edit mode selects/deselects it',
      (WidgetTester tester) async {
    mockWeek.days[0].activities.add(mockActivities[0]);
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    //We enter edit mode.
    await tester.tap(find.byTooltip('Rediger'));
    await tester.pump();

    expect(weekplanBloc.getNumberOfMarkedActivities(), 0);

    await tester.tap(find.byType(ActivityCard));
    await tester.pumpAndSettle();
    expect(weekplanBloc.getNumberOfMarkedActivities(), 1);

    await tester.tap(find.byType(ActivityCard));
    await tester.pumpAndSettle();
    expect(weekplanBloc.getNumberOfMarkedActivities(), 0);
  });

  testWidgets('Cancel/Copy/Delete buttons not build when edit mode is false',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is BottomAppBarButton &&
            widget.buttonText == 'Aflys' &&
            widget.buttonKey == 'CancelActivtiesButton'),
        findsNothing);

    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is BottomAppBarButton &&
            widget.buttonText == 'Kopier' &&
            widget.buttonKey == 'CopyActivtiesButton'),
        findsNothing);

    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is BottomAppBarButton &&
            widget.buttonText == 'Slet' &&
            widget.buttonKey == 'DeleteActivtiesButton'),
        findsNothing);
  });

  testWidgets('Cancel/Copy/Delete buttons are built when edit mode is true',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    // Toggle edit mode by pressing the edit mode button
    await tester.tap(find.byTooltip('Rediger'));
    await tester.pump();

    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is BottomAppBarButton &&
            widget.buttonText == 'Aflys' &&
            widget.buttonKey == 'CancelActivtiesButton'),
        findsOneWidget);

    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is BottomAppBarButton &&
            widget.buttonText == 'Kopier' &&
            widget.buttonKey == 'CopyActivtiesButton'),
        findsOneWidget);

    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is BottomAppBarButton &&
            widget.buttonText == 'Slet' &&
            widget.buttonKey == 'DeleteActivtiesButton'),
        findsOneWidget);
  });

  testWidgets(
      'Cancel/Copy/Delete buttons do not open dialog when no activites are selected',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pump();

    await tester.tap(find.byWidgetPredicate((Widget widget) =>
        widget is BottomAppBarButton &&
        widget.buttonText == 'Aflys' &&
        widget.buttonKey == 'CancelActivtiesButton'));
    await tester.pumpAndSettle();

    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is GirafConfirmDialog &&
            widget.title == 'Aflys aktiviteter'),
        findsNothing);

    await tester.tap(find.byWidgetPredicate((Widget widget) =>
        widget is BottomAppBarButton &&
        widget.buttonText == 'Kopier' &&
        widget.buttonKey == 'CopyActivtiesButton'));
    await tester.pumpAndSettle();

    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is GirafCopyActivitiesDialog &&
            widget.title == 'Kopier aktiviteter'),
        findsNothing);

    await tester.tap(find.byWidgetPredicate((Widget widget) =>
        widget is BottomAppBarButton &&
        widget.buttonText == 'Slet' &&
        widget.buttonKey == 'DeleteActivtiesButton'));
    await tester.pumpAndSettle();

    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is GirafConfirmDialog && widget.title == 'Slet aktiviteter'),
        findsNothing);
  });

  testWidgets('Cancel activity button opens dialog when activity is selected',
      (WidgetTester tester) async {
    mockWeek.days[0].activities.add(mockActivities[0]);
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    // Toggle edit mode by pressing the edit mode button
    await tester.tap(find.byTooltip('Rediger'));
    await tester.pump();

    // Selecting an activity
    await tester.tap(find.byType(ActivityCard));
    await tester.pumpAndSettle();

    // Tapping cancel activities button
    await tester.tap(find.byWidgetPredicate((Widget widget) =>
        widget is BottomAppBarButton &&
        widget.buttonText == 'Aflys' &&
        widget.buttonKey == 'CancelActivtiesButton'));
    await tester.pumpAndSettle();

    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is GirafConfirmDialog &&
            widget.title == 'Aflys aktiviteter'),
        findsOneWidget);
  });

  // TODO(eneder17): test functinality of these three buttons and rename tests
  testWidgets('Copy activity button works when activity is selected',
      (WidgetTester tester) async {
    mockWeek.days[0].activities.add(mockActivities[0]);
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    // Toggle edit mode by pressing the edit mode button
    await tester.tap(find.byTooltip('Rediger'));
    await tester.pump();

    // Selecting an activity
    await tester.tap(find.byType(ActivityCard));
    await tester.pumpAndSettle();

    // Tapping copy activities button
    await tester.tap(find.byWidgetPredicate((Widget widget) =>
        widget is BottomAppBarButton &&
        widget.buttonText == 'Kopier' &&
        widget.buttonKey == 'CopyActivtiesButton'));
    await tester.pumpAndSettle();

    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is GirafCopyActivitiesDialog &&
            widget.title == 'Kopier aktiviteter'),
        findsOneWidget);
  });

  testWidgets('Delete activity button opens dialog when activity is selected',
      (WidgetTester tester) async {
    mockWeek.days[0].activities.add(mockActivities[0]);
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    // Toggle edit mode by pressing the edit mode button
    await tester.tap(find.byTooltip('Rediger'));
    await tester.pump();

    // Selecting an activity
    await tester.tap(find.byType(ActivityCard));
    await tester.pumpAndSettle();

    // Tapping copy activities button
    await tester.tap(find.byWidgetPredicate((Widget widget) =>
        widget is BottomAppBarButton &&
        widget.buttonText == 'Slet' &&
        widget.buttonKey == 'DeleteActivtiesButton'));
    await tester.pumpAndSettle();

    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is GirafConfirmDialog && widget.title == 'Slet aktiviteter'),
        findsOneWidget);
  });

  testWidgets('Has 7 select all buttons', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pump();

    expect(weekplanBloc.getNumberOfMarkedActivities(), 0);
    expect(find.byKey(const Key('SelectAllButton')), findsNWidgets(7));
  });

  testWidgets('Has 7 deselect all buttons', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pump();

    expect(weekplanBloc.getNumberOfMarkedActivities(), 0);
    expect(find.byKey(const Key('DeselectAllButton')), findsNWidgets(7));
  });

  testWidgets('Marks all and unmarks all activities for a given day',
      (WidgetTester tester) async {
    // Adding two activities too monday
    mockWeek.days[0].activities.add(mockActivities[0]);
    mockWeek.days[0].activities.add(mockActivities[1]);
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pump();
    expect(weekplanBloc.getNumberOfMarkedActivities(), 0);

    // Checking that the select all activities button works
    await tester.tap(find.byKey(const Key('SelectAllButton')).first);
    await tester.pump();
    expect(weekplanBloc.getNumberOfMarkedActivities(), 2);

    // Checking that the Deselect all activities button works
    await tester.tap(find.byKey(const Key('DeselectAllButton')).first);
    await tester.pump();
    expect(weekplanBloc.getNumberOfMarkedActivities(), 0);
  });

  testWidgets('When showing one day, one weekday row is created',
      (WidgetTester tester) async {
    authBloc.setMode(WeekplanMode.citizen);
    final WeekplanScreen weekplanScreen = WeekplanScreen(mockWeek, user);

    await tester.pumpWidget(MaterialApp(home: weekplanScreen));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('SingleWeekdayRow')), findsOneWidget);
  });

  testWidgets('When showing 5 days, 5 weekday columns are created',
      (WidgetTester tester) async {
    mockSettings.nrOfDaysToDisplay = 5;
    authBloc.setMode(WeekplanMode.citizen);
    final WeekplanScreen weekplanScreen = WeekplanScreen(mockWeek, user);

    await tester.pumpWidget(MaterialApp(home: weekplanScreen));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('SingleWeekdayRow')), findsNothing);
    expect(find.byType(Column), findsNWidgets(5));
  });

  testWidgets('When showing 7 days, 7 weekday columns are created',
      (WidgetTester tester) async {
    mockSettings.nrOfDaysToDisplay = 7;
    authBloc.setMode(WeekplanMode.citizen);
    final WeekplanScreen weekplanScreen = WeekplanScreen(mockWeek, user);

    await tester.pumpWidget(MaterialApp(home: weekplanScreen));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('SingleWeekdayRow')), findsNothing);
    expect(find.byType(Column), findsNWidgets(7));
  });

  testWidgets(
      'Week day colors should be in correct order regardless of order in DB',
      (WidgetTester tester) async {
    mockSettings.nrOfDaysToDisplay = 7;
    mockWeek.days = <WeekdayModel>[
      WeekdayModel(activities: <ActivityModel>[], day: Weekday.Monday),
      WeekdayModel(activities: <ActivityModel>[], day: Weekday.Tuesday),
      WeekdayModel(activities: <ActivityModel>[], day: Weekday.Wednesday),
      WeekdayModel(activities: <ActivityModel>[], day: Weekday.Thursday),
      WeekdayModel(activities: <ActivityModel>[], day: Weekday.Friday),
      WeekdayModel(activities: <ActivityModel>[], day: Weekday.Saturday),
      WeekdayModel(activities: <ActivityModel>[], day: Weekday.Sunday)
    ];

    authBloc.setMode(WeekplanMode.citizen);
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    for (WeekdayColorModel dayColor in mockSettings.weekDayColors) {
      expectColorDayMatch(dayColor.day, dayColor.hexColor);
    }
  });

  testWidgets(
      'Pictogram text renders when settings are set to display '
      'pictogram text', (WidgetTester tester) async {
    // Enable the setting that displays pictogram text
    mockSettings.pictogramText = true;

    // Add an activity to the week we want to look at in the weekPlan screen
    mockWeek.days[4].activities.add(mockActivities[0]);

    // Build the weekPlan screen
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    expect(find.byType(PictogramText), findsOneWidget);

    // Get the title of the activity
    final String title = mockActivities[0].pictogram.title;

    expect(find.text(title.toUpperCase()), findsOneWidget);
  });

  testWidgets('Changing to Citizen works', (WidgetTester tester) async {
    authBloc.setMode(WeekplanMode.guardian);

    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    await tester.tap(find.byWidgetPredicate((Widget widget) =>
        widget is IconButton && widget.tooltip == 'Skift til borger tilstand'));
    await tester.pumpAndSettle();

    expect(find.byType(GirafConfirmDialog), findsOneWidget);

    await tester.tap(find.byWidgetPredicate((Widget widget) =>
        widget is GirafButton &&
        widget.key == const Key('ConfirmDialogConfirmButton')));
    await tester.pumpAndSettle();

    authBloc.mode
        .listen((WeekplanMode mode) => expect(mode, WeekplanMode.citizen));
  });

  testWidgets('Changing to Guardian works', (WidgetTester tester) async {
    authBloc.setMode(WeekplanMode.citizen);

    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is IconButton &&
            widget.tooltip == 'Skift til værge tilstand'),
        findsOneWidget);

    await tester.tap(find.byWidgetPredicate((Widget widget) =>
        widget is IconButton && widget.tooltip == 'Skift til værge tilstand'));
    await tester.pumpAndSettle();

    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is DialogButton &&
            widget.key == const Key('SwitchToGuardianSubmit')),
        findsOneWidget);

    await tester.tap(find.text('Bekræft'));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    authBloc.mode
        .listen((WeekplanMode mode) => expect(mode, WeekplanMode.guardian));
  });

  testWidgets('Add Activity buttons work', (WidgetTester tester) async {
    mockSettings.nrOfDaysToDisplay = 7;
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    expect(find.byType(RaisedButton), findsNWidgets(7));

    await tester.tap(find.byType(RaisedButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(PictogramSearch), findsOneWidget);
  });

  testWidgets('Finished activities displayed correctly',
      (WidgetTester tester) async {
    mockSettings.completeMark = CompleteMark.Checkmark;
    mockSettings.cancelMark = CancelMark.Cross;
    mockSettings.pictogramText = true;

    mockActivities[0].state = ActivityState.Completed;
    mockActivities[1].state = ActivityState.Canceled;

    // Added the activity that is completed with checkmark
    mockWeek.days[0].activities.add(mockActivities[0]);
    // Cancelled activity with a cross
    mockWeek.days[1].activities.add(mockActivities[1]);
    // Activity with a timer
    mockWeek.days[2].activities.add(mockActivities[2]);

    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    // Find checkmark icon by key
    expect(find.byKey(const Key('IconComplete')), findsOneWidget);
    // Find cross icon by key
    expect(find.byKey(const Key('IconCanceled')), findsOneWidget);

    // Find timer icon
    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is ImageIcon &&
            widget.image == const AssetImage('assets/icons/redcircle.png')),
        findsOneWidget);
  });
}

void expectColorDayMatch(Weekday day, String color) {
  String dayString = '';
  if (day == Weekday.Monday) {
    dayString = 'Mandag';
  } else if (day == Weekday.Tuesday) {
    dayString = 'Tirsdag';
  } else if (day == Weekday.Wednesday) {
    dayString = 'Onsdag';
  } else if (day == Weekday.Thursday) {
    dayString = 'Torsdag';
  } else if (day == Weekday.Friday) {
    dayString = 'Fredag';
  } else if (day == Weekday.Saturday) {
    dayString = 'Lørdag';
  } else {
    dayString = 'Søndag';
  }

  final Finder findColor = find.byWidgetPredicate((Widget widget) =>
      widget is Card && widget.color == Color(int.parse(color)));
  final Finder findTitle = find.byWidgetPredicate(
      (Widget widget) => widget is Card && widget.key == Key(dayString));

  expect(find.descendant(of: findColor, matching: findTitle), findsOneWidget);
}
