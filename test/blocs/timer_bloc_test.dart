import 'package:api_client/api/activity_api.dart';
import 'package:api_client/api/api.dart';
import 'package:api_client/api/week_api.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/enums/activity_state_enum.dart';
import 'package:api_client/models/timer_model.dart';
import 'package:api_client/models/username_model.dart';
import 'package:async_test/async_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/blocs/timer_bloc.dart';
import 'package:weekplanner/di.dart';

class MockWeekApi extends Mock implements WeekApi {}

class MockActivityApi extends Mock implements ActivityApi {
  @override
  Observable<ActivityModel> update(ActivityModel activity, String userId) {
    return BehaviorSubject<ActivityModel>.seeded(activity);
  }
}

void main() {
  Api api;
  MockActivityApi mockActivityApi;
  TimerBloc timerMock;
  ActivityModel activityModel;
  final UsernameModel mockUser =
      UsernameModel(name: 'test', role: 'test', id: 'test');

  setUp(() {
    api = Api('any');
    mockActivityApi = MockActivityApi();
    api.activity = mockActivityApi;
    timerMock = TimerBloc(api);

    di.clearAll();
    di.registerDependency<TimerBloc>((_) => timerMock);
  });

  test('Testing if timer is added to an acitivty without a timer already',
      async((DoneFn done) {
    activityModel = ActivityModel(
        id: 1,
        pictogram: null,
        order: 1,
        state: ActivityState.Normal,
        timer: null,
        isChoiceBoard: false);

    timerMock.timerIsInstantiated.skip(1).listen((bool b) {
      expect(b, isFalse);
      done();
    });

    timerMock.load(activityModel, user: mockUser);
  }));

  test('Testing if timer is not added to an acitivty with a timer already',
      async((DoneFn done) {
    activityModel = ActivityModel(
        id: 1,
        pictogram: null,
        order: 1,
        state: ActivityState.Normal,
        timer: TimerModel(
            startTime: null, fullLength: 100, paused: false, progress: 50),
        isChoiceBoard: false);

    timerMock.timerIsInstantiated.skip(1).listen((bool b) {
      expect(b, isTrue);
      done();
    });

    timerMock.load(activityModel, user: mockUser);
  }));

  test('Testing when timer is added the timerInstantiated streams true',
      async((DoneFn done) {
    activityModel = ActivityModel(
        id: 1,
        pictogram: null,
        order: 1,
        state: ActivityState.Normal,
        timer: null,
        isChoiceBoard: false);

    timerMock.load(activityModel, user: mockUser);
    const Duration duration = Duration(seconds: 100);

    timerMock.timerIsInstantiated.skip(1).listen((bool b) {
      expect(b, isTrue);
      expect(activityModel.timer, isNotNull);
      expect(activityModel.timer.progress, 0);
      expect(activityModel.timer.fullLength, duration.inMilliseconds);
      expect(activityModel.timer.paused, true);
      expect(activityModel.timer.startTime, isNotNull);
      done();
    });

    timerMock.addTimer(duration);
  }));

  test('Testing timer starts running if its already set', async((DoneFn done) {
    activityModel = ActivityModel(
        id: 1,
        pictogram: null,
        order: 1,
        state: ActivityState.Normal,
        timer: TimerModel(
            startTime: DateTime.now(),
            fullLength: 1000,
            paused: false,
            progress: 1),
        isChoiceBoard: false);

    timerMock.timerIsInstantiated.skip(2).listen((bool b) {
      expect(b, isTrue);
      done();
    });

    timerMock.load(activityModel, user: mockUser);
    timerMock.initTimer();
  }));

  test('Testing timer is instantiated when timer is not paused',
      async((DoneFn done) {
    activityModel = ActivityModel(
        id: 1,
        pictogram: null,
        order: 1,
        state: ActivityState.Normal,
        timer: TimerModel(
            startTime: DateTime.now(),
            fullLength: 1000,
            paused: false,
            progress: 1),
        isChoiceBoard: false);

    timerMock.timerIsRunning.skip(1).listen((bool b) {
      expect(b, isTrue);
      done();
    });

    timerMock.load(activityModel, user: mockUser);
    timerMock.initTimer();
  }));

  test('Testing if timer is paused the progress is updated',
      async((DoneFn done) {
    activityModel = ActivityModel(
        id: 1,
        pictogram: null,
        order: 1,
        state: ActivityState.Normal,
        timer: TimerModel(
            startTime: DateTime.now(),
            fullLength: 1000,
            paused: true,
            progress: 1),
        isChoiceBoard: false);

    timerMock.timerProgressStream.skip(1).listen((double d) {
      expect(
          d,
          1 -
              (1 /
                  activityModel.timer.fullLength *
                  (activityModel.timer.fullLength -
                      activityModel.timer.progress)));
      done();
    });

    timerMock.load(activityModel, user: mockUser);
    timerMock.initTimer();
  }));

  test('Testing when timer is played the progress is streamed',
      async((DoneFn done) {
    activityModel = ActivityModel(
        id: 1,
        pictogram: null,
        order: 1,
        state: ActivityState.Normal,
        timer: TimerModel(
            startTime: DateTime.now(),
            fullLength: 100,
            paused: true,
            progress: 0),
        isChoiceBoard: false);

    timerMock.load(activityModel, user: mockUser);

    int i = 0;
    timerMock.timerProgressStream.skip(1).listen((double d) {
      i += 1;
      if (i == 5) {
        expect(d, isPositive);
        done();
      }
    });

    timerMock.playTimer();
  }));

  test(
      'Testing when timer is paused, the progress is '
      'upadated and the stream shows false', async((DoneFn done) {
    activityModel = ActivityModel(
        id: 1,
        pictogram: null,
        order: 1,
        state: ActivityState.Normal,
        timer: TimerModel(
            startTime: DateTime.now(),
            fullLength: 10000,
            paused: true,
            progress: 0),
        isChoiceBoard: false);

    timerMock.load(activityModel, user: mockUser);

    timerMock.playTimer();
    expect(activityModel.timer.paused, isFalse);

    Future<dynamic>.delayed(const Duration(seconds: 1), () {
      expect(activityModel.timer.paused, isTrue);
      expect(activityModel.timer.progress, isPositive);
    });

    timerMock.timerIsRunning.skip(1).listen((bool b) {
      expect(b, isFalse);
      done();
    });

    timerMock.pauseTimer();
  }));

  test(
      'Testing when timer is stopped, timer status is paused, progress is '
      'reset, and running stream is false and progress stream is 0',
      async((DoneFn done) {
    activityModel = ActivityModel(
        id: 1,
        pictogram: null,
        order: 1,
        state: ActivityState.Normal,
        timer: TimerModel(
            startTime: DateTime.now(),
            fullLength: 100,
            paused: false,
            progress: 20),
        isChoiceBoard: false);

    timerMock.load(activityModel, user: mockUser);
    timerMock.playTimer();
    timerMock.stopTimer();

    Future<dynamic>.delayed(const Duration(seconds: 1), () {
      expect(activityModel.timer.paused, isTrue);
      expect(activityModel.timer.progress, 0);
    });

    timerMock.timerIsRunning.listen((bool b) {
      expect(b, isFalse);
    });

    timerMock.timerProgressStream.listen((double d) {
      expect(d, 0);
      done();
    });
  }));

  test(
      'Testing when timer is deleted, timer is null, and initiated timer '
      'stream is false', async((DoneFn done) {
    activityModel = ActivityModel(
        id: 1,
        pictogram: null,
        order: 1,
        state: ActivityState.Normal,
        timer: TimerModel(
            startTime: DateTime.now(),
            fullLength: 100,
            paused: false,
            progress: 20),
        isChoiceBoard: false);

    timerMock.load(activityModel, user: mockUser);
    timerMock.deleteTimer();

    expect(activityModel.timer, isNull);
    timerMock.timerIsInstantiated.listen((bool b) {
      expect(b, isFalse);
    });

    timerMock.timerProgressStream.listen((double d) {
      expect(d, 0);
      done();
    });
  }));
}
