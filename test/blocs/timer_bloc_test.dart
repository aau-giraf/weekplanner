import 'package:api_client/api/week_api.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/enums/activity_state_enum.dart';
import 'package:api_client/models/timer_model.dart';
import 'package:async_test/async_test.dart';
import 'package:mockito/mockito.dart';
import 'package:test_api/test_api.dart';
import 'package:weekplanner/blocs/timer_bloc.dart';

class MockWeekApi extends Mock implements WeekApi {}

void main() {
  test('Testing if timer is added to an acitivty without a timer already',
      async((DoneFn done) {
    final ActivityModel mockActivity = ActivityModel(
        id: 1,
        pictogram: null,
        order: 1,
        state: ActivityState.Normal,
        timer: null,
        isChoiceBoard: false);

    final TimerBloc timerMock = TimerBloc();

    timerMock.load(mockActivity);

    timerMock.timerIsInstantiated.last.then((bool b) {
      expect(b, isFalse);
    });
    done();
  }));

  test('Testing if timer is not added to an acitivty with a timer already',
      async((DoneFn done) {
    final ActivityModel mockActivity = ActivityModel(
        id: 1,
        pictogram: null,
        order: 1,
        state: ActivityState.Normal,
        timer: TimerModel(
            startTime: null, fullLength: 100, paused: false, progress: 50),
        isChoiceBoard: false);

    final TimerBloc timerMock = TimerBloc();

    timerMock.load(mockActivity);

    timerMock.timerIsInstantiated.last.then((bool b) {
      expect(b, isTrue);
    });
    done();
  }));

  test('Testing when timer is added the timerInstantiated streams true',
      async((DoneFn done) {
    final ActivityModel mockActivity = ActivityModel(
        id: 1,
        pictogram: null,
        order: 1,
        state: ActivityState.Normal,
        timer: null,
        isChoiceBoard: false);

    final TimerBloc timerMock = TimerBloc();
    timerMock.load(mockActivity);

    timerMock.addTimer(Duration(seconds: 100));

    expect(mockActivity.timer, isNotNull);
    expect(mockActivity.timer.progress, 0);
    expect(
        mockActivity.timer.fullLength, Duration(seconds: 100).inMilliseconds);
    expect(mockActivity.timer.paused, true);
    expect(mockActivity.timer.startTime, isNotNull);

    timerMock.timerIsInstantiated.last.then((bool b) {
      expect(b, isTrue);
    });
    done();
  }));

  test('Testing timer starts running if its already set', async((DoneFn done) {
    final ActivityModel mockActivity = ActivityModel(
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

    final TimerBloc timerMock = TimerBloc();
    timerMock.load(mockActivity);
    timerMock.initTimer();

    timerMock.timerIsRunning.last.then((bool b) {
      expect(b, isTrue);
    });
    timerMock.timerIsInstantiated.last.then((bool b) {
      expect(b, isTrue);
    });
    done();
  }));

  test('Testing if timer is paused the progress is updated',
      async((DoneFn done) {
    final ActivityModel mockActivity = ActivityModel(
        id: 1,
        pictogram: null,
        order: 1,
        state: ActivityState.Normal,
        timer: TimerModel(
            startTime: DateTime.now().add(Duration(milliseconds: 1)),
            fullLength: 1000,
            paused: true,
            progress: 1),
        isChoiceBoard: false);

    final TimerBloc timerMock = TimerBloc();
    timerMock.load(mockActivity);
    timerMock.initTimer();

    timerMock.timerIsRunning.last.then((bool b) {
      expect(b, isFalse);
    });
    timerMock.timerIsInstantiated.last.then((bool b) {
      expect(b, isTrue);
    });

    timerMock.timerProgressStream.last.then((double d) {
      expect(
          d,
          1 -
              (1 /
                  mockActivity.timer.fullLength *
                  (mockActivity.timer.fullLength -
                      mockActivity.timer.progress)));
    });
    done();
  }));

  test('Testing if timer play un-paused stream, and the progress is streamed',
      async((DoneFn done) {
    final ActivityModel mockActivity = ActivityModel(
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

    final TimerBloc timerMock = TimerBloc();
    timerMock.load(mockActivity);
    timerMock.playTimer(updatePeriod: 1);

    expect(mockActivity.timer.paused, isFalse);
    timerMock.timerIsInstantiated.last.then((bool b) {
      expect(b, isTrue);
    });

    timerMock.timerProgressStream.last.then((double d) {
      expect(d, isPositive);
    });
    done();
  }));

  test('Testing when timer is played the progress is streamed',
      async((DoneFn done) {
    final ActivityModel mockActivity = ActivityModel(
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

    final TimerBloc timerMock = TimerBloc();
    timerMock.load(mockActivity);
    timerMock.playTimer();
    expect(mockActivity.timer.paused, isFalse);

    timerMock.timerProgressStream.last.then((double d) {
      expect(d, isPositive);
    });
    done();
  }));

  test(
      'Testing when timer is paused, the progress is '
          'upadated and the stream shows false',
      async((DoneFn done) {
    final ActivityModel mockActivity = ActivityModel(
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

    final TimerBloc timerMock = TimerBloc();
    timerMock.load(mockActivity);

    timerMock.playTimer();
    expect(mockActivity.timer.paused, isFalse);

    timerMock.pauseTimer();
    Future.delayed(Duration(seconds: 1), () {
      expect(mockActivity.timer.paused, isTrue);
      expect(mockActivity.timer.progress, isPositive);
    });

    timerMock.timerIsRunning.last.then((bool b) {
      expect(b, isFalse);
    });
    done();
  }));

  test(
      'Testing when timer is stopped, timer status is paused, progress is '
      'reset, and running stream is false and progress stream is 0',
      async((DoneFn done) {
    final ActivityModel mockActivity = ActivityModel(
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

    final TimerBloc timerMock = TimerBloc();
    timerMock.load(mockActivity);

    timerMock.playTimer();
    expect(mockActivity.timer.paused, isFalse);

    timerMock.stopTimer();

    Future.delayed(Duration(seconds: 1), () {
      expect(mockActivity.timer.paused, isTrue);
      expect(mockActivity.timer.progress, 0);
    });

    timerMock.timerIsRunning.last.then((bool b) {
      expect(b, isFalse);
    });

    timerMock.timerProgressStream.last.then((double d) {
      expect(d, 0);
    });
    done();
  }));

  test(
      'Testing when timer is deleted, timer is null, and initiated timer '
      'stream is false', async((DoneFn done) {
    final ActivityModel mockActivity = ActivityModel(
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

    final TimerBloc timerMock = TimerBloc();
    timerMock.load(mockActivity);
    timerMock.deleteTimer();

    expect(mockActivity.timer, isNull);
    timerMock.timerIsInstantiated.last.then((bool b) {
      expect(b, isFalse);
    });

    timerMock.timerProgressStream.last.then((double d) {
      expect(d, 0);
    });
    done();
  }));
}
