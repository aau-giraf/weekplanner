import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/models/giraf_user_model.dart';
import 'package:weekplanner/models/username_model.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/models/week_name_model.dart';
import 'package:weekplanner/providers/api/api.dart';

class WeekplanBloc extends BlocBase {

  final Api _api;
  final BehaviorSubject<WeekModel> _week = BehaviorSubject<WeekModel>();

  final BehaviorSubject<List<WeekNameModel>> _weeks = BehaviorSubject<List<WeekNameModel>>();


  WeekplanBloc(this._api);

  Stream<WeekModel> get week => _week.stream;
  Stream<List<WeekNameModel>> get weeks => _weeks.stream;

  getCharlie(){
    _api.user.me().flatMap((GirafUserModel user) {
      return _api.user.getCitizens(user.id);
    }).listen((List<UsernameModel> citizens) {
      for(UsernameModel c in citizens){
        print(c.name +" " + c.id);
      }
    });
  }

  getWeeks(){
    _api.week.getNames('379d057b-85b1-41b6-a1bd-6448c132745b').listen((List<WeekNameModel> weeks) {
      for(WeekNameModel w in weeks){
        print(w.name + " " + w.weekNumber.toString() + " " + w.weekYear.toString());
      }
    });
  }

  getWeek1(){
    _api.week.get('379d057b-85b1-41b6-a1bd-6448c132745b', 2018, 26).listen((WeekModel week) {
      _week.add(week);
    });
  }

  getWeek2(){
        _api.week.get('379d057b-85b1-41b6-a1bd-6448c132745b', 2018, 21).listen((WeekModel week) {
      _week.add(week);
    });
  }


  @override
  void dispose() {
    _weeks.close();
    _week.close();
 }
}