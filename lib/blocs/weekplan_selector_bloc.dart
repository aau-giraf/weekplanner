import 'dart:async';

import 'package:api_client/api/api.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/week_name_model.dart';
import 'package:rxdart/rxdart.dart' as rx_dart;
import 'package:weekplanner/blocs/bloc_base.dart';

/// WeekplansBloc to get weekplans for a user
class WeekplansBloc extends BlocBase {
  /// This bloc obtains a list of all [WeekModel]'s
  /// for a given [UsernameModel].
  WeekplansBloc(this._api);

  /// This is a stream where all the [WeekNameModel] are put in,
  ///to be used when getting the [WeekModel].
  Stream<List<WeekNameModel>> get weekNameModels => _weekNameModelsList.stream;

  /// This is a stream where all the future [WeekModel] are put in,
  /// and this is the stream to listen to,
  /// when wanting information about weekplans.
  Stream<List<WeekModel>> get weekModels => _weekModel.stream;

  /// The stream that emits whether in editMode or not
  Stream<bool> get editMode => _editMode.stream;

  /// The stream that emits the marked activities
  Stream<List<WeekModel>> get markedWeekModels => _markedWeekModels.stream;

  final rx_dart.BehaviorSubject<List<WeekModel>> _weekModel =
      rx_dart.BehaviorSubject<List<WeekModel>>();

  final rx_dart.BehaviorSubject<List<WeekModel>> _oldWeekModel =
  rx_dart.BehaviorSubject<List<WeekModel>>();

  /// This is a stream where all the old [WeekModel] are put in,
  /// and this is the stream to listen to,
  /// when wanting information about weekplans.
  Stream<List<WeekModel>> get oldWeekModels => _oldWeekModel.stream;

  final rx_dart.BehaviorSubject<List<WeekNameModel>> _weekNameModelsList =
      rx_dart.BehaviorSubject<List<WeekNameModel>>();

  final rx_dart.BehaviorSubject<bool> _editMode
  = rx_dart.BehaviorSubject<bool>.seeded(false);

  final rx_dart.BehaviorSubject<List<WeekModel>> _markedWeekModels =
      rx_dart.BehaviorSubject<List<WeekModel>>.seeded(<WeekModel>[]);

  final Api _api;
  DisplayNameModel _user;

  /// To control adding an extra result for creating a new [WeekModel]
  /// for the weekplan_selector_screen.
  bool _addWeekplan;

  /// Loads all the [WeekNameModel] for a given [user].
  /// [addWeekplan] parameter controls if there should be a result
  ///  for adding a new [WeekModel].

  /// The result are published in [_weekNameModelsList].
  void load(DisplayNameModel user, [bool addWeekplan = false]) {
    _user = user;
    _addWeekplan = addWeekplan;
    weekNameModels.listen(getAllWeekInfo);
    _api.week.getNames(_user.id).listen(_weekNameModelsList.add);
  }

  /// Gets all the information for a [Weekmodel].
  /// [weekPlanNames] parameter contains all the information
  /// needed for getting all [WeekModel]'s.
  /// The upcoming weekplans are published in [_weekModel].
  /// Old weekplans are published in [_oldWeekModel].
  void getAllWeekInfo(List<WeekNameModel> weekPlanNames) {
    final List<WeekModel> weekPlans = <WeekModel>[];

    // This is used by weekplan_selector_screen for adding a new weekplan.
    if (_addWeekplan) {
      weekPlans.add(WeekModel(name: 'Tilføj ugeplan'));
    }

    if (weekPlanNames.isEmpty) {
      _weekModel.add(weekPlans);
      return;
    }

    final List<Stream<WeekModel>> weekDetails = <Stream<WeekModel>>[];
    final List<Stream<WeekModel>> oldWeekDetails =
      <Stream<WeekModel>>[];

    getWeekDetails(weekPlanNames, weekDetails, oldWeekDetails);

    final Stream<List<WeekModel>> getWeekPlans =
      reformatWeekDetailsToObservableList(weekDetails);

    final Stream<List<WeekModel>> getOldWeekPlans =
      reformatWeekDetailsToObservableList(oldWeekDetails);

    getWeekPlans
      .take(1)
      .map((List<WeekModel> plans) => weekPlans + plans)
      .map(_sortWeekPlans)
      .listen(_weekModel.add);

    getOldWeekPlans
      .take(1)
      .map((List<WeekModel> plans) => plans)
      .map(_sortOldWeekPlans)
      .listen(_oldWeekModel.add);
  }

  /// Reformats [weekDetails] and [oldWeekDetails] into an Observable List
  Stream<List<WeekModel>> reformatWeekDetailsToObservableList
      (List<Stream<WeekModel>> details){
      // ignore: always_specify_types
      return details.isEmpty ? const Stream.empty() :
        details.length == 1 ?
        details[0].map((WeekModel plan) => <WeekModel>[plan]) :
        rx_dart.Rx.combineLatestList(details);
  }

  /// Makes API calls to get the weekplan details
  /// Old weekplans are stored in [oldWeekDetails]
  /// and current/upcoming weekplans are stored in [weekDetails]
  void getWeekDetails(
    List<WeekNameModel> weekPlanNames,
    List<Stream<WeekModel>> weekDetails,
    List<Stream<WeekModel>> oldWeekDetails){

    // Loops through all weekplans and sort them into old and upcoming weekplans
    for (WeekNameModel weekPlanName in weekPlanNames) {
      if(isWeekDone(weekPlanName)) {
        oldWeekDetails.add(_api.week
            .get(_user.id, weekPlanName.weekYear, weekPlanName.weekNumber)
            .take(1));
      } else {
        weekDetails.add(_api.week
            .get(_user.id, weekPlanName.weekYear, weekPlanName.weekNumber)
            .take(1));
      }
    }
  }

  /// Returns the current week number
  int getCurrentWeekNum() {
    return getWeekNumberFromDate(DateTime.now());
  }

  /// Calculates the current week number from a given date
  int getWeekNumberFromDate(DateTime date) {

    // Sets the time of day to be noon, thus mitigating the summer time issue
    date = DateTime(date.year, date.month, date.day, 12);

    // Find the number of days we are into the year. June 1st would be day 153
    final int dayOfYear =
        date.difference(DateTime(date. year, 1, 1)).inDays + 1;

    // If the current date is in the last three days of the year,
    // it might be in next year's first week
    if (weekIsNextYearsFirstWeek(date)) {
      return 1;
    }

    /*
    For the next part, an offset is added to the given date (dayOfYear),
    to ensure that we find the correct week. The offset is based on the day of
    the week that January 1st falls on, and the day of the week the given
    date is. We then divide by seven to find the week number,
    and add 1 because it is 0-indexed.
     */

    final int dayOfWeekJan1 = DateTime(date.year, 1, 1).weekday;

    // If January 1st falls on a Monday, Tuesday, Wednesday, or Thursday:
    if (dayOfWeekJan1 <= 4) {
      return ((dayOfYear + (dayOfWeekJan1 - 2)) / 7).floor() + 1;
    }

    // If January 1st falls on a Friday, Saturday, or a Sunday,
    // check if the given date belongs to last year's last week:
    else if (weekIsLastYearsLastWeek(dayOfYear, dayOfWeekJan1)) {
      return getLastYearsLastWeek(date);
    }

    else {
      return ((dayOfYear + (dayOfWeekJan1 - 9)) / 7).floor() + 1;
    }
  }

  /// Returns true if the given day is in last year's last week
  bool weekIsLastYearsLastWeek (int doy, int dowJan1) {
    return doy <= (
        (dowJan1 == 5) ? 3 :
        (dowJan1 == 6) ? 2 :
        (dowJan1 == 7) ? 1 : -1
    );
  }

  /// Returns true if given date is in next year's first week.
  bool weekIsNextYearsFirstWeek (DateTime date) {
    /*
    If next year's January 1st is a Tuesday, Wednesday, or a Thursday,
    and the given date is in the last days of this year, it is in the
    next year's week 1.
     */

    // We are not interested in the rest of the rest year
    if (date.month != 12 || date.day < 29) {
      return false;
    }

    // Day of next year's January 1st
    final int dowJan1ny = DateTime(date.year + 1, 1, 1).weekday;

    return ((dowJan1ny >= 2 && dowJan1ny <= 4) && (
        (dowJan1ny == 2 && date.day == 31) ||
        (dowJan1ny == 3 && (date.day == 31 || date.day == 30)) ||
        (dowJan1ny == 4 && (date.day == 31 || date.day == 30 || date.day == 29))
    )) ? true : false;
  }

  /// Returns last year's last week number (52 or 53)
  int getLastYearsLastWeek(DateTime date) {
    final DateTime lastYearsLastDay = DateTime(date.year - 1, 12, 28);

    return getWeekNumberFromDate(lastYearsLastDay);
  }

  /// Upcoming weekplans is sorted in ascending order
  List<WeekModel> _sortWeekPlans(List<WeekModel> list) {
    list.sort((WeekModel a, WeekModel b) {
      if (a.name == 'Tilføj ugeplan') {
        return -1;
      }
      if (a.weekYear == b.weekYear) {
        return a.weekNumber.compareTo(b.weekNumber);
      } else {
        return a.weekYear.compareTo(b.weekYear);
      }
    });
    return list;
  }

  /// Old weekplans needs to be sorted in descending order
  List<WeekModel> _sortOldWeekPlans(List<WeekModel> list) {
    list.toList().sort((WeekModel a, WeekModel b) {
      if (a.weekYear == b.weekYear) {
        return b.weekNumber.compareTo(a.weekNumber);
      } else {
        return b.weekYear.compareTo(a.weekYear);
      }
    });
    return list;
  }

  /// Checks if a week is in the past/expired
  bool isWeekDone(WeekNameModel weekPlan){
    final int currentYear = DateTime.now().year;
    final int currentWeek = getCurrentWeekNum();

    if (weekPlan.weekYear < currentYear ||
       (weekPlan.weekYear == currentYear && weekPlan.weekNumber < currentWeek)){
      return true;
    }
    return false;
  }

  /// Adds a new marked week model to the stream
  void toggleMarkedWeekModel(WeekModel weekModel) {
    final List<WeekModel> localMarkedWeekModels = _markedWeekModels.value;
    if (localMarkedWeekModels.contains(weekModel)) {
      localMarkedWeekModels.remove(weekModel);
    } else {
      localMarkedWeekModels.add(weekModel);
    }

    _markedWeekModels.add(localMarkedWeekModels);
  }

  /// Clears marked week models
  void clearMarkedWeekModels() {
    _markedWeekModels.add(<WeekModel>[]);
  }

  /// Checks if a week model is marked
  bool isWeekModelMarked(WeekModel weekModel) {
    if (_markedWeekModels.value == null) {
      return false;
    }
    return _markedWeekModels.value.contains(weekModel);
  }

  /// Delete the marked week models when the trash button is clicked
  void deleteMarkedWeekModels() {
    final List<WeekModel> localWeekModels = _weekModel.value;
    final List<WeekModel> oldLocalWeekModels = _oldWeekModel.value.toList();
    // Updates the weekplan in the database
    for (WeekModel weekModel in _markedWeekModels.value) {
      _api.week
          .delete(_user.id, weekModel.weekYear, weekModel.weekNumber)
          .listen((bool deleted) {
        if (deleted) {
          // Checks if its an old or upcoming weekplan
          if(localWeekModels != null && localWeekModels.contains(weekModel)){
            localWeekModels.remove(weekModel);
            _weekModel.add(localWeekModels);
          } else {
            oldLocalWeekModels.remove(weekModel);
            _oldWeekModel.add(oldLocalWeekModels);
          }
        }
      });
    }
    clearMarkedWeekModels();
  }

  /// This method deletes the given week model from the database after checking
  /// if it's an old weekplan or an upcoming
  void deleteWeekModel(WeekModel weekModel) {
    final List<WeekModel> localWeekModels = _weekModel.value;
    final List<WeekModel> oldLocalWeekModels = _oldWeekModel.value;

    if (localWeekModels != null && localWeekModels.contains(weekModel)) {
      deleteWeek(localWeekModels, weekModel);
    }
    else if (oldLocalWeekModels != null &&
      oldLocalWeekModels.contains(weekModel)){
      deleteWeek(oldLocalWeekModels, weekModel);
    }
  }

  /// This method deletes the given week model from the database
  void deleteWeek(List<WeekModel> weekModels, WeekModel weekModel){
    _api.week
        .delete(_user.id, weekModel.weekYear, weekModel.weekNumber)
        .listen((bool deleted) {
      if (deleted) {
        weekModels.remove(weekModel);
        _weekModel.add(weekModels);
      }
    });
  }

  /// Returns the number of marked week models
  int getNumberOfMarkedWeekModels() {
    return _markedWeekModels.value.length;
  }

  // Not sure if this method breaks bloc-pattern
  /// Returns all the marked week models.
  List<WeekModel> getMarkedWeekModels() {
    return _markedWeekModels.value;
  }

  /// Returns an updated version of the week model that is marked
  Future<WeekModel> getMarkedWeekModel() async {
    assert(_markedWeekModels.value.length == 1);
    final WeekModel marked = _markedWeekModels.value[0];

    final Completer<WeekModel> completer = Completer<WeekModel>();
    _api.week
        .get(_user.id, marked.weekYear, marked.weekNumber)
        .listen((WeekModel weekModel) => completer.complete(weekModel));

    return completer.future;
  }

  /// Toggles edit mode
  void toggleEditMode() {
    if (_editMode.value) {
      clearMarkedWeekModels();
    }
    _editMode.add(!_editMode.value);
  }

  /// This stream checks that you have only marked one week model
  Stream<bool> onlyOneModelMarkedStream() {
    return _markedWeekModels.map((List<WeekModel> event) => event.length == 1);
  }

  @override
  void dispose() {
    _weekModel.close();
    _weekNameModelsList.close();
  }
}
