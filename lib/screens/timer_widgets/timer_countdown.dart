import 'package:weekplanner/blocs/timer_bloc.dart';
import 'package:flutter/material.dart';
import '../../style/custom_color.dart' as theme;

/// Class for drawing a timer, Countdown timer
class TimerCountdown extends StatelessWidget {
  /// Constructor
  TimerCountdown(TimerBloc timerBloc) {
    _timerBloc = timerBloc;
  }

  /// Bloc for timer logic
  TimerBloc _timerBloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<int>>(
        stream: _timerBloc.timerProgressNumeric,
        builder: (BuildContext context,
            AsyncSnapshot<List<int>> timerProgressSnapshot) {
          return Container(
            decoration: const BoxDecoration(color: theme.GirafColors.white),
            child: Text(
              _formatTime(timerProgressSnapshot),
              style: TextStyle(
                color: theme.GirafColors.black,
                fontSize: 40,
              ),
            ),
          );
        });
  }

  /// Formats the complete snapshot properly to display as time left
  /// of the timer.
  String _formatTime(AsyncSnapshot<List<int>> time) {
    const int _paddingSize = 2;
    final String _hours = time.data[0].toString().padLeft(_paddingSize, '0');
    debugPrint("hours");
    final String _minutes = time.data[1].toString().padLeft(_paddingSize, '0');
    debugPrint("minutes");
    final String _seconds = time.data[2].toString().padLeft(_paddingSize, '0');
    debugPrint("seconds");
    return '$_hours:$_minutes:$_seconds';
  }

  /// Formats a specified part of the snapshot to have a 0 prefiexed if
  /// the number is only 1 character long. For arrPosition, 0 is hours,
  /// 1 is minutes and 2 is seconds.
  String _formatSnapshot(
      AsyncSnapshot<List<int>> time, int arrPosition, int paddingSize) {
    List<int> snapshotList = time.data;
    debugPrint(snapshotList.toString());
    return snapshotList[arrPosition].toString().padLeft(paddingSize, '0');
  }
}
