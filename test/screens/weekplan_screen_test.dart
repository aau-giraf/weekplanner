import 'package:api_client/api/activity_api.dart';
import 'package:api_client/api/api.dart';
import 'package:api_client/api/pictogram_api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/api/week_api.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/access_level_enum.dart';
import 'package:api_client/models/enums/activity_state_enum.dart';
import 'package:api_client/models/enums/cancel_mark_enum.dart';
import 'package:api_client/models/enums/complete_mark_enum.dart';
import 'package:api_client/models/enums/default_timer_enum.dart';
import 'package:api_client/models/enums/giraf_theme_enum.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/enums/weekday_enum.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/weekday_color_model.dart';
import 'package:api_client/models/weekday_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/activity_bloc.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/pictogram_bloc.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/blocs/timer_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/blocs/weekplan_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/enums/weekplan_mode.dart';
import 'package:weekplanner/screens/show_activity_screen.dart';
import 'package:weekplanner/screens/weekplan_screen.dart';
import 'package:api_client/models/enums/orientation_enum.dart' as orientation;
import 'package:weekplanner/widgets/activity_card.dart';
import 'package:weekplanner/widgets/bottom_app_bar_button_widget.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/pictogram_text.dart';
import '../test_image.dart';

// TODO(eneder17): overvej at mocke auth bloc, tror ikke det bliver nødvendigt.

WeekModel mockWeek;
SettingsModel mockSettings;
List<ActivityModel> mockActivities;

class MockWeekApi extends Mock implements WeekApi {
  @override
  Observable<WeekModel> get(String id, int year, int weekNumber) {
    return Observable<WeekModel>.just(mockWeek);
  }

  @override
  Observable<WeekModel> update(String id, int year, int weekNumber,
      WeekModel weekInput) {
    mockWeek = weekInput;
    return Observable<WeekModel>.just(mockWeek);
  }
}

class MockUserApi extends Mock implements UserApi {
  @override
  Observable<GirafUserModel> me() {
    return Observable<GirafUserModel>.just(GirafUserModel(
      id: '1',
      department: 3,
      role: Role.Guardian,
      roleName: 'Guardian',
      displayName: 'Kurt',
      username: 'SpaceLord69',
    ));
  }

  @override
  Observable<SettingsModel> getSettings(String id) {
    return Observable<SettingsModel>.just(mockSettings);
  }

  @override
  Observable<SettingsModel> updateSettings(String id, SettingsModel settings) {
    mockSettings = settings;
    return Observable<SettingsModel>.just(mockSettings);
  }
}

// TODO(eneder17): få tjekket vi ikke bruger add() nogle steder
//  fordi så skal den også mockes
class MockActivityApi extends Mock implements ActivityApi {
  @override
  Observable<ActivityModel> update(ActivityModel activity, String userId) {
    final int amtActivities = mockActivities.length;

    //We look for the activity with the same id, and update.
    for(int i = 0; i < amtActivities; i++) {
      if(activity.id == mockActivities[i].id) {
        mockActivities[i] = activity;
        return Observable<ActivityModel>.just(mockActivities[i]);
      }
    }
    // Else we just return the activity put in as input
    return Observable<ActivityModel>.just(activity);
  }
}

class MockPictogramApi extends Mock implements PictogramApi {
  @override
  Observable<Image> getImage(int id) {
    //We take the sample image from the test_image.dart file
    final Image mockImage = sampleImage;
    return Observable<Image>.just(mockImage);
  }
}

List<WeekdayColorModel> createWeekDayColors() {
  return <WeekdayColorModel>[
    WeekdayColorModel(day: Weekday.Friday, hexColor: '0xffdddddd'),
    WeekdayColorModel(day: Weekday.Monday, hexColor: '0xff999999'),
    WeekdayColorModel(day: Weekday.Saturday, hexColor: '0xffeeeeee'),
    WeekdayColorModel(day: Weekday.Tuesday, hexColor: '0xffaaaaaa'),
    WeekdayColorModel(day: Weekday.Thursday, hexColor: '0xffcccccc'),
    WeekdayColorModel(day: Weekday.Sunday, hexColor: '0xffffffff'),
    WeekdayColorModel(day: Weekday.Wednesday, hexColor: '0xffbbbbbb'),
  ];
}

WeekModel createInitialMockWeek(){
  return WeekModel(
      thumbnail: PictogramModel(
          imageUrl: null,
          imageHash: null,
          accessLevel: null,
          title: null,
          id: null,
          lastEdit: null),
      days: <WeekdayModel>[
        WeekdayModel(activities: <ActivityModel>[], day: Weekday.Monday),
        WeekdayModel(activities: <ActivityModel>[], day: Weekday.Tuesday),
        WeekdayModel(activities: <ActivityModel>[], day: Weekday.Wednesday),
        WeekdayModel(activities: <ActivityModel>[], day: Weekday.Thursday),
        WeekdayModel(activities: <ActivityModel>[], day: Weekday.Friday),
        WeekdayModel(activities: <ActivityModel>[], day: Weekday.Saturday),
        WeekdayModel(activities: <ActivityModel>[], day: Weekday.Sunday),
      ],
      name: 'Week',
      weekNumber: 1,
      weekYear: 2020);
}

SettingsModel createInitialMockSettings() {
  return SettingsModel(
      orientation: orientation.Orientation.Portrait,
      completeMark: CompleteMark.Checkmark,
      cancelMark: CancelMark.Cross,
      defaultTimer: DefaultTimer.PieChart,
      timerSeconds: 1,
      activitiesCount: 1,
      theme: GirafTheme.GirafYellow,
      nrOfDaysToDisplay: 1,
      weekDayColors: createWeekDayColors(),
      lockTimerControl: false,
      pictogramText: false);

}

List<ActivityModel> createInitialMockActivities(){
  return <ActivityModel>[
    ActivityModel(
        id: 0,
        state: ActivityState.Normal,
        order: 0,
        isChoiceBoard: false,
        pictogram: PictogramModel(
            id: 25,
            title: 'PictogramTitle1',
            accessLevel: AccessLevel.PUBLIC,
            imageHash: null,
            imageUrl: null,
            lastEdit: null)),
    ActivityModel(
        id: 1,
        state: ActivityState.Normal,
        order: 0,
        isChoiceBoard: false,
        pictogram: PictogramModel(
            id: 25,
            title: 'PictogramTitle2',
            accessLevel: AccessLevel.PUBLIC,
            imageHash: null,
            imageUrl: null,
            lastEdit: null))
  ];
}

void main() {
  WeekplanBloc weekplanBloc;
  Api api;
  AuthBloc authBloc;
  final DisplayNameModel user = DisplayNameModel(
      role: Role.Guardian.toString(), displayName: 'User', id: '1');


  setUp(() {
    api = Api('any');

    // Setting initial values for all the mock objects
    mockSettings = createInitialMockSettings();
    mockWeek = createInitialMockWeek();
    mockActivities = createInitialMockActivities();

    api.user = MockUserApi();
    api.week = MockWeekApi();
    api.activity = MockActivityApi();
    api.pictogram = MockPictogramApi();

    authBloc = AuthBloc(api);

    weekplanBloc = WeekplanBloc(api);
    di.clearAll();
    di.registerDependency<WeekplanBloc>((_) => weekplanBloc);
    di.registerDependency<SettingsBloc>((_) => SettingsBloc(api));
    di.registerDependency<AuthBloc>((_) => authBloc);
    di.registerDependency<ToolbarBloc>((_) => ToolbarBloc());
    di.registerDependency<PictogramImageBloc>((_) => PictogramImageBloc(api));
    di.registerDependency<TimerBloc>((_) => TimerBloc(api));
    di.registerDependency<ActivityBloc>((_) => ActivityBloc(api));
    di.registerDependency<PictogramBloc>((_) => PictogramBloc(api));

    authBloc.setMode(WeekplanMode.guardian);
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

  testWidgets('Tapping an activity outside edit mode enter activity screen',
          (WidgetTester tester) async {
    mockWeek.days[0].activities.add(mockActivities[0]);
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();


    await tester.tap(find.byType(ActivityCard));
    await tester.pumpAndSettle();
    expect(find.byType(ShowActivityScreen), findsOneWidget);
  });

  testWidgets('Cancel/Copy/Delete buttons not build when edit mode is false',
          (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    expect(find.byWidgetPredicate((Widget widget) =>
      widget is BottomAppBarButton &&
      widget.buttonText == 'Aflys' &&
      widget.buttonKey == 'CancelActivtiesButton'),
    findsNothing);

    expect(find.byWidgetPredicate((Widget widget) =>
      widget is BottomAppBarButton &&
      widget.buttonText == 'Kopier' &&
      widget.buttonKey == 'CopyActivtiesButton'),
    findsNothing);

    expect(find.byWidgetPredicate((Widget widget) =>
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

    expect(find.byWidgetPredicate((Widget widget) =>
      widget is BottomAppBarButton &&
      widget.buttonText == 'Aflys' &&
      widget.buttonKey == 'CancelActivtiesButton'),
    findsOneWidget);

    expect(find.byWidgetPredicate((Widget widget) =>
      widget is BottomAppBarButton &&
      widget.buttonText == 'Kopier' &&
      widget.buttonKey == 'CopyActivtiesButton'),
    findsOneWidget);

    expect(find.byWidgetPredicate((Widget widget) =>
      widget is BottomAppBarButton &&
      widget.buttonText == 'Slet' &&
      widget.buttonKey == 'DeleteActivtiesButton'),
    findsOneWidget);
  });

  testWidgets('Cancel/Copy/Delete are disabled when no activites are selected',
          (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pump();

    /*Finder finder = find.byWidgetPredicate((Widget widget) =>
        widget is BottomAppBarButton &&
        widget.buttonText == 'Aflys' &&
        widget.buttonKey == 'CancelActivtiesButton' &&
        widget.isEnabledStream.listen(
          (bool isEnabled) => prinisEnabled)
    );*/


    //expect(finder, findsOneWidget);

    /*expect(find.byWidgetPredicate((Widget widget) =>
      widget is BottomAppBarButton &&
      widget.buttonText == 'Slet' &&
      widget.buttonKey == 'DeleteActivtiesButton' &&
      widget.isEnabledStream
    ),
        findsOneWidget);
    */
  });

  testWidgets('Cancel activity button opens dialog when activity is selected',
          (WidgetTester tester) async {
    mockWeek.days[0].activities.add(mockActivities[0]);
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    // Toggle edit mode by pressing the edit mode button
    await tester.tap(find.byTooltip('Rediger'));
    await tester.pump();

    expect(true, false); //NOT DONE TEST
  });


  testWidgets('Has 7 select all buttons',
          (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pump();

    expect(weekplanBloc.getNumberOfMarkedActivities(), 0);
    expect(find.byKey(const Key('SelectAllButton')), findsNWidgets(7));
  });

  testWidgets('Has 7 deselect all buttons',
          (WidgetTester tester) async {
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

  testWidgets('Pictogram text renders when settings are set to display '
      'pictogram text', (WidgetTester tester) async{

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


