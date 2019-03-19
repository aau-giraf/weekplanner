import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:weekplanner/models/giraf_user_model.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/models/week_name_model.dart';
import 'package:weekplanner/providers/api/api.dart';

class WeekplanSelectBloc extends BlocBase{
  
  Stream<List<WeekNameModel>> get weeknamemodels => _weeknamemodelsList.stream;
  Stream<List<WeekModel>> get weekmodels => _weekmodel.stream;

  final BehaviorSubject<List<WeekModel>> _weekmodel = BehaviorSubject();
  final BehaviorSubject<List<WeekNameModel>> _weeknamemodelsList = BehaviorSubject();

  final Api _api;

  WeekplanSelectBloc(this._api){
    load();
  }

  void load(){
    _api.week.getNames("379d057b-85b1-41b6-a1bd-6448c132745b").listen(_weeknamemodelsList.add);
    weeknamemodels.listen(getAllWeekInfo);
  }

  void getAllWeekInfo(List<WeekNameModel> weeknamemodels){

    List<WeekModel> weekModels = [];
    weekModels.add(new WeekModel(name: "Tilføj Ugeplan"));

    for (WeekNameModel weeknamemodel in weeknamemodels) {
      _api.week
          .get("379d057b-85b1-41b6-a1bd-6448c132745b", weeknamemodel.weekYear, weeknamemodel.weekNumber)
          .listen((WeekModel results) {
        weekModels.add(results);
      });
    }

    _weekmodel.add(weekModels);
  }
  
  @override
  void dispose() {
    _weekmodel.close();
    _weeknamemodelsList.close();
  }
}