import 'package:async_test/async_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/activity_bloc.dart';
import 'package:weekplanner/models/enums/activity_state_enum.dart';
import 'package:test_api/test_api.dart';
import 'package:weekplanner/models/username_model.dart';
import 'package:weekplanner/providers/api/api.dart';
import 'package:weekplanner/providers/api/week_api.dart';
import 'package:weekplanner/models/activity_model.dart';
import 'package:weekplanner/models/weekday_model.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/models/enums/weekday_enum.dart';

class MockWeekApi extends Mock implements WeekApi {}

void main(){
  ActivityBloc bloc;
  Api api;
  MockWeekApi weekApi;

  final UsernameModel user = UsernameModel(id: '50', name: null, role: null);

  final ActivityModel activity = ActivityModel(id: 1, pictogram: null, order: 1,
      state: ActivityState.Normal, isChoiceBoard: false);

  final List<ActivityModel> activityList = <ActivityModel>[activity];

  final WeekdayModel weekdaymodel =
    WeekdayModel(day: Weekday.Monday, activities: activityList);

  final List<WeekdayModel> weekdaymodelList = <WeekdayModel>[weekdaymodel];

  final WeekModel weekModel = WeekModel(thumbnail: null, name: 'testweek',
      days: weekdaymodelList, weekNumber: 1, weekYear: 2010);

  void setupApiCalls() {
    when(weekApi.update(user.id, 2010, 1, weekModel)).thenAnswer(
            (_) => BehaviorSubject<WeekModel>.seeded(weekModel));
  }

  setUp(() {
    api = Api('any');
    weekApi = MockWeekApi();
    api.week = weekApi;
    bloc = ActivityBloc(api);

    setupApiCalls();
  });

  test('Should set activity to completed', async((DoneFn done){
    final ActivityModel localActivity = activity;

    bloc.load(weekModel, localActivity, user);
    bloc.completeActivity();

    expect(localActivity.state, equals(ActivityState.Completed));
    done();
  }));

  test('Should set activity to cancelled', async((DoneFn done){
    final ActivityModel localActivity = activity;

    bloc.load(weekModel, localActivity, user);
    bloc.cancelActivity();

    expect(localActivity.state, equals(ActivityState.Canceled));
    done();
  }));
}

