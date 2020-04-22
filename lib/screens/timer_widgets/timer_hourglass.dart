import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';
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
              LayoutBuilder(
                  builder: (BuildContext context3, BoxConstraints constraints) {
                // Hvorfor bruger Columns children ikke af constraints?
                // Constraints.biggest virker ikke til at ændre sig baseret på dem
                return Column(
                  children: <Widget>[
                    Container(
                        height: constraints.maxHeight / 2,
                        width: 100,
                        color: Colors.red),
                    Container(
                        height: constraints.biggest.height / 2,
                        width: 100,
                        color: Colors.green)
                  ],
                );
              }),
              Image(
                image: const AssetImage('assets/hourglass.png'),
              ),
            ],
          );
        });
  }
}
