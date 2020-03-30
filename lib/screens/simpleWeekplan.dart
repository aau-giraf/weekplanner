import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/weekplan_bloc.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';
import 'package:weekplanner/models/user_week_model.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

import '../di.dart';

/// Simple as shit
class SimpleWeekplan extends StatelessWidget {
  /// HEj
  SimpleWeekplan(this._week, this._user, {Key key}) : super(key: key) {
    _weekplanBloc.loadWeek(_week, _user);
  }

  final WeekplanBloc _weekplanBloc = di.getDependency<WeekplanBloc>();
  final UsernameModel _user;
  final WeekModel _week;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GirafAppBar(
        title: _user.name + ' - ' + _week.name,
        appBarIcons: <AppBarIcon, VoidCallback>{
          AppBarIcon.changeToGuardian: () {}
        },
      ),
      body: StreamBuilder<UserWeekModel>(
          stream: _weekplanBloc.userWeek,
          builder:
              (BuildContext context, AsyncSnapshot<UserWeekModel> snapshot) {
            if (snapshot.hasData) {
              return _buildSimpleWeek(snapshot.data.week, context);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

Row _buildSimpleWeek(WeekModel weekModel, BuildContext context) {
  return null;
}
