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
          if (timerProgressSnapshot.hasData) {
            // The stream timerProgressSnapshot seems to over shoot,
            // so to counter this, we check above or equal to 1
            if (timerProgressSnapshot.data >= 1) {
              return _drawDoneHourglass();
            } else {
              return _drawHourglass(timerProgressSnapshot);
            }
          }
          return const CircularProgressIndicator();
        });
  }
}

LayoutBuilder _drawHourglass(AsyncSnapshot<double> timerProgressSnapshot) {
  return LayoutBuilder(
      builder: (BuildContext context3, BoxConstraints constraints) {
    return Stack(
      children: <Widget>[
        Image(
            image: const AssetImage('assets/hourglass_sand.png'),
            width: constraints.maxWidth),
        Column(
          children: <Widget>[
            // Hourglass is implemented using 3 containers expanding
            // based values from the other containers and time stream
            // To examine, change colors from white.
            Container(
              // The top container should keep the middle
              // container at the middle of the hourglass.
              // It does this by subtracting the height of the middle
              // container from the total height of the hourglass.
              height: timerProgressSnapshot.data >= 1
                  ? 0
                  : (constraints.maxHeight / 2) -
                      (constraints.maxHeight /
                          2 *
                          (1 - timerProgressSnapshot.data)),
              width: constraints.maxWidth,
              color: Colors.white,
            ),
            Container(
              // Middle container height, is calculated by taking
              // the maximum space it has to fill and then
              // multiplying by a factor, describing how large
              // the percentage of time remaining is.
              height: timerProgressSnapshot.data >= 1
                  ? 0
                  : (constraints.maxHeight /
                      2 *
                      (1 - timerProgressSnapshot.data)),
              width: constraints.maxWidth,
              color: Colors.transparent,
            ),
            Container(
                // The bottom container should fill as much as the
                // middle container does not fill, to simulate
                // some of sand falling down. The top container
                // describes how much sand the middle container has
                // "dropped" down to the bottom. The height
                // is then calculated by subtracting the size of the
                // top container from the other half of the
                // hourglass.ø
                height: timerProgressSnapshot.data >= 1
                    ? 0
                    : (constraints.maxHeight / 2 -
                        ((constraints.maxHeight / 2) -
                            (constraints.maxHeight /
                                2 *
                                (1 - timerProgressSnapshot.data)))),
                width: constraints.maxWidth,
                color: Colors.white),
          ],
        ),
        Image(
          image: const AssetImage('assets/hourglass.png'),
          width: constraints.maxWidth,
        ),
      ],
    );
  });
}

Image _drawDoneHourglass() {
  return Image(image: const AssetImage('assets/hourglass_done.png'));
}
