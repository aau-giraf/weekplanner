import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/timer_bloc.dart';
import '../../style/custom_color.dart' as theme;

/// Class for drawing a timer piechart
class TimerPiechart extends StatelessWidget {
  /// Constructor
  TimerPiechart(TimerBloc timerBloc) {
    _timerBloc = timerBloc;
  }

  ///
  TimerBloc _timerBloc;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      key: const Key('TimerInitKey'),
      child: StreamBuilder<double>(
        stream: _timerBloc.timerProgressStream,
        builder: (BuildContext timerProgressContext,
            AsyncSnapshot<double> timerProgressSnapshot) {
          return Container(
            decoration: const ShapeDecoration(
                shape: CircleBorder(
                    side: BorderSide(
                        color: theme.GirafColors.black, width: 0.5))),
            child: CircleAvatar(
              backgroundColor: theme.GirafColors.red,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: CircularProgressIndicator(
                  strokeWidth: 30,
                  value: timerProgressSnapshot.hasData
                      ? timerProgressSnapshot.data
                      : 0.0,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      theme.GirafColors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
