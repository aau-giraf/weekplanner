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
  //final GirafUserModel _user;

  WeekplanSelectBloc(this._api);

  void load(){
    _api.week.getNames("ID HER").listen(_weeknamemodelsList.add);
    weeknamemodels.listen(getAllWeekInfo);
  }

  void getAllWeekInfo(List<WeekNameModel> weeknamemodels){

    List<WeekModel> weekModels = []; 
    for (WeekNameModel weeknamemodel in weeknamemodels) {
      _api.week.get("ID HER", weeknamemodel.weekYear, weeknamemodel.weekNumber).listen(weekModels.add);
    }
    _weekmodel.add(weekModels);
  }
  
  @override
  void dispose() {
    _weekmodel.close();
    _weeknamemodelsList.close();
  }
}