import 'package:api_client/api/api.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/weekday_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';

/// Bloc that streams the currently chosen weekplan
class WeekplanBloc extends BlocBase {
  /// Default Constructor.
  /// Initilizes values
  WeekplanBloc(this._api);

  final BehaviorSubject<WeekModel> _week = BehaviorSubject<WeekModel>();
  final BehaviorSubject<bool> _editMode = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<List<ActivityModel>> _markedActivities =
      BehaviorSubject<List<ActivityModel>>.seeded(<ActivityModel>[]);

  /// The stream that emits the currently chosen weekplan
  Stream<WeekModel> get week => _week.stream;

  /// The stream that emits whether in edit mode or citizen
  Stream<bool> get editMode => _editMode.stream;

  /// The stream that emits the marked activities
  Stream<List<ActivityModel>> get markedActivities => _markedActivities.stream;

  final Api _api;
  UsernameModel _user;

  /// Loads a user to the weekplan
  void load(UsernameModel user) {
    _user = user;
  }

  /// Sink to set the currently chosen week
  void setWeek(WeekModel week) {
    _week.add(week);
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
    final WeekModel localWeek = _week.value;
    int counter = 0;
    for (WeekdayModel weekday in localWeek.days) {
      weekday.activities.removeWhere(
          (ActivityModel item) => _markedActivities.value.contains(item));
    }

    _api.week
        .update(_user.id, localWeek.weekYear, localWeek.weekNumber, localWeek);
  }

  /// Toggles edit mode
  void toggleEditMode() {
    _editMode.add(!_editMode.value);
    print(_editMode.value);
  }

  @override
  void dispose() {
    _week.close();
  }
}
