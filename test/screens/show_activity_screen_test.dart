import 'package:api_client/api/week_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/activity_bloc.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/enums/access_level_enum.dart';
import 'package:api_client/models/enums/activity_state_enum.dart';
import 'package:api_client/models/enums/weekday_enum.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/weekday_model.dart';
import 'package:api_client/api/api.dart';
import 'package:weekplanner/screens/show_activity_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

class MockWeekApi extends Mock implements WeekApi {}

void main() {
  ActivityBloc bloc;
  Api api;
  MockWeekApi weekApi;
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
  final List<WeekdayModel> mockWeekdayModels = <WeekdayModel>[
    WeekdayModel(activities: mockActivities, day: Weekday.Monday)
  ];
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
  final ActivityModel mockActivity = mockWeek.days[0].activities[0];
  final UsernameModel mockUser =
      UsernameModel(id: '42', name: null, role: null);

  void setupApiCalls() {
    when(weekApi.update(
            mockUser.id, mockWeek.weekYear, mockWeek.weekNumber, mockWeek))
        .thenAnswer((_) => BehaviorSubject<WeekModel>.seeded(mockWeek));
  }

  setUp(() {
    api = Api('any');
    weekApi = MockWeekApi();
    api.week = weekApi;
    bloc = ActivityBloc(api);

    setupApiCalls();

    di.clearAll();
    di.registerDependency<ActivityBloc>((_) => bloc);
    di.registerDependency<AuthBloc>((_) => AuthBloc(api));
    di.registerDependency<PictogramImageBloc>((_) => PictogramImageBloc(api));
    di.registerDependency<ToolbarBloc>((_) => ToolbarBloc());
  });

  testWidgets('renders', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: ShowActivityScreen(mockWeek, mockActivity, mockUser)));
  });

  testWidgets('Has Giraf App Bar', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: ShowActivityScreen(mockWeek, mockActivity, mockUser)));

    expect(find.byType(GirafAppBar), findsOneWidget);
  });

  testWidgets('Activity pictogram is rendered',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: ShowActivityScreen(mockWeek, mockActivity, mockUser)));
    await tester.pump(Duration.zero);

    expect(find.byKey(Key(mockActivity.id.toString())), findsOneWidget);
  });

  testWidgets('ButtonBar is rendered', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: ShowActivityScreen(mockWeek, mockActivity, mockUser)));

    expect(find.byKey(const Key('ButtonBarRender')), findsOneWidget);
  });

  testWidgets('Activity has checkmark when done', (WidgetTester tester) async {
    mockActivity.state = ActivityState.Completed;
    await tester.pumpWidget(MaterialApp(
        home: ShowActivityScreen(mockWeek, mockActivity, mockUser)));
    await tester.pump();

    expect(find.byKey(const Key('IconComplete')), findsOneWidget);
  });

  testWidgets('Activity has no checkmark when Normal',
      (WidgetTester tester) async {
    mockActivity.state = ActivityState.Normal;
    await tester.pumpWidget(MaterialApp(
        home: ShowActivityScreen(mockWeek, mockActivity, mockUser)));
    await tester.pump();

    expect(find.byKey(const Key('IconComplete')), findsNothing);
  });

  testWidgets('Activity is set to completed and an acitivty mark is shown',
      (WidgetTester tester) async {
    mockActivity.state = ActivityState.Normal;
    await tester.pumpWidget(MaterialApp(
        home: ShowActivityScreen(mockWeek, mockActivity, mockUser)));

    await tester.pump();
    await tester.tap(find.byKey(const Key('CompleteStateToggleButton')));

    await tester.pump();
    expect(find.byKey(const Key('IconComplete')), findsOneWidget);
  });

  testWidgets('Activity is set to normal and an acitivty mark is not shown',
      (WidgetTester tester) async {
    mockActivity.state = ActivityState.Completed;
    await tester.pumpWidget(MaterialApp(
        home: ShowActivityScreen(mockWeek, mockActivity, mockUser)));

    await tester.pump();
    await tester.tap(find.byKey(const Key('CompleteStateToggleButton')));

    await tester.pump();
    expect(find.byKey(const Key('IconComplete')), findsNothing);
  });
}
