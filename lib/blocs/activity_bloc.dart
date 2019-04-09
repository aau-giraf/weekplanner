import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:weekplanner/models/activity_model.dart';
import 'package:weekplanner/models/username_model.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/providers/api/api.dart';
import 'package:weekplanner/models/enums/activity_state_enum.dart';

/// Document all public members.
class ActivityBloc extends BlocBase {
  /// Default Constructor.
  ActivityBloc(this._api);

  final Api _api;
  ActivityModel _activityModel;
  WeekModel _weekModel;
  UsernameModel _user;

  /// Loads the WeekModel, ActivityModel and the GirafUser.
  void load(
      WeekModel weekModel, ActivityModel activityModel, UsernameModel user) {
    _activityModel = activityModel;
    _weekModel = weekModel;
    _user = user;
  }

  /// Mark the selected activity as complete.
  void completeActivity() {
    _activityModel.state = ActivityState.Completed;
    update();
  }

  /// Mark the selected activity as cancelled.
  void cancelActivity() {
    _activityModel.state = ActivityState.Canceled;
    update();
  }

  /// Update the weekmodel with the new state.
  void update() {
    _api.week.update(
      _user.id, _weekModel.weekYear, _weekModel.weekNumber, _weekModel)
        .listen((WeekModel weekModel) {
          _weekModel.days = weekModel.days;
        });
  }

  @override
  void dispose() {}
}
