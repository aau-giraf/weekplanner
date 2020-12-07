import 'dart:async';
import 'dart:io';
import 'package:api_client/api/api.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/timer_model.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:quiver/async.dart';
import 'package:rxdart/rxdart.dart' as rx_dart;
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:weekplanner/models/enums/timer_running_mode.dart';

import 'blocs_api_exceptions.dart';

/// Logic for activities
class TimerBloc extends BlocBase {
  /// Constructor taking the API
  TimerBloc(this._api);

  final Api _api;

  ActivityModel _activityModel;
  DisplayNameModel _user;

  /// Stream for the progress of the timer.
  Stream<double> get timerProgressStream => _timerProgressStream.stream;

  /// stream for checking if the timer is running
  Stream<TimerRunningMode> get timerRunningMode =>
      _timerRunningModeStream.stream;

  /// Stream for checking if the timer is instantiated.
  Stream<bool> get timerIsInstantiated => _timerInstantiatedStream.stream;

  /// rx_dart.BehaviorSubject for the progress of the timer.
  final rx_dart.BehaviorSubject<double> _timerProgressStream =
      rx_dart.BehaviorSubject<double>.seeded(0.0);

  /// rx_dart.BehaviorSubject for to check if timer is running.
  final rx_dart.BehaviorSubject<TimerRunningMode> _timerRunningModeStream =
      rx_dart.BehaviorSubject<TimerRunningMode>.seeded(
          TimerRunningMode.not_initialized);

  /// rx_dart.BehaviorSubject for to check if timer is instantiated.
  final rx_dart.BehaviorSubject<bool> _timerInstantiatedStream =
      rx_dart.BehaviorSubject<bool>.seeded(false);

  /// Behavior subject for the progress of the timer in
  ///  hours, minutes and seconds.
  final rx_dart.BehaviorSubject<List<int>> _timerProgressNumeric =
      rx_dart.BehaviorSubject<List<int>>.seeded(<int>[0, 0, 0]);

  /// Stream for the progress of the timer in minutes and seconds.
  /// The array streamed contains hours at index 0,
  /// minutes at index 1 and seconds at index 2.
  Stream<List<int>> get timerProgressNumeric => _timerProgressNumeric.stream;

  CountdownTimer _countDown;
  StreamSubscription<CountdownTimer> _timerStream;
  Stopwatch _stopwatch;

  // Audio player used for ding sound.
  static final AudioPlayer _volumePlayer = AudioPlayer();

  final AudioCache _audioPlayer =
      AudioCache(prefix: 'audio/', fixedPlayer: _volumePlayer);

  final String _audioFile = 'dingSound.wav';
  final int _updatePeriod = 1000;

  /// Loads the activity that should be used in the timerBloc
  void load(ActivityModel activity, {DisplayNameModel user}) {
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
    _timerProgressNumeric.add(_durationToTimestamp(duration));
    try{
      _api.activity
          .update(_activityModel, _user.id)
          .listen((ActivityModel activity) {});
    }on SocketException{throw BlocsApiException('Sock');}
    on HttpException{throw BlocsApiException('Http');}
    on TimeoutException{throw BlocsApiException('Time');}
    on FormatException{throw BlocsApiException('Form');}
    on Error catch(error)
    {throw BlocsApiException('spec', '', error);}

  }

  List<int> _durationToTimestamp(Duration duration) {
    final List<int> timestamp = List<int>(3);
    timestamp[0] = duration.inHours;
    timestamp[1] = duration.inMinutes.remainder(60);
    timestamp[2] = duration.inSeconds.remainder(60);
    timestamp[2] += _checkAndAddRemainingSecond(duration);
    return timestamp;
  }

  int _checkAndAddRemainingSecond(Duration duration) {
    int _remainingSecond = 0;

    if (duration.inMilliseconds.remainder(1000) >= 500) {
      _remainingSecond = 1;
    }

    return _remainingSecond;
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
        if ((_activityModel.timer.startTime.isBefore(DateTime.now()) ||
                _activityModel.timer.startTime
                    .isAtSameMomentAs(DateTime.now())) &&
            DateTime.now().isBefore(endTime) &&
            !_activityModel.timer.paused) {
          _timerRunningModeStream.add(TimerRunningMode.running);

          _stopwatch = Stopwatch();
          _countDown = CountdownTimer(endTime.difference(DateTime.now()),
              Duration(milliseconds: _updatePeriod),
              stopwatch: _stopwatch);

          _timerStream =
              _countDown.listen((CountdownTimer c) => updateTimerProgress(c));

          // Do an initial update
          updateTimerProgress(_countDown);
        } else if (_activityModel.timer.paused) {
          _timerRunningModeStream.add(TimerRunningMode.initialized);
          _timerProgressStream.add(1 -
              (1 /
                  _activityModel.timer.fullLength *
                  (_activityModel.timer.fullLength -
                      _activityModel.timer.progress)));

          _timerProgressNumeric.add(_durationToTimestamp(Duration(
              milliseconds: _activityModel.timer.fullLength -
                  _activityModel.timer.progress)));

          if (_activityModel.timer.progress >=
              _activityModel.timer.fullLength) {
            _timerRunningModeStream.add(TimerRunningMode.completed);
          }
        } else {
          _timerProgressStream.add(1);
          if (_countDown != null) {
            _timerProgressNumeric
                .add(_durationToTimestamp(_countDown.remaining));
          }
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
    // Makes sure that a timer exists
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
      // This is needed to send the start time when the timer is restarted
      _timerProgressNumeric.add(_durationToTimestamp(_countDown.remaining));

      _timerStream = _countDown.listen((CountdownTimer c) {
        updateTimerProgress(c);
        if (_stopwatch.isRunning && DateTime.now().isAfter(_endTime)) {
          playSound();
          _timerRunningModeStream.add(TimerRunningMode.completed);
        }
      });
      _timerRunningModeStream.add(TimerRunningMode.running);

      try{
        _api.activity
            .update(_activityModel, _user.id)
            .listen((ActivityModel activity) {});
      }on SocketException{throw BlocsApiException('Sock');}
      on HttpException{throw BlocsApiException('Http');}
      on TimeoutException{throw BlocsApiException('Time');}
      on FormatException{throw BlocsApiException('Form');}
      on Error catch(error)
      {throw BlocsApiException('spec', '', error);}
    }
  }

  /// Calculate progress and write it to the _timerProgressStream
  void updateTimerProgress(CountdownTimer c) {
    _timerProgressStream.add((1 -
                (1 /
                    _activityModel.timer.fullLength *
                    c.remaining.inMilliseconds)) >
            1
        ? 1
        : (1 -
            (1 /
                _activityModel.timer.fullLength *
                c.remaining.inMilliseconds)));
    _timerProgressNumeric.add(_durationToTimestamp(c.remaining));
  }

  /// Plays ding sound from mp3 file.
  Future<void> playSound() async {
    _audioPlayer.load(_audioFile);
    _volumePlayer.setVolume(500);
    _audioPlayer.play(_audioFile);
  }

  /// Pauses the timer and updates the timer in the database accordingly.
  void pauseTimer() {
    // First make sure that a timer exists and it is running
    if (_activityModel.timer != null &&
        _timerStream != null &&
        !_activityModel.timer.paused) {
      _activityModel.timer.paused = true;
      _activityModel.timer.progress =
          _activityModel.timer.fullLength - _countDown.remaining.inMilliseconds;
      _resetCounterAndStopwatch();
      _timerRunningModeStream.add(TimerRunningMode.paused);

      _api.activity
          .update(_activityModel, _user.id)
          .listen((ActivityModel activity) {});
    }
  }

  /// Stops the timer and resets it and updates is database.
  void stopTimer() {
    // Makes sure that a timer exists
    if (_activityModel.timer != null) {
      _resetCounterAndStopwatch();
      _activityModel.timer.paused = true;
      _activityModel.timer.progress = 0;
      _timerRunningModeStream.add(TimerRunningMode.stopped);
      _timerProgressStream.add(0);
      _timerProgressNumeric.add(_durationToTimestamp(
          Duration(milliseconds: _activityModel.timer.fullLength)));

      _api.activity
          .update(_activityModel, _user.id)
          .listen((ActivityModel activity) {});
    }
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
    _timerProgressNumeric.close();
    _timerRunningModeStream.close();
  }
}
