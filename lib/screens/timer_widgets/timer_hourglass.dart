import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/timer_bloc.dart';
import '../../style/custom_color.dart' as theme;

class TimerHourglass extends StatelessWidget {
  TimerHourglass(TimerBloc timerBloc) {
    _timerBloc = timerBloc;
  }

  TimerBloc _timerBloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
        stream: _timerBloc.timerProgressStream,
        builder: (BuildContext timerProgressContext,
            AsyncSnapshot<double> timerProgressSnapshot) {
          return Stack(
            children: <Widget>[
              Image(
                image: const AssetImage('assets/hourglass_sand.png'),
              ),
              Column(
                children: <Widget>[
                  Container(
                    color: Colors.red,
                  ),
                  Container(
                    color: Colors.blue,
                  )
                ],
              ),
              Image(
                image: const AssetImage('assets/hourglass.png'),
              ),
            ],
          );
        });
  }
}
