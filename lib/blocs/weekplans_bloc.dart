import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/giraf_user_model.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/models/week_name_model.dart';
import 'package:weekplanner/providers/api/api.dart';

class WeekplansBloc extends BlocBase {
  Stream<List<WeekNameModel>> get weekNameModels => _weekNameModelsList.stream;

  Stream<List<WeekModel>> get weekModels => _weekModel.stream;

  final BehaviorSubject<List<WeekModel>> _weekModel = BehaviorSubject();
  final BehaviorSubject<List<WeekNameModel>> _weekNameModelsList = BehaviorSubject();
  final Api _api;
  GirafUserModel _user;
  bool _addWeekplan;

  WeekplansBloc() : _api = di.getDependency<Api>();


  void load(GirafUserModel user, [bool addWeekplan = false]) {
    this._user = user; this._addWeekplan = addWeekplan;
    weekNameModels.listen(getAllWeekInfo);
    _api.week.getNames(_user.id).listen(_weekNameModelsList.add);
  }

  void getAllWeekInfo(List<WeekNameModel> weekNameModels) {
    List<WeekModel> weekModels = [];
    if (this._addWeekplan)
      weekModels.add(new WeekModel(name: "Tilføj Ugeplan"));

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
