import 'package:api_client/api_client.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/activity_state_enum.dart';
import 'package:api_client/models/enums/complete_mark_enum.dart';
import 'package:api_client/models/enums/weekday_enum.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/weekday_color_model.dart';
import 'package:api_client/models/weekday_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
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
import 'package:weekplanner/widgets/bottom_app_bar_button_widget.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/giraf_confirm_dialog.dart';
import 'package:weekplanner/widgets/giraf_copy_activities_dialog.dart';
import 'package:weekplanner/widgets/pictogram_text.dart';
import 'package:weekplanner/widgets/weekplan_screen_widgets/activity_card.dart';
import 'package:weekplanner/widgets/weekplan_screen_widgets/weekplan_day_column.dart';
import 'package:rxdart/rxdart.dart' as rx_dart;

import '../mock_data.dart';

void main() {
  WeekModel mockWeek;
  SettingsModel mockSettings;
  List<ActivityModel> mockActivities;
  List<PictogramModel> mockPictograms;
  DisplayNameModel user;
  WeekplanBloc weekplanBloc;
  AuthBloc authBloc;
  Api api;

  setUp(() {
    MockData mockData;
    mockData = MockData();
    mockWeek = mockData.mockWeek;
    mockSettings = mockData.mockSettings;
    mockActivities = mockData.mockActivities;
    mockPictograms = mockData.mockPictograms;
    user = mockData.mockUser;
api = mockData.mockApi;
api.pictogram=MockPictogramApi();

    authBloc = AuthBloc(api);
    authBloc.setMode(WeekplanMode.guardian);

    weekplanBloc = WeekplanBloc(api);

    di.clearAll();
    // We register the dependencies needed to build different widgets
    di.registerDependency<AuthBloc>((_) => authBloc);
    di.registerDependency<WeekplanBloc>((_) => weekplanBloc);
    di.registerDependency<Api>((_) => api);
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

  testWidgets('ChoiceBoard shows in weekplan', (WidgetTester tester) async {
    authBloc.setMode(WeekplanMode.citizen);
    mockActivities[0].state = ActivityState.Normal;
    mockActivities[0].isChoiceBoard = true;
    mockActivities[0].pictograms = mockPictograms;
    mockWeek.days[0].activities.add(mockActivities[0]);

    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('WeekPlanScreenChoiceBoard')), findsOneWidget);
  });

  testWidgets('Activity selector pops up when choiceBoard activity is tapped',
      (WidgetTester tester) async {
    authBloc.setMode(WeekplanMode.citizen);
    mockActivities[0].state = ActivityState.Normal;
    mockActivities[0].isChoiceBoard = true;
    mockActivities[0].pictograms = mockPictograms;
    mockWeek.days[0].activities.add(mockActivities[0]);

    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('WeekPlanScreenChoiceBoard')));
    await tester.pumpAndSettle();

    expect(
        find.byKey(const Key('ChoiceBoardActivitySelector')), findsOneWidget);
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

  testWidgets('Marking activity in edit mode renders a black box around it',
      (WidgetTester tester) async {
    mockWeek.days[0].activities.add(mockActivities[0]);

    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ActivityCard));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('isSelectedKey')), findsOneWidget);
  });

  testWidgets(
      'Cancel/Copy/Delete/Undo buttons not built when edit mode is false',
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

    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is BottomAppBarButton &&
            widget.buttonText == 'Genoptag' &&
            widget.buttonKey == 'GenoptagActivtiesButton'),
        findsNothing);
  });

  testWidgets(
      'Cancel/Copy/Delete/Undo buttons are built when edit mode is true',
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

    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is BottomAppBarButton &&
            widget.buttonText == 'Genoptag' &&
            widget.buttonKey == 'GenoptagActivtiesButton'),
        findsOneWidget);
  });

  testWidgets(
      'Cancel/Copy/Delete/Undo buttons do not open dialog when no activites are selected',
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

    await tester.tap(find.byWidgetPredicate((Widget widget) =>
        widget is BottomAppBarButton &&
        widget.buttonText == 'Genoptag' &&
        widget.buttonKey == 'GenoptagActivtiesButton'));
    await tester.pumpAndSettle();

    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is GirafConfirmDialog && widget.title == 'Genoptag'),
            findsNothing
    );
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

  testWidgets('Copy activity button opens dialog when activity is selected',
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

  testWidgets('Canceling an activity works', (WidgetTester tester) async {
    mockWeek.days[0].activities.add(mockActivities[0]);
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pump();

    await tester.tap(find.byType(ActivityCard).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byWidgetPredicate((Widget widget) =>
        widget is BottomAppBarButton &&
        widget is BottomAppBarButton &&
        widget.buttonText == 'Aflys' &&
        widget.buttonKey == 'CancelActivtiesButton'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('IconCanceled')), findsNothing);

    await tester.tap(find.byKey(const Key('ConfirmDialogConfirmButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('IconCanceled')), findsOneWidget);
  });

  ///Testing the undo button works "Genoptag" - knap
  testWidgets('Resuming an activity works', (WidgetTester tester) async {
    //Create a cancel activity
    mockActivities[0].state = ActivityState.Canceled;
    mockWeek.days[0].activities.add(mockActivities[0]);
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pump();

    await tester.tap(find.byType(ActivityCard).first);
    await tester.pumpAndSettle();

    await tester.tap(find.byWidgetPredicate((Widget widget) =>
        widget is BottomAppBarButton &&
        widget is BottomAppBarButton &&
        widget.buttonText == 'Genoptag' &&
        widget.buttonKey == 'GenoptagActivtiesButton'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('IconCanceled')), findsOneWidget);

    await tester.tap(find.byKey(const Key('ConfirmDialogConfirmButton')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('IconCanceled')), findsNothing);
  });

  testWidgets('Copying an activity works', (WidgetTester tester) async {

    mockWeek.days[0].activities.add(mockActivities[0]);
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    expect(mockWeek.days[0].activities.length, 1);
    expect(mockWeek.days[1].activities.length, 0);

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

    await tester.tap(find.byKey(const Key('TueCheckbox')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('DialogConfirmButton')));
    await tester.pumpAndSettle();

    expect(mockWeek.days[0].activities.length, 1);
    expect(mockWeek.days[1].activities.length, 1);
  });

  testWidgets('Deleting an activity works', (WidgetTester tester) async {
    mockWeek.days[0].activities.add(mockActivities[0]);
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    expect(mockWeek.days[0].activities.length, 1);

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

    await tester.tap(find.byKey(const Key('ConfirmDialogConfirmButton')));
    await tester.pumpAndSettle();

    expect(mockWeek.days[0].activities.length, 0);
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
    mockSettings.nrOfDaysToDisplay = 1;

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
    expect(find.byType(WeekplanDayColumn), findsNWidgets(5));
  });

  testWidgets('When showing 7 days, 7 weekday columns are created',
      (WidgetTester tester) async {
    mockSettings.nrOfDaysToDisplay = 7;
    authBloc.setMode(WeekplanMode.citizen);
    final WeekplanScreen weekplanScreen = WeekplanScreen(mockWeek, user);

    await tester.pumpWidget(MaterialApp(home: weekplanScreen));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('SingleWeekdayRow')), findsNothing);
    expect(find.byType(WeekplanDayColumn), findsNWidgets(7));
  });

  testWidgets(
      'Week day colors should be in correct order regardless of order in DB',
      (WidgetTester tester) async {
    mockSettings.nrOfDaysToDisplay = 7;
    mockSettings.weekDayColors = <WeekdayColorModel>[
      WeekdayColorModel(day: Weekday.Saturday, hexColor: '0xffeeeeee'),
      WeekdayColorModel(day: Weekday.Tuesday, hexColor: '0xffaaaaaa'),
      WeekdayColorModel(day: Weekday.Wednesday, hexColor: '0xffbbbbbb'),
      WeekdayColorModel(day: Weekday.Monday, hexColor: '0xff999999'),
      WeekdayColorModel(day: Weekday.Thursday, hexColor: '0xffcccccc'),
      WeekdayColorModel(day: Weekday.Friday, hexColor: '0xffdddddd'),
      WeekdayColorModel(day: Weekday.Sunday, hexColor: '0xffffffff'),
    ];

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
    final String title = mockActivities[0].title;

    expect(find.text(title[0].toUpperCase() + title.substring(1).toLowerCase()),
        findsOneWidget);
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

    when(api.pictogram.getAll(page: 1,
        pageSize: pageSize, query: '')).thenAnswer(
            (_) => rx_dart.BehaviorSubject<List<PictogramModel>>.seeded(
            <PictogramModel>[mockPictograms[0]]));


    mockSettings.nrOfDaysToDisplay = 7;
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    expect(find.byType(ElevatedButton), findsNWidgets(7));

    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(PictogramSearch), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 11000));

  });

  testWidgets('Completed activities displayed correctly in Guardian Mode',
      (WidgetTester tester) async {
    mockActivities[0].state = ActivityState.Completed;

    // Added the activity that is completed with checkmark
    mockWeek.days[0].activities.add(mockActivities[0]);

    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    // Find checkmark icon by key
    expect(find.byKey(const Key('IconComplete')), findsOneWidget);
  });

  testWidgets('Cancelled activities displayed correctly in Guardian Mode',
      (WidgetTester tester) async {
    mockActivities[0].state = ActivityState.Canceled;

    // Added Cancelled activity with a cross
    mockWeek.days[0].activities.add(mockActivities[0]);

    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    // Find cross (cancelled) icon by key
    expect(find.byKey(const Key('IconCanceled')), findsOneWidget);
  });

  testWidgets('Timer icon displayed correctly in Guardian Mode',
      (WidgetTester tester) async {
    // Activity with a timer
    mockWeek.days[0].activities.add(mockActivities[2]);

    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    // Find timer icon
    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is Image &&
            widget.image == const AssetImage('assets/timer/piechart_icon.png')),
        findsOneWidget);
  });

  testWidgets('Check mark completed activity mode works in Citizen Mode',
      (WidgetTester tester) async {
    authBloc.setMode(WeekplanMode.citizen);
    mockSettings.completeMark = CompleteMark.Checkmark;
    mockActivities[0].state = ActivityState.Completed;
    // Added the activity that is completed with checkmark
    mockWeek.days[0].activities.add(mockActivities[0]);
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    // Find checkmark icon by key
    expect(find.byKey(const Key('IconComplete')), findsOneWidget);
  });

  testWidgets('Greyed out completed activity mode works in Citizen Mode',
      (WidgetTester tester) async {
    authBloc.setMode(WeekplanMode.citizen);
    mockSettings.completeMark = CompleteMark.MovedRight;
    mockActivities[0].state = ActivityState.Completed;
    // Added the activity that is completed with checkmark
    mockWeek.days[0].activities.add(mockActivities[0]);
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    // Find greyed out box by key
    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is Container && widget.key == const Key('GreyOutBox')),
        findsOneWidget);
  });

  testWidgets('Remove completed activity mode works in Citizen Mode',
      (WidgetTester tester) async {
    authBloc.setMode(WeekplanMode.citizen);
    mockSettings.completeMark = CompleteMark.Removed;
    mockActivities[0].state = ActivityState.Completed;
    // Added the activity that is completed with checkmark
    mockWeek.days[0].activities.add(mockActivities[0]);
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    // Check that the opacity of the activity card is set to zero.
    expect(
        find.byWidgetPredicate(
            (Widget widget) => widget is Opacity && widget.opacity == 0.0),
        findsOneWidget);
  });

  testWidgets('Not completed activities are not hidden',
      (WidgetTester tester) async {
    authBloc.setMode(WeekplanMode.citizen);
    mockSettings.completeMark = CompleteMark.Removed;
    mockActivities[0].state = ActivityState.Normal;
    // Added the activity that is completed with checkmark
    mockWeek.days[0].activities.add(mockActivities[0]);
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    // Check that the opacity of the activity card is set to zero.
    expect(
        find.byWidgetPredicate(
            (Widget widget) => widget is Opacity && widget.opacity == 1.0),
        findsOneWidget);
  });

  testWidgets('Check mark completed activity mode works in Citizen Mode',
      (WidgetTester tester) async {
    authBloc.setMode(WeekplanMode.citizen);
    mockSettings.completeMark = CompleteMark.Checkmark;
    mockActivities[0].state = ActivityState.Completed;
    // Added the activity that is completed with checkmark
    mockWeek.days[0].activities.add(mockActivities[0]);
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    // Find checkmark icon by key
    expect(find.byKey(const Key('IconComplete')), findsOneWidget);
  });

  testWidgets('Activity lists changed name', (WidgetTester tester) async {
    authBloc.setMode(WeekplanMode.guardian);
    mockWeek.days[4].activities.add(mockActivities[3]);

    // Build the weekPlan screen
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();
    expect(find.text('Nametest'), findsOneWidget);
  });

  testWidgets('Cancelled activities displayed correctly in Citizen Mode',
      (WidgetTester tester) async {
    authBloc.setMode(WeekplanMode.citizen);
    mockActivities[0].state = ActivityState.Canceled;


    // Added Cancelled activity with a cross
    mockWeek.days[0].activities.add(mockActivities[0]);

    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    // Find cross (cancelled) icon by key
    expect(find.byKey(const Key('IconCanceled')), findsOneWidget);
  });

  testWidgets('Weekday colors are used when in citizen mode',
      (WidgetTester tester) async {
    mockSettings.nrOfDaysToDisplay = 7;

    authBloc.setMode(WeekplanMode.citizen);
    final WeekplanScreen weekplanScreen = WeekplanScreen(mockWeek, user);
    await tester.pumpWidget(MaterialApp(home: weekplanScreen));
    await tester.pumpAndSettle();

    final List<WeekdayColorModel> expectedColors = mockSettings.weekDayColors;
    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is WeekplanDayColumn &&
            widget.dayOfTheWeek == Weekday.Monday &&
            widget.color == getColorFromWeekdayColorModel(expectedColors[0])),
        findsOneWidget);

    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is WeekplanDayColumn &&
            widget.dayOfTheWeek == Weekday.Tuesday &&
            widget.color == getColorFromWeekdayColorModel(expectedColors[1])),
        findsOneWidget);

    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is WeekplanDayColumn &&
            widget.dayOfTheWeek == Weekday.Wednesday &&
            widget.color == getColorFromWeekdayColorModel(expectedColors[2])),
        findsOneWidget);

    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is WeekplanDayColumn &&
            widget.dayOfTheWeek == Weekday.Thursday &&
            widget.color == getColorFromWeekdayColorModel(expectedColors[3])),
        findsOneWidget);

    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is WeekplanDayColumn &&
            widget.dayOfTheWeek == Weekday.Friday &&
            widget.color == getColorFromWeekdayColorModel(expectedColors[4])),
        findsOneWidget);

    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is WeekplanDayColumn &&
            widget.dayOfTheWeek == Weekday.Saturday &&
            widget.color == getColorFromWeekdayColorModel(expectedColors[5])),
        findsOneWidget);

    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is WeekplanDayColumn &&
            widget.dayOfTheWeek == Weekday.Sunday &&
            widget.color == getColorFromWeekdayColorModel(expectedColors[6])),
        findsOneWidget);
  });
}

Color getColorFromWeekdayColorModel(WeekdayColorModel weekdayColorModel) {
  final String hexColor = weekdayColorModel.hexColor;
  hexColor.replaceFirst('#', '0xff');

  return Color(int.parse(hexColor));
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
