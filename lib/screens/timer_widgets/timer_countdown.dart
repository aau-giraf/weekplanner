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
            child: timerProgressSnapshot.hasData
                ? Text(
                    _formatTime(timerProgressSnapshot.data),
                    style: TextStyle(
                      color: theme.GirafColors.black,
                      fontSize: 40,
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
          );
        });
  }

  /// Formats the complete snapshot properly to display as time left
  /// of the timer.
  String _formatTime(List<int> time) {
    const int _paddingSize = 2;
    final String _hours = time[0].toString().padLeft(_paddingSize, '0');
    final String _minutes = time[1].toString().padLeft(_paddingSize, '0');
    final String _seconds = time[2].toString().padLeft(_paddingSize, '0');
    return '$_hours:$_minutes:$_seconds';
  }
}
