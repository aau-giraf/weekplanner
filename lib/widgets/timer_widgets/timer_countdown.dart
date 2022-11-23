import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/timer_bloc.dart';

import '../../style/custom_color.dart' as theme;

/// Class for drawing a timer, Countdown timer
class TimerCountdown extends StatelessWidget {
  /// Constructor
  const TimerCountdown(this._timerBloc);

  /// Bloc for timer logic
  final TimerBloc _timerBloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<int>>(
        stream: _timerBloc.timerProgressNumeric,
        builder: (BuildContext context,
            AsyncSnapshot<List<int>> timerProgressSnapshot) {
          return Container(
            decoration: const BoxDecoration(color: theme.GirafColors.white),
            child: timerProgressSnapshot.hasData
                ? FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(_formatTime(timerProgressSnapshot.data)))
                : const Center(child: CircularProgressIndicator()),
          );
        });
  }

  /// Formats the complete snapshot properly to display as time left
  /// of the timer.
  String _formatTime(List<int> time) {
    const int _padding = 2;
    final String _hours = time[0].round().toString().padLeft(_padding, '0');
    final String _minutes = time[1].round().toString().padLeft(_padding, '0');
    final String _seconds = time[2].round().toString().padLeft(_padding, '0');
    return '$_hours:$_minutes:$_seconds';
  }
}
