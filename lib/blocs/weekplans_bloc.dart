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


  final rx_dart.BehaviorSubject<List<WeekNameModel>?> _weekNameModels =
  rx_dart.BehaviorSubject<List<WeekNameModel>?>();

  /// This is a stream where all the [WeekNameModel] are put in,
  ///to be used when getting the [WeekModel].
  Stream<List<WeekNameModel>?> get weekNameModels => _weekNameModels.stream;


  final rx_dart.BehaviorSubject<List<WeekModel>> _weekModels =
  rx_dart.BehaviorSubject<List<WeekModel>>();

  /// This is a stream where all the future [WeekModel] are put in,
  /// and this is the stream to listen to,
  /// when wanting information about weekplans.

  Stream<List<WeekModel>> get weekModels => _weekModels.stream;

  final rx_dart.BehaviorSubject<List<WeekModel>> _oldWeekModels =
  rx_dart.BehaviorSubject<List<WeekModel>>();

  /// This is a stream where all the old [WeekModel] are put in,
  /// and this is the stream to listen to,
  /// when wanting information about weekplans.
  Stream<List<WeekModel>> get oldWeekModels => _oldWeekModels.stream;

  final rx_dart.BehaviorSubject<List<WeekModel>> _markedWeekModels =
  rx_dart.BehaviorSubject<List<WeekModel>>.seeded(<WeekModel>[]);

  /// The stream that emits the marked activities
  Stream<List<WeekModel>> get markedWeekModels => _markedWeekModels.stream;

  final rx_dart.BehaviorSubject<bool> _editMode =
      rx_dart.BehaviorSubject<bool>.seeded(false);

  /// The stream that emits whether in editMode or not
  Stream<bool> get editMode => _editMode.stream;

  final Api _api;
  late DisplayNameModel _user;

  /// To control adding an extra result for creating a new [WeekModel]
  /// for the weekplan_selector_screen.
  late bool _addWeekplan;

  /// Loads all the [WeekNameModel] for a given [user].
  /// [addWeekplan] parameter controls if there should be a result
  ///  for adding a new [WeekModel].

  /// The result are published in [_weekNameModels]. The function does several things. It loads the parameters into local variables.
  /// Next it calls getAllWeekInfo on the weekNameModels returned from the stream
  /// (This is a function that retrieves the weekModels and oldWeekModels from a list of weekNameModels).
  void load(DisplayNameModel user, [bool addWeekplan = false]) {
    _user = user;
    _addWeekplan = addWeekplan;
    weekNameModels.listen(getAllWeekInfo);
    _api.week.getNames(_user.id!).listen(_weekNameModels.add);
  }

  /// List stores weekModels
  final List<WeekModel> currentData = <WeekModel>[];

  /// Method handles adding weekModels to _weekModel stream
  void addWeekModels(List<WeekModel> weekModel) {
    currentData.addAll(weekModel);
    _weekModels.add(currentData);
  }

  /// List stores old weekModels
  final List<WeekModel> oldCurrentData = <WeekModel>[];

  /// Method handles adding weekModels to _oldWeekModel stream
  void addOldWeekModels(List<WeekModel> weekModel) {
    oldCurrentData.addAll(weekModel);
    _oldWeekModels.add(oldCurrentData);
  }

  /// Gets all the information for a [Weekmodel].
  /// [weekNameModels] parameter contains all the information
  /// needed for getting all [WeekModel]'s.
  /// The upcoming weekplans are published in [_weekModels].
  /// Old weekplans are published in [_oldWeekModels].
  /// This function is only used in the load function
  void getAllWeekInfo(List<WeekNameModel>? weekNameModels) {
    final List<WeekModel> weekModels = <WeekModel>[];

    // This is used by weekplan_selector_screen for adding a new weekplan.
    if (_addWeekplan) {
      weekModels.add(WeekModel(name: 'Tilføj ugeplan'));
    }

    if (weekNameModels!.isEmpty) {
      _weekModels.add(weekModels);
      return;
    }

    final List<Stream<WeekModel>> weekModelList = <Stream<WeekModel>>[];
    final List<Stream<WeekModel>> oldWeekmodelList = <Stream<WeekModel>>[];

    getWeekDetails(weekNameModels, weekModelList, oldWeekmodelList);

    final Stream<List<WeekModel>> getWeekPlans =
        reformatWeekDetailsToObservableList(weekModelList);

    final Stream<List<WeekModel>> getOldWeekPlans =
        reformatWeekDetailsToObservableList(oldWeekmodelList);

    getWeekPlans
        .take(1)
        .map((List<WeekModel> plans) => weekModels + plans)
        .map(_sortWeekPlans)
        .listen(_weekModels.add);

    getOldWeekPlans
        .take(1)
        .map((List<WeekModel> plans) => plans)
        .map(_sortOldWeekPlans)
        .listen(_oldWeekModels.add);
  }

  /// Reformats [weekDetails] and [oldWeekDetails] into an Observable List
  Stream<List<WeekModel>> reformatWeekDetailsToObservableList(
      List<Stream<WeekModel>> details) {
    // ignore: always_specify_types
    return details.isEmpty
        // Ignore type specification; Stream<WeekModel>
        //   does not contain .empty()
        // ignore: always_specify_types
        ? const Stream.empty()
        : details.length == 1
            ? details[0].map((WeekModel plan) => <WeekModel>[plan])
            : rx_dart.Rx.combineLatestList(details);
  }

  /// Makes API calls to get the weekmodels from the weekNameModels
  /// Old weekplans are stored in [oldWeekModels]
  /// and current/upcoming weekModels are stored in [weekModels]. Note this
  /// function is only used as part of getAllWeekInfo.
  void getWeekDetails(
      List<WeekNameModel>? weekNameModels,
      List<Stream<WeekModel>> weekModels,
      List<Stream<WeekModel>> oldWeekModels) {
    // Loops through all weekplans and sort them into old and upcoming weekplans
    for (WeekNameModel weekPlanName in weekNameModels!) {
      if (isWeekDone(weekPlanName)) {
        oldWeekModels.add(_api.week
            .get(_user.id!, weekPlanName.weekYear!, weekPlanName.weekNumber!)
            .take(1));
      } else {
        weekModels.add(_api.week
            .get(_user.id!, weekPlanName.weekYear!, weekPlanName.weekNumber!)
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
    // Get the preliminary week number
    final int weekNum = getWeekNumberFromNearestThursday(date);

    // Define a day that is in the last week of the year.
    // ## December 28th is always in the last week of the year ##
    final DateTime dayInLastWeekThisYear = DateTime(date.year, 12, 28);
    final DateTime dayInLastWeekLastYear = DateTime(date.year - 1, 12, 28);

    // If the preliminary week number is 0,
    // the given date is in last year's last week
    if (weekNum == 0) {
      return getWeekNumberFromNearestThursday(dayInLastWeekLastYear);
    }
    // If the preliminary week number is bigger than the amount of weeks in
    // the given date's year, it is in the next year's week 1
    else if (weekNum >
        getWeekNumberFromNearestThursday(dayInLastWeekThisYear)) {
      return 1;
    }
    // If none of the cases described above are true, the
    // preliminary week number is the actual week number
    else {
      return weekNum;
    }
  }

  /// Calculates the week number from the nearest Thursday of the given date
  int getWeekNumberFromNearestThursday(DateTime date) {
    // Sets the time of day to be noon, thus mitigating the summer time issue
    date = DateTime(date.year, date.month, date.day, 12);

    // Find the number of days we are into the year. June 1st would be day 153
    final int dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;

    const int dayOfWeekThursday = 4;

    // Find the day of the year for the nearest Thursday to the given date.
    // ## The week number for the given date,
    //    is the same as its nearest Thursday's ##
    final int nearestThursday = (dayOfYear - date.weekday) + dayOfWeekThursday;

    // Find how many weeks have passed since the first Thursday plus 1 as:
    // ## The first Thursday of a year is always in week 1 ##
    return (nearestThursday / 7).floor() + 1;
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
  bool isWeekDone(WeekNameModel? weekPlan) {
    final int currentYear = DateTime.now().year;
    final int currentWeek = getCurrentWeekNum();

    if (weekPlan!.weekYear! < currentYear ||
        (weekPlan.weekYear == currentYear &&
            weekPlan.weekNumber! < currentWeek)) {
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
    return _markedWeekModels.value.contains(weekModel);
  }

  /// Delete the marked week models when the trash button is clicked
  void deleteMarkedWeekModels() {
    final List<WeekModel>? localWeekModels =
        _weekModels.hasValue ? _weekModels.value : null;
    final List<WeekModel>? oldLocalWeekModels =
        _oldWeekModels.hasValue ? _oldWeekModels.value.toList() : null;
    // Updates the weekplan in the database
    for (WeekModel weekModel in _markedWeekModels.value) {
      _api.week
          .delete(_user.id!, weekModel.weekYear, weekModel.weekNumber)
          .listen((bool deleted) {
        if (deleted) {
          // Checks if its an old or upcoming weekplan
          if (localWeekModels != null && localWeekModels.contains(weekModel)) {
            localWeekModels.remove(weekModel);
            _weekModels.add(localWeekModels);
          } else {
            oldLocalWeekModels!.remove(weekModel);
            _oldWeekModels.add(oldLocalWeekModels);
          }
        }
      });
    }
    clearMarkedWeekModels();
  }



  /// This method deletes the given weekmodel from the database after checking
  /// if it's an old weekplan or an upcoming.
  void deleteWeekModel(WeekModel weekModel) {
    final List<WeekModel>? localWeekModels =
        _weekModels.hasValue ? _weekModels.value : null;
    final List<WeekModel>? oldLocalWeekModels =
        _oldWeekModels.hasValue ? _oldWeekModels.value : null;

    if (localWeekModels != null && localWeekModels.contains(weekModel)) {
      _deleteWeekFromDatabase(localWeekModels, weekModel);
    } else if (oldLocalWeekModels != null &&
        oldLocalWeekModels.contains(weekModel)) {
      _deleteWeekFromDatabase(oldLocalWeekModels, weekModel);
    }
  }

  /// This helper-method deletes the given week model from the database
  void _deleteWeekFromDatabase(List<WeekModel> weekModels, WeekModel weekModel) {
    _api.week
        .delete(_user.id!, weekModel.weekYear, weekModel.weekNumber)
        .listen((bool deleted) {
      if (deleted) {
        _deleteWeekFromStream(weekModels, weekModel);
      }
    });
  }

  ///This helper-method removes the given week model from the streams
  void _deleteWeekFromStream(List<WeekModel> weekModels, WeekModel weekModel) {
    weekModels.remove(weekModel);
    _weekModels.add(weekModels);
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
        .get(_user.id!, marked.weekYear, marked.weekNumber)
        .listen((WeekModel weekModel) => completer.complete(weekModel));

    return completer.future;
  }

  /// Returns a WeekModel list of the marked weeks
  Future<List<WeekModel>> getMarkedWeeks() async {
    final List<WeekModel> weekList = <WeekModel>[];
    for (WeekModel weekModel in _markedWeekModels.value) {
      final Completer<WeekModel> completer = Completer<WeekModel>();
      _api.week
          .get(_user.id!, weekModel.weekYear, weekModel.weekNumber)
          .listen((WeekModel weekModel) => completer.complete(weekModel));
      weekList.add(await completer.future);
    }
    return weekList;
  }

  /// Toggles edit mode
  void toggleEditMode() {
    if (_editMode.value) {
      clearMarkedWeekModels();
    }
    _editMode.add(!_editMode.value);
  }


  /// This stream checks that you have only marked one week model. It is currently
  /// not being used
  Stream<bool> onlyOneModelMarkedStream() {
    return _markedWeekModels.map((List<WeekModel> event) => event.length == 1);
  }

  @override
  void dispose() {
    _weekModels.close();
    _weekNameModels.close();
  }
}
