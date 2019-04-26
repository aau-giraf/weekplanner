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
import 'package:weekplanner/models/user_week_model.dart';
import 'package:weekplanner/screens/weekplan_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import '../blocs/pictogram_bloc_test.dart';
import '../blocs/weekplan_bloc_test.dart';
import '../test_image.dart';

class MockWeekPlanBloc extends Mock implements WeekplanBloc {
  final BehaviorSubject<UserWeekModel> _userWeek =
      BehaviorSubject<UserWeekModel>();

  /// The stream that emits the currently chosen weekplan
  @override
  Stream<UserWeekModel> get userWeek => _userWeek.stream;

  final WeekModel _mockweek = WeekModel(
      thumbnail: PictogramModel(
          imageUrl: null,
          imageHash: null,
          accessLevel: null,
          title: null,
          id: null,
          lastEdit: null),
      days: <WeekdayModel>[
        WeekdayModel(activities: <ActivityModel>[], day: Weekday.Monday),
        WeekdayModel(activities: <ActivityModel>[], day: Weekday.Tuesday)
      ],
      name: 'Week',
      weekNumber: 1,
      weekYear: 2019);
  @override
  void loadWeek(WeekModel week, UsernameModel user) {
    _userWeek.add(UserWeekModel(week, user));
  }

  @override
  void addActivity(ActivityModel activity, int day) {
    final WeekModel week = _userWeek.value.week;
    final UsernameModel user = _userWeek.value.user;
    week.days[day].activities.add(activity);
    loadWeek(week, user);
  }

  @override
  void reorderActivities(
      ActivityModel activity, Weekday dayFrom, Weekday dayTo, int newOrder) {
    final WeekModel week = _userWeek.value.week;
    final UsernameModel user = _userWeek.value.user;

    // Removed from dayFrom, the day the pictogram is dragged from
    int dayLength = week.days[dayFrom.index].activities.length;

    for (int i = activity.order + 1; i < dayLength; i++) {
      week.days[dayFrom.index].activities[i].order -= 1;
    }

    week.days[dayFrom.index].activities.remove(activity);

    activity.order = dayFrom == dayTo &&
            week.days[dayTo.index].activities.length == newOrder - 1
        ? newOrder - 1
        : newOrder;

    // Inserts into dayTo, the day that the pictogram is inserted to
    dayLength = week.days[dayTo.index].activities.length;

    for (int i = activity.order; i < dayLength; i++) {
      week.days[dayTo.index].activities[i].order += 1;
    }

    week.days[dayTo.index].activities.insert(activity.order, activity);

    _userWeek.add(UserWeekModel(week, user));
  }

  final BehaviorSubject<bool> _activityPlaceholderVisible =
      BehaviorSubject<bool>.seeded(false);

  @override
  Stream<bool> get activityPlaceholderVisible =>
      _activityPlaceholderVisible.stream;

  /// Used to change the visibility of the activityPlaceholder container.
  @override
  void setActivityPlaceholderVisible(bool visibility) {
    _activityPlaceholderVisible.add(visibility);
  }
}

void main() {
  WeekplanBloc bloc;
  Api api;
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
    bloc = MockWeekPlanBloc();

    when(pictogramApi.getImage(pictogramModel.id))
        .thenAnswer((_) => BehaviorSubject<Image>.seeded(sampleImage));

    di.clearAll();
    di.registerDependency<PictogramBloc>((_) => PictogramBloc(api));
    di.registerDependency<AuthBloc>((_) => AuthBloc(api));
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
    await tester.pump();

    expect(find.byKey(const Key('AddActivityButton')), findsNWidgets(7));
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
}
