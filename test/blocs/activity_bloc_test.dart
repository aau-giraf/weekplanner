import 'package:api_client/api/activity_api.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:async_test/async_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/activity_bloc.dart';
import 'package:api_client/models/enums/activity_state_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:api_client/api/api.dart';
import 'package:api_client/api/week_api.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/weekday_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/enums/weekday_enum.dart';

class MockWeekApi extends Mock implements WeekApi {}

class MockActivityApi extends Mock implements ActivityApi {}

void main() {
  ActivityBloc bloc;
  Api api;
  MockWeekApi weekApi;
  MockActivityApi activityApi;

  final DisplayNameModel mockUser =
  DisplayNameModel(id: '50', displayName: "testUser202", role: null);

  final ActivityModel mockActivity = ActivityModel(
      id: 1,
      pictogram: null,
      order: 0,
      state: ActivityState.Normal,
      isChoiceBoard: false);

  final List<ActivityModel> mockActivityList = <ActivityModel>[mockActivity];

  final WeekdayModel mockWeekdaymodel =
      WeekdayModel(day: Weekday.Monday, activities: mockActivityList);

  final List<WeekdayModel> mockWeekdaymodelList = <WeekdayModel>[
    mockWeekdaymodel
  ];

  final WeekModel mockWeekModel = WeekModel(
      thumbnail: null,
      name: 'testweek',
      days: mockWeekdaymodelList,
      weekNumber: 1,
      weekYear: 2010);

  void setupApiCalls() {
    when(weekApi.update(mockUser.id, mockWeekModel.weekYear,
            mockWeekModel.weekNumber, mockWeekModel))
        .thenAnswer((_) => BehaviorSubject<WeekModel>.seeded(mockWeekModel));
    when(activityApi.update(mockActivity, mockUser.id))
        .thenAnswer((_) => BehaviorSubject<ActivityModel>.seeded(mockActivity));
  }

  setUp(() {
    api = Api('any');
    weekApi = MockWeekApi();
    api.week = weekApi;
    activityApi = MockActivityApi();
    api.activity = activityApi;
    bloc = ActivityBloc(api);

    setupApiCalls();
  });

  test('Should set activity to completed', async((DoneFn done) {
    final ActivityModel localActivity = mockActivity;

    bloc.load(localActivity, mockUser);
    bloc.completeActivity();

    expect(localActivity.state, equals(ActivityState.Completed));
    done();
  }));

  test('Should set activity to cancelled', async((DoneFn done) {
    final ActivityModel localActivity = mockActivity;

    bloc.load(localActivity, mockUser);
    bloc.cancelActivity();

    expect(localActivity.state, equals(ActivityState.Canceled));
    done();
  }));
}
