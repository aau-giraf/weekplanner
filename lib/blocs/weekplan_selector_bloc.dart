import 'dart:async';
import 'dart:io';

import 'package:api_client/api/api.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/week_name_model.dart';
import 'package:rxdart/rxdart.dart' as rx_dart;
import 'package:weekplanner/blocs/bloc_base.dart';

import 'blocs_api_exeptions.dart';

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
    try{
      _api.week.getNames(_user.id).listen(_weekNameModelsList.add);
    }on SocketException{throw BlocsApiExeptions('Sock');}
    on HttpException{throw BlocsApiExeptions('Http');}
    on TimeoutException{throw BlocsApiExeptions('Time');}
    on FormatException{throw BlocsApiExeptions('Form');}

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
      try{
        if(isWeekDone(weekPlanName)) {
          oldWeekDetails.add(_api.week
              .get(_user.id, weekPlanName.weekYear, weekPlanName.weekNumber)
              .take(1));
        } else {
          weekDetails.add(_api.week
              .get(_user.id, weekPlanName.weekYear, weekPlanName.weekNumber)
              .take(1));
        }
        }on SocketException{throw BlocsApiExeptions('Sock');}
        on HttpException{throw BlocsApiExeptions('Http');}
        on TimeoutException{throw BlocsApiExeptions('Time');}
        on FormatException{throw BlocsApiExeptions('Form');}

    }
  }

  /// Returns the current week number
  int getCurrentWeekNum(){
    return getWeekNumberFromDate(DateTime.now());
  }

  /// Calculates the current week number from a given date
  int getWeekNumberFromDate(DateTime date) {

    // The if statement below is due to
    // an inconsistency with Duration (At the time of writing, 2020/11/04).
    // Once a year a day is duplicated, and at another time a day is skipped.
    // Example:
    // 2022/03/27 and 2022/03/28, both are day 86.
    // 2022/10/30 and 2022/10/31, are day 302 and day 304
    // This is a problem due to summer time.
    // DateTime.utc is another possibility, but it just adds an hour to
    // all days of the year.

    final Duration hoursToToday = date.difference(DateTime(date.year, 1, 1));

    int dayOfYear;

    // Find which day of the year the given date is.
    // Example: 14/10/2020 is day 288.
    // Is zero indexed, the "+ 1" is to make it one-indexed.
    // The "+ 2" is in the case where a day is skipped, explained above.
    if (hoursToToday.inHours % 24 == 0) {
      dayOfYear = hoursToToday.inDays + 1;
    }
    else {
      dayOfYear = hoursToToday.inDays + 2;
    }


    /*
    If next year's first of January is a Tuesday, Wednesday, or a Thursday,
    and the given date is in the last days of this year, it is in the
    next year's week 1.
     */
    final int dayOfWeekJan1NextYear = DateTime(date.year + 1, 1, 1).weekday;

    if (date.month == 12 &&
        dayOfWeekJan1NextYear >= 2 &&
        dayOfWeekJan1NextYear <= 4) {
      switch (dayOfWeekJan1NextYear) {
        case 2:
          if (date.day == 31) {
            return 1;
          }
          break;

        case 3:
          if (date.day == 31 || date.day == 30) {
            return 1;
          }
          break;

        case 4:
          if (date.day == 31 || date.day == 30 || date.day == 29) {
            return 1;
          }
          break;
      }
    }

    int weekNum;
    final int dayOfWeekJan1 = DateTime(date.year, 1, 1).weekday;

    /*
    An offset is added to the given date (dayOfYear), to ensure that we find
    the correct week. The offset is based on the day of the week that
    January 1st falls on, and the day of the week the given date is.
    We then divide by seven to find the week number,
    and add 1 because it is 0-indexed.
     */

    // If January 1st falls on a Monday, Tuesday, Wednesday, or Thursday:
    if (dayOfWeekJan1 <= 4) {
      weekNum = ((dayOfYear + (dayOfWeekJan1 - 2)) / 7).floor() + 1;
    }

    // If January 1st falls on a Friday, Saturday, or a Sunday,
    // check if the given date belongs to last year's last week:
    else {
      int n;

      switch (dayOfWeekJan1) {
        case 5:
          n = 3;
          break;
        case 6:
          n = 2;
          break;
        case 7:
          n = 1;
          break;
      }

      if (dayOfYear <= n) {
        weekNum = getLastYearLastWeek(date);
      }
      else {
        weekNum = ((dayOfYear + (dayOfWeekJan1 - 9)) / 7).floor() + 1;
      }
    }

    return weekNum;
  }
  ///this gets last year last week
  int getLastYearLastWeek(DateTime date) {
    final DateTime lastYearLastDay = DateTime(date.year - 1, 12, 31);

    return getWeekNumberFromDate(lastYearLastDay);
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
    try{
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
    }on SocketException{throw BlocsApiExeptions('Sock');}
    on HttpException{throw BlocsApiExeptions('Http');}
    on TimeoutException{throw BlocsApiExeptions('Time');}
    on FormatException{throw BlocsApiExeptions('Form');}
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
    try{
      _api.week
          .delete(_user.id, weekModel.weekYear, weekModel.weekNumber)
          .listen((bool deleted) {
        if (deleted) {
          weekModels.remove(weekModel);
          _weekModel.add(weekModels);
        }
      });
    }on SocketException{throw BlocsApiExeptions('Sock');}
    on HttpException{throw BlocsApiExeptions('Http');}
    on TimeoutException{throw BlocsApiExeptions('Time');}
    on FormatException{throw BlocsApiExeptions('Form');}

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
    try{
      _api.week
          .get(_user.id, marked.weekYear, marked.weekNumber)
          .listen((WeekModel weekModel) => completer.complete(weekModel));
    }on SocketException{throw BlocsApiExeptions('Sock');}
    on HttpException{throw BlocsApiExeptions('Http');}
    on TimeoutException{throw BlocsApiExeptions('Time');}
    on FormatException{throw BlocsApiExeptions('Form');}

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
