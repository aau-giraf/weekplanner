import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/models/activity_model.dart';
import 'package:weekplanner/models/enums/weekday_enum.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/models/weekday_model.dart';
import 'package:weekplanner/providers/api/api.dart';

//Bloc that streams the currently choosen weekplan
class WeekplanBloc extends BlocBase {
  final Api _api;
  final BehaviorSubject<WeekModel> _week = BehaviorSubject<WeekModel>();

  WeekplanBloc(this._api);

  Stream<WeekModel> get week => _week.stream;

  void setWeek(WeekModel week) {
      _week.add(week);
  }

  @override
  void dispose() {
    _week.close();
  }
}
