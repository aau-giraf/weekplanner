import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:weekplanner/models/activity_model.dart';
import 'package:weekplanner/models/username_model.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/providers/api/api.dart';
import 'package:weekplanner/models/enums/activity_state_enum.dart';

/// Logic for activities
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

  /// Mark the selected activity as complete. Toggle function, if activity is
  /// Completed, it will become Normal
  void completeActivity() {
    _activityModel.state = _activityModel.state == ActivityState.Completed
        ? ActivityState.Normal
        : ActivityState.Completed;
    update();
  }

  /// Mark the selected activity as cancelled.Toggle function, if activity is
  /// Canceled, it will become Normal
  void cancelActivity() {
    _activityModel.state = _activityModel.state == ActivityState.Canceled
        ? ActivityState.Normal
        : ActivityState.Canceled;
    update();
  }

  /// Update the weekmodel with the new state.
  void update() {
    _api.week
        .update(
            _user.id, _weekModel.weekYear, _weekModel.weekNumber, _weekModel)
        .listen((WeekModel weekModel) {
      _weekModel.days = weekModel.days;
    });
  }

  @override
  void dispose() {}
}
