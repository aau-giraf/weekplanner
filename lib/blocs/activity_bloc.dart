import 'package:rxdart/rxdart.dart';
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

  Stream<WeekModel> get weekModelStream => _weekModelStream.stream;

  // Start with providing false as the logged in status
  final BehaviorSubject<WeekModel> _weekModelStream = BehaviorSubject<WeekModel>();

  /// Loads the WeekModel, ActivityModel and the GirafUser.
  void load(
      WeekModel weekModel, ActivityModel activityModel, UsernameModel user) {
    _activityModel = activityModel;
    _weekModel = weekModel;
    _user = user;
  }

  /// Mark the selected activity as complete.
  void completeActivity() {
    final ActivityState tempState = _activityModel.state;
    _activityModel.state = ActivityState.Completed;
    if (!update()) {
      _activityModel.state = tempState;
    }
  }

  /// Mark the selected activity as cancelled.
  void cancelActivity() {
    final ActivityState tempState = _activityModel.state;
    _activityModel.state = ActivityState.Canceled;
    if (!update()) {
      _activityModel.state = tempState;
    }
  }

  /// Update the weekmodel with the new state.
  bool update() {
    _api.week.update(
      _user.id, _weekModel.weekYear, _weekModel.weekNumber, _weekModel)
        .listen(_weekModelStream.add);
    // TODO: Do something with this.
    return true;
  }

  @override
  void dispose() {}
}
