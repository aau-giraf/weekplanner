import 'package:api_client/api/api.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/weekday_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:weekplanner/models/user_week_model.dart';

/// Bloc that streams the currently chosen weekplan
class WeekplanBloc extends BlocBase {
  /// Default Constructor.
  /// Initilizes values
  WeekplanBloc(this._api);

  final BehaviorSubject<bool> _editMode = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<List<ActivityModel>> _markedActivities =
      BehaviorSubject<List<ActivityModel>>.seeded(<ActivityModel>[]);
  final BehaviorSubject<UserWeekModel> _userWeek =
      BehaviorSubject<UserWeekModel>();

  /// The API
  final Api _api;

  /// The stream that emits the currently chosen weekplan
  Stream<UserWeekModel> get userWeek => _userWeek.stream;

  /// The stream that emits whether in edit mode or citizen
  Stream<bool> get editMode => _editMode.stream;

  /// The stream that emits the marked activities
  Stream<List<ActivityModel>> get markedActivities => _markedActivities.stream;

  /// Sink to set the currently chosen week
  void setWeek(WeekModel week, UsernameModel user) {
    _userWeek.add(UserWeekModel(week, user));
  }

  /// Adds a new marked activity
  void addMarkedActivity(ActivityModel activityModel) {
    final List<ActivityModel> localMarkedActivities = _markedActivities.value;

    localMarkedActivities.add(activityModel);
    _markedActivities.add(localMarkedActivities);
  }

  /// Removes a marked activity
  void removeMarkedActivity(ActivityModel activityModel) {
    final List<ActivityModel> localMarkedActivities = _markedActivities.value;

    localMarkedActivities.remove(activityModel);
    _markedActivities.add(localMarkedActivities);
  }

  /// Clears marked activities
  void clearMarkedActivities() {
    _markedActivities.add(<ActivityModel>[]);
  }

  /// Is activity marked
  bool isActivityMarked(ActivityModel activityModel) {
    return _markedActivities.value?.contains(activityModel) ?? false;
  }

  /// Delete the marked activities when the trash button is clicked
  void deleteMarkedActivities() {
    final WeekModel week = _userWeek.value.week;
    final UsernameModel user = _userWeek.value.user;

    for (WeekdayModel weekday in week.days) {
      weekday.activities.removeWhere(
          (ActivityModel item) => _markedActivities.value.contains(item));
    }

    clearMarkedActivities();
    _api.week.update(user.id, week.weekYear,
        week.weekNumber, week).listen((WeekModel onData) => null);
  }

  /// Toggles edit mode
  void toggleEditMode() {
    _editMode.add(!_editMode.value);
  }

  /// Adds an activity to the given day.
  void addActivity(ActivityModel activity, int day) {
    final WeekModel week = _userWeek.value.week;
    final UsernameModel user = _userWeek.value.user;

    week.days[day].activities.add(activity);
    _api.week
        .update(user.id, week.weekYear, week.weekNumber, week)
        .listen((WeekModel newWeek) {
      _userWeek.add(UserWeekModel(newWeek, user));
    });
  }

  /// Returns the number of marked activities
  int getNumberOfMarkedActivities() {
    return _markedActivities.value.length;
  }

  @override
  void dispose() {
    _userWeek.close();
  }
}
