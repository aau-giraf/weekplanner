import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:weekplanner/models/activity_model.dart';
import 'package:weekplanner/models/giraf_user_model.dart';
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
  GirafUserModel _user;

  WeekModel weekModelTEST;
  ActivityModel accModelTEST;
  String userIDTest = '379d057b-85b1-41b6-a1bd-6448c132745b';

  Stream<WeekModel> get weekModelStream => _weekModelB.stream;

  // Start with providing false as the logged in status
  final BehaviorSubject<WeekModel> _weekModelB = BehaviorSubject<WeekModel>();

  /// Loads the WeekModel, ActivityModel and the GirafUser.
  void load(
      WeekModel weekModel, ActivityModel activityModel, GirafUserModel user) {
    _activityModel = activityModel;
    _weekModel = weekModel;
    _user = user;

    _api.week.get('379d057b-85b1-41b6-a1bd-6448c132745b', 2018, 21)
    .listen((onData) {
      weekModelTEST = onData;
      accModelTEST = weekModelTEST.days[1].activities[0];
    });
    
  }

  /// Mark the selected activity as complete.
  void completeActivity() {
    final ActivityState tempState = accModelTEST.state;
    accModelTEST.state = ActivityState.Completed;
    if (!update()) {
      accModelTEST.state = tempState;
    }
  }

  /// Mark the selected activity as cancelled.
  void cancelActivity() {
    final ActivityState tempState = accModelTEST.state;
    accModelTEST.state = ActivityState.Canceled;
    if (!update()) {
      accModelTEST.state = tempState;
    }
  }

  /// Update the weekmodel with the new state.
  bool update() {
    _api.week.update(
      userIDTest, weekModelTEST.weekYear, weekModelTEST.weekNumber, weekModelTEST)
        .listen(_weekModelB.add);
    return true;
  }

  @override
  void dispose() {}
}
