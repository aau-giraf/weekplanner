import 'package:api_client/api/api.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/enums/activity_state_enum.dart';
import 'package:api_client/models/enums/weekday_enum.dart';
import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/weekday_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:weekplanner/models/user_week_model.dart';

/// Bloc that streams the currently chosen weekplan
class WeekplanBloc extends BlocBase {
  /// Constructor that initializes _api
  WeekplanBloc(this._api);

  /// The stream that emits the currently chosen weekplan
  Observable<UserWeekModel> get userWeek => _userWeek.stream;

  /// The stream that emits whether in editMode or not
  Stream<bool> get editMode => _editMode.stream;

  /// The stream that emits the marked activities
  Stream<List<ActivityModel>> get markedActivities => _markedActivities.stream;

  /// The current visibility of the activityPlaceholder-container.
  Stream<bool> get activityPlaceholderVisible =>
      _activityPlaceholderVisible.stream;

  /// Checks if there are no selected activities
  Stream<bool> get atLeastOneActivityMarked =>
      _atLeastOneActivityMarked();

  /// The API
  final Api _api;
  final BehaviorSubject<bool> _editMode = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<List<ActivityModel>> _markedActivities =
      BehaviorSubject<List<ActivityModel>>.seeded(<ActivityModel>[]);
  final BehaviorSubject<UserWeekModel> _userWeek =
      BehaviorSubject<UserWeekModel>();
  final BehaviorSubject<bool> _activityPlaceholderVisible =
      BehaviorSubject<bool>.seeded(false);

  /// Sink to set the currently chosen week
  void loadWeek(WeekModel week, UsernameModel user) {
    _api.week
        .get(user.id, week.weekYear, week.weekNumber)
        .listen((WeekModel loadedWeek) {
      _userWeek.add(UserWeekModel(loadedWeek, user));
    });
  }

  /// Adds a new marked activity to the stream
  void addMarkedActivity(ActivityModel activityModel) {
    final List<ActivityModel> localMarkedActivities = _markedActivities.value;

    localMarkedActivities.add(activityModel);
    _markedActivities.add(localMarkedActivities);
  }

  /// Removes a marked activity from the stream
  void removeMarkedActivity(ActivityModel activityModel) {
    final List<ActivityModel> localMarkedActivities = _markedActivities.value;

    localMarkedActivities.remove(activityModel);
    _markedActivities.add(localMarkedActivities);
  }

  /// Clears marked activities
  void clearMarkedActivities() {
    _markedActivities.add(<ActivityModel>[]);
  }

  /// Checks if an activity is marked
  bool isActivityMarked(ActivityModel activityModel) {
    if (_markedActivities.value == null) {
      return false;
    }
    return _markedActivities.value.contains(activityModel);
  }

  /// set the marked activities as canceled
  void cancelMarkedActivities() {
    final WeekModel week = _userWeek.value.week;
    final UsernameModel user = _userWeek.value.user;

    for (ActivityModel activity in _markedActivities.value) {
      activity.state = ActivityState.Canceled;
    }

    _api.week
        .update(user.id, week.weekYear, week.weekNumber, week)
        .listen((WeekModel newWeek) {
      _userWeek.add(UserWeekModel(newWeek, user));
    });

    clearMarkedActivities();
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
    // Updates the weekplan in the database
    _api.week
        .update(user.id, week.weekYear, week.weekNumber, week)
        .listen((WeekModel newWeek) {
      _userWeek.add(UserWeekModel(newWeek, user));
    });
  }

  /// Copies the marked activities to the given days
  void copyMarkedActivities(List<bool> days) {
    final WeekModel week = _userWeek.value.week;
    final UsernameModel user = _userWeek.value.user;

    for (int dayOfWeek = 0; dayOfWeek < days.length; dayOfWeek++) {
      if (days[dayOfWeek]) {
        for (ActivityModel activity in _markedActivities.value) {
          // Make a copy of the given activity with the state reset
          // and make sure it is added at as the last activity of the day.
          final ActivityModel newActivity = ActivityModel(
              id: activity.id,
              pictogram: activity.pictogram,
              order: _getMaxOrder(week.days[dayOfWeek].activities),
              isChoiceBoard: false,
              state: ActivityState.Normal);

          // Add the copy to the specified day
          week.days[dayOfWeek].activities.add(newActivity);
        }
      }
    }

    clearMarkedActivities();

    _api.week
        .update(user.id, week.weekYear, week.weekNumber, week)
        .listen((WeekModel newWeek) {
      _userWeek.add(UserWeekModel(newWeek, user));
    });
  }

  int _getMaxOrder(List<ActivityModel> activities) {
    int max = 0;

    for (ActivityModel activity in activities) {
      if (activity.order > max) {
        max = activity.order;
      }
    }
    return max;
  }

  /// Toggles edit mode
  void toggleEditMode() {
    if (_editMode.value) {
      clearMarkedActivities();
    }
    _editMode.add(!_editMode.value);
  }

  /// Manually set edit mode
  void setEditMode(bool value) {
    if (_editMode.value) {
      clearMarkedActivities();
    }
    _editMode.add(value);
  }

  /// Used to change the visibility of the activityPlaceholder container.
  void setActivityPlaceholderVisible(bool visibility) {
    _activityPlaceholderVisible.add(visibility);
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

  /// Reorders activities between same or different days.
  void reorderActivities(
      ActivityModel activity, Weekday dayFrom, Weekday dayTo, int newOrder) {
    final WeekModel week = _userWeek.value.week;
    final UsernameModel user = _userWeek.value.user;

    // Removed from dayFrom, the day the pictogram is dragged from
    int dayLength = week.days[dayFrom.index].activities.length;

    for (int i = activity.order + 1; i < dayLength; i++) {
      week.days[dayFrom.index].activities[i].order -= 1;
    }

    week.days[dayFrom.index].activities.remove(activity);

    activity.order = dayFrom == dayTo &&
            week.days[dayTo.index].activities.length == newOrder - 1
        ? newOrder - 1
        : newOrder;

    // Inserts into dayTo, the day that the pictogram is inserted to
    dayLength = week.days[dayTo.index].activities.length;

    for (int i = activity.order; i < dayLength; i++) {
      week.days[dayTo.index].activities[i].order += 1;
    }

    week.days[dayTo.index].activities.insert(activity.order, activity);

    _api.week
        .update(user.id, week.weekYear, week.weekNumber, week)
        .listen((WeekModel newWeek) {
      _userWeek.add(UserWeekModel(week, user));
    });
  }

  Observable<bool> _atLeastOneActivityMarked(){
    return _markedActivities.map((List<ActivityModel> activities) =>
    activities.isNotEmpty);
  }

  @override
  void dispose() {
    _userWeek.close();
    _activityPlaceholderVisible.close();
  }
}
