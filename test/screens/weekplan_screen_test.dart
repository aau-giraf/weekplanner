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
import 'package:weekplanner/screens/weekplan_screen.dart';
import 'package:api_client/models/enums/orientation_enum.dart' as orientation;

// TODO(): overvej at mocke auth bloc, men tror ikke det bliver nødvendigt.

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
    const Image mockImage = Image(
        image: AssetImage('assets/icons/pause.png'));

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
            title: 'grå',
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
            title: 'grå',
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

  testWidgets('Marks all and unmarks all activities for a given day',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(mockWeek, user)));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Rediger'), findsOneWidget);
    await tester.tap(find.byTooltip('Rediger'));
    await tester.pump();

    expect(weekplanBloc.getNumberOfMarkedActivities(), 0);
    expect(find.byKey(const Key('SelectAllButton')), findsNWidgets(7));
    expect(find.byKey(const Key('DeselectAllButton')), findsNWidgets(7));

    weekplanBloc.addActivity(mockActivities.first, 0);
    weekplanBloc.addActivity(mockActivities.last, 0);
    await tester.pump();

    ///checking that the select all activities button works
    await tester.tap(find.byKey(const Key('SelectAllButton')).first);
    await tester.pump();
    expect(weekplanBloc.getNumberOfMarkedActivities(), 2);

    ///checking that the Deselect all activities button works
    await tester.tap(find.byKey(const Key('DeselectAllButton')).first);
    await tester.pump();
    expect(weekplanBloc.getNumberOfMarkedActivities(), 0);
  });

  testWidgets('When showing one day, it doesnt fill the whole screen',
      (WidgetTester tester) async {
    authBloc.setMode(WeekplanMode.citizen);
    final WeekplanScreen weekplanScreen = WeekplanScreen(mockWeek, user);

    await tester.pumpWidget(MaterialApp(home: weekplanScreen));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('SingleWeekdayRow')), findsOneWidget);
  });

  testWidgets('When showing 5 days, it does fill the whole screen',
      (WidgetTester tester) async {

    mockSettings.nrOfDaysToDisplay = 5;
    authBloc.setMode(WeekplanMode.citizen);

    final WeekplanScreen weekplanScreen = WeekplanScreen(mockWeek, user);

    await tester.pumpWidget(MaterialApp(home: weekplanScreen));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('SingleWeekdayRow')), findsNothing);
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
