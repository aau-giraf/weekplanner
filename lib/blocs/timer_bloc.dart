import 'dart:async';
import 'package:api_client/api/api.dart';
import 'package:api_client/models/timer_model.dart';
import 'package:api_client/models/username_model.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:quiver/async.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:api_client/models/activity_model.dart';

/// Logic for activities
class TimerBloc extends BlocBase {
  /// Constructor taking the API
  TimerBloc(this._api);

  final Api _api;

  ActivityModel _activityModel;
  UsernameModel _user;

  /// Stream for the progress of the timer.
  Observable<double> get timerProgressStream => _timerProgressStream.stream;

  /// stream for checking if the timer is running
  Observable<bool> get timerIsRunning => _timerRunningStream.stream;

  /// Stream for checking if the timer is instantiated.
  Observable<bool> get timerIsInstantiated => _timerInstantiatedStream.stream;

  /// BehaviorSubject for the progress of the timer.
  final BehaviorSubject<double> _timerProgressStream =
  BehaviorSubject<double>.seeded(0.0);

  /// BehaviorSubject for to check if timer is running.
  final BehaviorSubject<bool> _timerRunningStream =
  BehaviorSubject<bool>.seeded(false);

  /// BehaviorSubject for to check if timer is instantiated.
  final BehaviorSubject<bool> _timerInstantiatedStream =
  BehaviorSubject<bool>.seeded(false);

  CountdownTimer _countDown;
  StreamSubscription<CountdownTimer> _timerStream;
  Stopwatch _stopwatch;

  // Audio player used for ding sound.
  static final AudioPlayer _volumePlayer = AudioPlayer();

  final AudioCache _audioPlayer = AudioCache(
      prefix: 'audio/',
      fixedPlayer: _volumePlayer
  );

  final String _audioFile = 'dingSound.mp3';
  final int _updatePeriod = 1000;

  /// Loads the activity that should be used in the timerBloc
  void load(ActivityModel activity, {UsernameModel user}) {
    _activityModel = activity;

    if (user != null) {
      _user = user;
    }

    _timerInstantiatedStream.add(_activityModel.timer != null);
  }

  /// Adds a timer to the activity loaded into the timerBloc.
  /// By default the timer will be paused.
  void addTimer(Duration duration) {
    // Adds a timer to the activityModel
    _activityModel.timer = TimerModel(
        startTime: DateTime.now(),
        progress: 0,
        fullLength: duration.inMilliseconds,
        paused: true);
    // Update the streams
    _timerInstantiatedStream.add(true);
    _timerProgressStream.add(0);
    _api.activity
        .update(_activityModel, _user.id)
        .listen((ActivityModel activity) {});
  }

  /// Method for initialising a timer in an activity.
  /// If the timer is playing the progressCircle will start immediately.
  /// Else it will be paused.
  void initTimer() {
    // Checks if a stopWatch exist
    if (_stopwatch == null) {
      if (_activityModel.timer != null) {
        // Calculates the end time of the timer
        final DateTime endTime = _activityModel.timer.startTime.add(Duration(
            milliseconds: _activityModel.timer.fullLength -
                _activityModel.timer.progress));
        // Checks if the timer is running
        if (_activityModel.timer.startTime.isBefore(DateTime.now()) &&
            DateTime.now().isBefore(endTime) &&
            !_activityModel.timer.paused) {
          _timerRunningStream.add(true);

          _stopwatch = Stopwatch();
          _countDown = CountdownTimer(endTime.difference(DateTime.now()),
              Duration(milliseconds: _updatePeriod),
              stopwatch: _stopwatch);

          _timerStream = _countDown.listen((CountdownTimer c)
            => updateTimerProgress(c));

          // Do an initial update
          updateTimerProgress(_countDown);
        } else if (_activityModel.timer.paused) {
          _timerRunningStream.add(false);
          _timerProgressStream.add(1 -
              (1 /
                  _activityModel.timer.fullLength *
                  (_activityModel.timer.fullLength -
                      _activityModel.timer.progress)));
        } else {
          _timerProgressStream.add(1);
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
  void playTimer() {
    // Makes sure that a timer exist
    if (_activityModel.timer != null && _activityModel.timer.paused) {
      _activityModel.timer.paused = false;
      _activityModel.timer.startTime = DateTime.now();

      _stopwatch = Stopwatch();
      // Calculates the end time
      final DateTime _endTime = _activityModel.timer.startTime.add(Duration(
          milliseconds:
          _activityModel.timer.fullLength - _activityModel.timer.progress));
      _countDown = CountdownTimer(
          _endTime.difference(_activityModel.timer.startTime),
          Duration(milliseconds: _updatePeriod),
          stopwatch: _stopwatch);

      _timerStream = _countDown.listen((CountdownTimer c) {
        updateTimerProgress(c);
        if (_stopwatch.isRunning && DateTime.now().isAfter(_endTime)) {
          playSound();
          stopTimer();
        }
      });
      _timerRunningStream.add(true);

      _api.activity
          .update(_activityModel, _user.id)
          .listen((ActivityModel activity) {});
    }
  }

  /// Calculate progress and write it to the _timerProgressStream
  void updateTimerProgress(CountdownTimer c){
    _timerProgressStream.add(1 -
        (1 / _activityModel.timer.fullLength * c.remaining.inMilliseconds));
  }


  /// Plays ding sound from mp3 file.
  Future<void> playSound() async {
    _volumePlayer.setVolume(500);
    _audioPlayer.load(_audioFile);
    _audioPlayer.play(_audioFile);
    _audioPlayer.clear(_audioFile);
  }

  /// Pauses the timer and updates the timer in the database accordingly.
  void pauseTimer() {
    // First make sure that a timer exists and it is running
    if (_activityModel.timer != null &&
        _timerStream != null &&
        !_activityModel.timer.paused) {
      _activityModel.timer.paused = true;
      _activityModel.timer.progress = _activityModel.timer.fullLength -
          _countDown.remaining.inMilliseconds;
      _resetCounterAndStopwatch();
      _timerRunningStream.add(false);

      _api.activity
          .update(_activityModel, _user.id)
          .listen((ActivityModel activity) {});
    }
  }

  /// Stops the timer and resets it and updates is database.
  void stopTimer() {
    _resetCounterAndStopwatch();
    _activityModel.timer.paused = true;
    _activityModel.timer.progress = 0;
    _timerRunningStream.add(false);
    _timerProgressStream.add(0);

    _api.activity
        .update(_activityModel, _user.id)
        .listen((ActivityModel activity) {});
  }

  /// Deletes the timer from the activity and updates is database.
  void deleteTimer() {
    _resetCounterAndStopwatch();
    _activityModel.timer = null;
    _timerInstantiatedStream.add(false);

    _api.activity
        .update(_activityModel, _user.id)
        .listen((ActivityModel activity) {});
  }

  void _resetCounterAndStopwatch() {
    // Stops any timers and cancels all listeners
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
