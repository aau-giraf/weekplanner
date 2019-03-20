import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/models/giraf_user_model.dart';
import 'package:weekplanner/models/username_model.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/models/week_name_model.dart';
import 'package:weekplanner/providers/api/api.dart';

class WeekplanBloc extends BlocBase {

  final Api _api;
  final BehaviorSubject<WeekModel> _week = BehaviorSubject();

  final BehaviorSubject<List<WeekNameModel>> _weeks = BehaviorSubject();


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

  @override
  void dispose() {

 }
}