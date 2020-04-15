import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/activity_bloc.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/blocs/timer_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/enums/activity_state_enum.dart';
import 'package:api_client/models/username_model.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';
import 'package:weekplanner/models/enums/timer_running_mode.dart';
import 'package:weekplanner/models/enums/weekplan_mode.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/giraf_activity_time_picker_dialog.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/giraf_confirm_dialog.dart';
import '../../style/custom_color.dart' as theme;

/// Class for drawing
class TimerPiechart extends StatelessWidget {
  ///Constructor
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
