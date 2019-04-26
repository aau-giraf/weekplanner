import 'package:api_client/api/api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/api/week_api.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/enums/weekday_enum.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/weekday_model.dart';
import 'package:async_test/async_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test_api/test_api.dart';
import 'package:weekplanner/blocs/weekplan_bloc.dart';
import 'package:weekplanner/models/user_week_model.dart';

class MockWeekApi extends Mock implements WeekApi {}

class MockUserApi extends Mock implements UserApi {
  @override
  Observable<GirafUserModel> me() {
    return Observable<GirafUserModel>.just(GirafUserModel(
        id: '1',
        department: 3,
        role: Role.Guardian,
        roleName: 'Guardian',
        screenName: 'Kurt',
        username: 'SpaceLord69'));
  }
}

class MockWeekPlanBloc extends Mock implements WeekplanBloc {
  final BehaviorSubject<UserWeekModel> _userWeek =
      BehaviorSubject<UserWeekModel>();

  /// The stream that emits the currently chosen weekplan
  @override
  Stream<UserWeekModel> get userWeek => _userWeek.stream;

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
}

void main() {
  MockWeekPlanBloc weekplanBloc;
  Api api;
  final WeekModel week = WeekModel(
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
  WeekModel mockWeek;
  final UsernameModel user =
      UsernameModel(role: Role.Guardian.toString(), name: 'User', id: '1');

  setUp(() {
    api = Api('any');
    mockWeek = null;

    api.user = MockUserApi();
    api.week = MockWeekApi();
    when(api.week.update(any, any, any, any)).thenAnswer((_) {
      return Observable<WeekModel>.just(week);
    });

    when(api.week.get(any, any, any)).thenAnswer((Invocation inv) {
      return Observable<WeekModel>.just(mockWeek);
    });

    weekplanBloc = MockWeekPlanBloc();
  });

  test('Loads a weekplan for the weekplan view', async((DoneFn done) {
    final WeekModel week = WeekModel(name: 'test week');
    weekplanBloc.userWeek.listen((UserWeekModel response) {
      expect(response, isNotNull);
      expect(response.week, equals(week));
      done();
    });
    weekplanBloc.loadWeek(week, user);
  }));

  test('Adds an activity to a given weekplan', async((DoneFn done) {
    final UsernameModel user =
        UsernameModel(role: Role.Guardian.toString(), name: 'User', id: '1');
    final ActivityModel activity = ActivityModel(
        order: null,
        isChoiceBoard: null,
        state: null,
        id: null,
        pictogram: null);
    weekplanBloc.loadWeek(week, user);
    weekplanBloc.userWeek.skip(1).listen((UserWeekModel userWeek) {
      //verify(api.week.update(any, any, any, any));
      expect(userWeek.week, week);
      expect(userWeek.user, user);
      expect(userWeek.week.days.first.activities.length, 1);
      expect(userWeek.week.days.first.activities.first, activity);
      done();
    });
    weekplanBloc.addActivity(activity, 0);
  }));

  test('Reorder activity from monday to tuesday', async((DoneFn done) {
    mockWeek = WeekModel(
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

    final ActivityModel modelToMove = ActivityModel(
        id: 1, pictogram: null, order: 0, state: null, isChoiceBoard: false);
    mockWeek.days[0].activities.add(modelToMove);
    mockWeek.days[1].activities.add(ActivityModel(
        id: 2, pictogram: null, order: 0, state: null, isChoiceBoard: false));

    weekplanBloc.loadWeek(mockWeek, user);

    weekplanBloc.userWeek.skip(1).listen((UserWeekModel response) {
      expect(response.week.days[1].activities[0].id, 2);
      expect(response.week.days[1].activities[1].id, modelToMove.id);
      expect(response.week.days[0].activities.length, 0);
      expect(response.week.days[1].activities.length, 2);
      done();
    });

    weekplanBloc.reorderActivities(
        modelToMove, Weekday.Monday, Weekday.Tuesday, 1);
  }));

  test('Reorder activity from monday to monday', async((DoneFn done) {
    final WeekModel testWeek = WeekModel(
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

    final ActivityModel modelToMove = ActivityModel(
        id: 1, pictogram: null, order: 0, state: null, isChoiceBoard: false);
    testWeek.days[0].activities.add(modelToMove);
    testWeek.days[0].activities.add(ActivityModel(
        id: 2, pictogram: null, order: 1, state: null, isChoiceBoard: false));
    testWeek.days[0].activities.add(ActivityModel(
        id: 3, pictogram: null, order: 2, state: null, isChoiceBoard: false));

    weekplanBloc.loadWeek(testWeek, user);

    weekplanBloc.userWeek.skip(1).listen((UserWeekModel response) {
      expect(response.week.days[0].activities[0].id, 2);
      expect(response.week.days[0].activities[0].order, 0);
      expect(response.week.days[0].activities[1].id, 3);
      expect(response.week.days[0].activities[1].order, 1);
      expect(response.week.days[0].activities[2].id, 1);
      expect(response.week.days[0].activities[2].order, 2);
      done();
    });

    weekplanBloc.reorderActivities(
        modelToMove, Weekday.Monday, Weekday.Monday, 2);
  }));
}
