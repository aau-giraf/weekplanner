import 'dart:async';
import 'package:api_client/models/timer_model.dart';
import 'package:quiver/async.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:api_client/models/activity_model.dart';

/// Logic for activities
class TimerBloc extends BlocBase {
  ActivityModel _activityModel;

  /// Stream for the progress of the timer.
  Stream<double> get timerProgressStream => _timerProgressStream.stream;

  /// BehaivorSubject for the updated weekmodel.
  final BehaviorSubject<double> _timerProgressStream =
      BehaviorSubject<double>.seeded(0.0);

  /// stream for checking if the timer is running
  Stream<bool> get timerIsRunning => _timerRunningStream.stream;

  /// BehaivorSubject for to check if timer is running.
  final BehaviorSubject<bool> _timerRunningStream =
      BehaviorSubject<bool>.seeded(false);

  /// stream for checking if the timer is running
  Stream<bool> get timerIsInstantiated => _timerInstantiatedStream.stream;

  /// BehaivorSubject for to check if timer is running.
  final BehaviorSubject<bool> _timerInstantiatedStream =
      BehaviorSubject<bool>.seeded(false);

  void load(ActivityModel activity) {
    _activityModel = activity;

    _activityModel.timer != null
        ? _timerInstantiatedStream.add(true)
        : _timerInstantiatedStream.add(false);
  }

  void addTimer(Duration duration) {
    _activityModel.timer = TimerModel(
        startTime: DateTime.now(),
        progress: 0,
        fullLength: duration.inSeconds,
        paused: true);
    _timerInstantiatedStream.add(true);
    _timerProgressStream.add(0);
  }

  void initTimer() {
    if (_activityModel.timer != null) {
      final DateTime endTime = _activityModel.timer.startTime.add(Duration(
          seconds:
              _activityModel.timer.fullLength - _activityModel.timer.progress));

      if (_activityModel.timer.startTime.isBefore(DateTime.now()) &&
          DateTime.now().isBefore(endTime) &&
          !_activityModel.timer.paused) {
        _timerRunningStream.add(true);
        _startCounter(endTime, _activityModel.timer.paused);
      } else if (_activityModel.timer.paused) {
        _timerRunningStream.add(false);
        _timerProgressStream.add(1 -
            (1 /
                _activityModel.timer.fullLength *
                (_activityModel.timer.fullLength -
                    _activityModel.timer.progress)));
      }
      _timerInstantiatedStream.add(true);
    }
  }

  CountdownTimer _countDown;
  StreamSubscription<CountdownTimer> _timerStream;
  Stopwatch _stopwatch;

  void _resetCounterAndStopwatch(){
    _stopwatch.stop();
    _countDown.cancel();
    _timerStream.cancel();
  }

  void _startCounter(DateTime endTime, bool paused) {
    _stopwatch = Stopwatch();
    _countDown = CountdownTimer(
        endTime.difference(DateTime.now()), Duration(seconds: 1),
        stopwatch: _stopwatch);

    _timerStream = _countDown.listen((CountdownTimer c) {
      _timerProgressStream.add(1 -
          (1 /
              _activityModel.timer.fullLength *
              (c.remaining.inMilliseconds / 1000).ceil()));
    });
  }

  void playTimer() {
    if (_activityModel.timer != null && _activityModel.timer.paused) {
      _activityModel.timer.paused = false;
      _activityModel.timer.startTime = DateTime.now();

      _stopwatch = Stopwatch();

      final DateTime _endTime = _activityModel.timer.startTime.add(Duration(
          seconds:
              _activityModel.timer.fullLength - _activityModel.timer.progress));
      _countDown = CountdownTimer(
          _endTime.difference(_activityModel.timer.startTime),
          Duration(seconds: 1),
          stopwatch: _stopwatch);

      _timerStream = _countDown.listen((CountdownTimer c) {
        _timerProgressStream.add(1 -
            (1 /
                _activityModel.timer.fullLength *
                (c.remaining.inMilliseconds / 1000).ceil()));
      });
      _timerRunningStream.add(true);
    }
    //update();
  }

  void pauseTimer() {
    if (_activityModel.timer != null &&
        _timerStream != null &&
        !_activityModel.timer.paused) {
      _activityModel.timer.paused = true;
      _activityModel.timer.progress += _countDown.elapsed.inSeconds;
      _resetCounterAndStopwatch();
      _timerRunningStream.add(false);
    }
    //update();
  }

  void stopTimer() {
    _activityModel.timer.paused = true;
    _resetCounterAndStopwatch();
    _activityModel.timer.progress = 0;
    _timerRunningStream.add(false);
    _timerProgressStream.add(0);
    //update();
  }

  void deleteTimer() {
    _activityModel.timer = null;
    _resetCounterAndStopwatch();
    _timerInstantiatedStream.add(false);
  }

  @override
  void dispose() {
    _timerProgressStream.close();
    _timerRunningStream.close();
    _resetCounterAndStopwatch();
  }
}
