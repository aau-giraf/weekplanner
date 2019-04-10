import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:weekplanner/models/username_model.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/models/week_name_model.dart';
import 'package:weekplanner/providers/api/api.dart';

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

  final BehaviorSubject<List<WeekModel>> _weekModel =
      BehaviorSubject<List<WeekModel>>();

  final BehaviorSubject<List<WeekNameModel>> _weekNameModelsList =
      BehaviorSubject<List<WeekNameModel>>();

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

  @override
  void dispose() {
    _weekModel.close();
    _weekNameModelsList.close();
  }
}
