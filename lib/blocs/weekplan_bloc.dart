import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/models/activity_model.dart';
import 'package:weekplanner/models/enums/weekday_enum.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/models/weekday_model.dart';
import 'package:weekplanner/providers/api/api.dart';

class WeekplanBloc extends BlocBase {
  final Api _api;
  final BehaviorSubject<WeekModel> _week = BehaviorSubject<WeekModel>();

  WeekplanBloc(this._api);

  Stream<WeekModel> get week => _week.stream;

  void setWeek(WeekModel week) {
    if (week == null) {
      _week.add(WeekModel(days: [
        WeekdayModel(day: Weekday.Monday, activities: List<ActivityModel>()),
        WeekdayModel(day: Weekday.Tuesday, activities: List<ActivityModel>()),
        WeekdayModel(day: Weekday.Wednesday, activities: List<ActivityModel>()),
        WeekdayModel(day: Weekday.Thursday, activities: List<ActivityModel>()),
        WeekdayModel(day: Weekday.Friday, activities: List<ActivityModel>()),
        WeekdayModel(day: Weekday.Saturday, activities: List<ActivityModel>()),
        WeekdayModel(day: Weekday.Sunday, activities: List<ActivityModel>()),
      ]));
    } else {
        _week.add(week);
    }
  }

  @override
  void dispose() {
    _week.close();
  }
}
