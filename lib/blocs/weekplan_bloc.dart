import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/models/activity_model.dart';
import 'package:weekplanner/models/giraf_user_model.dart';
import 'package:weekplanner/models/user_week_model.dart';
import 'package:weekplanner/models/username_model.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/providers/api/api.dart';

/// Bloc that streams the currently chosen weekplan
class WeekplanBloc extends BlocBase {
  /// Includes the api with the Bloc.
  WeekplanBloc(this._api);

  /// The API
  final Api _api;

  final BehaviorSubject<UserWeekModel> _userWeek =
      BehaviorSubject<UserWeekModel>();

  /// The stream that emits the currently chosen weekplan
  Stream<UserWeekModel> get userWeek => _userWeek.stream;

  /// Sink to set the currently chosen week
  void setWeek(WeekModel week, UsernameModel user) {
    _userWeek.add(UserWeekModel(week, user));
  }

  void addActivity(ActivityModel activity, int day) {
    WeekModel week = _userWeek.value.week;
    UsernameModel user = _userWeek.value.user;

    week.days[day].activities.add(activity);
    _api.week
        .update(user.id, week.weekYear, week.weekNumber, week)
        .listen((WeekModel newWeek) {
      _userWeek.add(UserWeekModel(newWeek, user));
    });

    /*    .me()
        .take(1)
        .switchMap((GirafUserModel user) {
          return _api.week
              .update(user.id, week.weekYear, week.weekNumber, week);
        })
        .listen((WeekModel newWeek) {
          _week.add(newWeek);
        });*/
  }

  @override
  void dispose() {
    _userWeek.close();
  }
}
