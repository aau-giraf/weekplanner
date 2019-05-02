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
    _api.week.getNames(_user.id).listen(_weekNameModelsList.add,
        onError: (Object exception) => getAllWeekInfo(null));
  }

  /// Gets all the information for a [Weekmodel].
  /// [weekNameModels] parameter contains all the information
  /// needed for getting all [WeekModel]'s.
  /// The result are published in [_weekModel].
  void getAllWeekInfo(List<WeekNameModel> weekNameModels) {
    final List<WeekModel> weekModels = <WeekModel>[];

    // This is used by weekplan_selector_screen for adding a new weekplan.
    if (_addWeekplan) {
      weekModels.add(WeekModel(name: 'Tilføj ugeplan'));
      _weekModel.add(weekModels);
    }
    if (weekNameModels == null) {
      return;
    }

    for (WeekNameModel weekNameModel in weekNameModels) {
      _api.week
          .get(_user.id, weekNameModel.weekYear, weekNameModel.weekNumber)
          .listen((WeekModel results) {
        weekModels.add(results);
        _weekModel.add(weekModels);
      });
    }
  }

  /// Adds a new marked week model to the stream
  void addMarkedWeekModel(WeekModel weekModel) {
    final List<WeekModel> localMarkedWeekModels = _markedWeekModels.value;

    localMarkedWeekModels.add(weekModel);
    _markedWeekModels.add(localMarkedWeekModels);
  }

  /// Removes a marked week model from the stream
  void removeMarkedWeekModel(WeekModel weekModel) {
    final List<WeekModel> localMarkedWeekModels = _markedWeekModels.value;

    localMarkedWeekModels.remove(weekModel);
    _markedWeekModels.add(localMarkedWeekModels);
  }

  /// Clears marked week models
  void clearMarkedWeekModels() {
    _markedWeekModels.add(<WeekModel>[]);
  }

  /// Checks if a week model is marked
  bool isActivityMarked(WeekModel weekModel) {
    if (_markedWeekModels.value == null){
      return false;
    }
    return _markedWeekModels.value.contains(weekModel);
  }

  /// Delete the marked week models when the trash button is clicked
  void deleteMarkedWeekModels() {
    clearMarkedWeekModels();

    // Updates the weekplan in the database
   // _api.week.update(user.id, week.weekYear,
     //   week.weekNumber, week).listen((WeekModel onData) {});
  }

  /// Returns the number of marked week models
  int getNumberOfMarkedWeekModels() {
    return _markedWeekModels.value.length;
  }

  /// Toggles edit mode
  void toggleEditMode() {
    _editMode.add(!_editMode.value);
  }

  @override
  void dispose() {
    _weekModel.close();
    _weekNameModelsList.close();
  }
}
