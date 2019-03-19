import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/models/week_name_model.dart';
import 'package:weekplanner/providers/api/api.dart';

class WeekplanBloc extends BlocBase {

  final Api _api;
  final BehaviorSubject<WeekModel> _week = BehaviorSubject();

  final BehaviorSubject<List<WeekNameModel>> _weeks = BehaviorSubject();


  WeekplanBloc(this._api) {
    _api.week.getNames("1").listen((List<WeekNameModel> weeks){
      _weeks.add(weeks);
    });
  }

  Stream<WeekModel> get week => _week.stream;
  Stream<List<WeekNameModel>> get weeks => _weeks.stream;
  
  final Api _api;

  
  @override
  void dispose() {
    // TODO: implement dispose
  }
}