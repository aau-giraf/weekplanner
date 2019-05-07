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

  /// BehaviorSubject for the updated weekModel.
  final BehaviorSubject<double> _timerProgressStream =
      BehaviorSubject<double>.seeded(0.0);

  /// stream for checking if the timer is running
  Stream<bool> get timerIsRunning => _timerRunningStream.stream;

  /// BehaviorSubject for to check if timer is running.
  final BehaviorSubject<bool> _timerRunningStream =
      BehaviorSubject<bool>.seeded(false);

  /// stream for checking if the timer is running
  Stream<bool> get timerIsInstantiated => _timerInstantiatedStream.stream;

  /// BehaviorSubject for to check if timer is running.
  final BehaviorSubject<bool> _timerInstantiatedStream =
      BehaviorSubject<bool>.seeded(false);

  /// Loads the activity that should be used in the timerBloc
  void load(ActivityModel activity) {
    _activityModel = activity;

    _activityModel.timer != null
        ? _timerInstantiatedStream.add(true)
        : _timerInstantiatedStream.add(false);
  }

  /// Adds a timer to the activity loaded into the timerBloc.
  /// By default the timer will be paused.
  void addTimer(Duration duration) {
    _activityModel.timer = TimerModel(
        startTime: DateTime.now(),
        progress: 0,
        fullLength: duration.inMilliseconds,
        paused: true);
    _timerInstantiatedStream.add(true);
    _timerProgressStream.add(0);
  }

  CountdownTimer _countDown;
  StreamSubscription<CountdownTimer> _timerStream;
  Stopwatch _stopwatch;

  /// Method for initialising a timer in an activity.
  /// If the timer is playing the progressCircle will start immediately.
  /// Else it will be paused.
  void initTimer({int updatePeriod = 10}) {
    if (_stopwatch == null) {
      if (_activityModel.timer != null) {
        final DateTime endTime = _activityModel.timer.startTime.add(Duration(
            milliseconds: _activityModel.timer.fullLength -
                _activityModel.timer.progress));

        if (_activityModel.timer.startTime.isBefore(DateTime.now()) &&
            DateTime.now().isBefore(endTime) &&
            !_activityModel.timer.paused) {
          _timerRunningStream.add(true);

          _stopwatch = Stopwatch();
          _countDown = CountdownTimer(endTime.difference(DateTime.now()),
              Duration(milliseconds: updatePeriod),
              stopwatch: _stopwatch);

          _timerStream = _countDown.listen((CountdownTimer c) {
            _timerProgressStream.add(1 -
                (1 /
                    _activityModel.timer.fullLength *
                    c.remaining.inMilliseconds));
          });
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
  }

  /// Plays the timer.
  /// The method will use the current time, the progress of the timer and
  /// the full length, to calculate the progress of the progress circle in
  /// the widget.
  /// Updates the timer in the database accordingly.
  void playTimer({int updatePeriod = 10}) {
    if (_activityModel.timer != null && _activityModel.timer.paused) {
      _activityModel.timer.paused = false;
      _activityModel.timer.startTime = DateTime.now();

      _stopwatch = Stopwatch();

      final DateTime _endTime = _activityModel.timer.startTime.add(Duration(
          milliseconds:
              _activityModel.timer.fullLength - _activityModel.timer.progress));
      _countDown = CountdownTimer(
          _endTime.difference(_activityModel.timer.startTime),
          Duration(milliseconds: updatePeriod),
          stopwatch: _stopwatch);

      _timerStream = _countDown.listen((CountdownTimer c) {
        _timerProgressStream.add(1 -
            (1 / _activityModel.timer.fullLength * c.remaining.inMilliseconds));
      });
      _timerRunningStream.add(true);
      //update();
    }
  }

  /// Pauses the timer and updates the timer in the database accordingly.
  void pauseTimer() {
    if (_activityModel.timer != null &&
        _timerStream != null &&
        !_activityModel.timer.paused) {
      _activityModel.timer.paused = true;
      _activityModel.timer.progress += _countDown.elapsed.inMilliseconds;
      _resetCounterAndStopwatch();
      _timerRunningStream.add(false);
      //update();
    }
  }

  /// Stops the timer and resets it and updates is database.
  void stopTimer() {
    _resetCounterAndStopwatch();
    _activityModel.timer.paused = true;
    _activityModel.timer.progress = 0;
    _timerRunningStream.add(false);
    _timerProgressStream.add(0);
    //update();
  }

  /// Deletes the timer from the activity and updates is database.
  void deleteTimer() {
    _resetCounterAndStopwatch();
    _activityModel.timer = null;
    _timerInstantiatedStream.add(false);
    //update();
  }

  void _resetCounterAndStopwatch() {
    if (_stopwatch != null) {
      _stopwatch.stop();
      _countDown.cancel();
      _timerStream.cancel();
    }
    _stopwatch = null;
    _countDown = null;
    _timerStream = null;
  }

  @override
  void dispose() {
    _resetCounterAndStopwatch();
    _timerProgressStream.close();
    _timerRunningStream.close();
  }
}