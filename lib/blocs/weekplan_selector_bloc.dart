import 'package:api_client/api/api.dart';
import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/week_name_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';

/// WeekplansBloc to get weekplans for a user
class WeekplansBloc extends BlocBase {
  /// This bloc obtains a list of all [WeekModel]'s
  /// for a given [UsernameModel].
  WeekplansBloc(this._api);

  /// This is a stream where all the [WeekNameModel] are put in,
  ///to be used when getting the [WeekModel].
  Stream<List<WeekNameModel>> get weekNameModels => _weekNameModelsList.stream;

  /// This is a stream where all the [WeekModel] are put in,
  /// and this is the stream to listen to,
  /// when wanting information about weekplans.
  Stream<List<WeekModel>> get weekModels => _weekModel.stream;

  /// The stream that emits whether in editMode or not
  Stream<bool> get editMode => _editMode.stream;

  /// The stream that emits the marked activities
  Stream<List<WeekModel>> get markedWeekModels => _markedWeekModels.stream;

  final BehaviorSubject<List<WeekModel>> _weekModel =
      BehaviorSubject<List<WeekModel>>();

  final BehaviorSubject<List<WeekNameModel>> _weekNameModelsList =
      BehaviorSubject<List<WeekNameModel>>();

  final BehaviorSubject<bool> _editMode = BehaviorSubject<bool>.seeded(false);

  final BehaviorSubject<List<WeekModel>> _markedWeekModels =
      BehaviorSubject<List<WeekModel>>.seeded(<WeekModel>[]);

  final Api _api;
  UsernameModel _user;

  /// To control adding an extra result for creating a new [WeekModel]
  /// for the weekplan_selector_screen.
  bool _addWeekplan;

  /// Loads all the [WeekNameModel] for a given [user].
  /// [addWeekplan] parameter controls if there should be a result
  ///  for adding a new [WeekModel].

  /// The result are published in [_weekNameModelsList].
  void load(UsernameModel user, [bool addWeekplan = false]) {
    _user = user;
    _addWeekplan = addWeekplan;
    weekNameModels.listen(getAllWeekInfo);
    _api.week.getNames(_user.id).listen(_weekNameModelsList.add);
  }

  /// Gets all the information for a [Weekmodel].
  /// [weekPlanNames] parameter contains all the information
  /// needed for getting all [WeekModel]'s.
  /// The result are published in [_weekModel].
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

    final List<Observable<WeekModel>> weekDetails = <Observable<WeekModel>>[];

    for (WeekNameModel weekPlanName in weekPlanNames) {
      weekDetails.add(_api.week
          .get(_user.id, weekPlanName.weekYear, weekPlanName.weekNumber)
          .take(1));
    }

    final Observable<List<WeekModel>> getWeekPlans = weekDetails.length < 2
        ? weekDetails[0].map((WeekModel plan) => <WeekModel>[plan])
        : Observable.combineLatestList(weekDetails);

    getWeekPlans
        .take(1)
        .map((List<WeekModel> plans) => weekPlans + plans)
        .map(_sortWeekPlans)
        .listen(_weekModel.add);
  }

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
    // Updates the weekplan in the database
    for (WeekModel weekmodel in _markedWeekModels.value) {
      _api.week
          .delete(_user.id, weekmodel.weekYear, weekmodel.weekNumber)
          .listen((bool deleted) {
        if (deleted) {
          localWeekModels.remove(weekmodel);
          _weekModel.add(localWeekModels);
        }
      });
    }

    clearMarkedWeekModels();
  }

  /// This method deletes the given week model from the database
  void deleteWeekModel(WeekModel weekModel) {
    final List<WeekModel> localWeekModels = _weekModel.value;

    if (localWeekModels.contains(weekModel)) {
      _api.week
          .delete(_user.id, weekModel.weekYear, weekModel.weekNumber)
          .listen((bool deleted) {
        if (deleted) {
          localWeekModels.remove(weekModel);
          _weekModel.add(localWeekModels);
        }
      });
    }
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

  /// Toggles edit mode
  void toggleEditMode() {
    if (_editMode.value) {
      clearMarkedWeekModels();
    }
    _editMode.add(!_editMode.value);
  }

  /// This stream checks that you have only marked one week model
  Observable<bool> editingIsValidStream() {
    return _markedWeekModels.map((List<WeekModel> event) => event.length == 1);
  }

  @override
  void dispose() {
    _weekModel.close();
    _weekNameModelsList.close();
  }
}
