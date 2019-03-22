
import 'package:flutter/material.dart';
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


  WeekplanBloc(this._api);

  Stream<WeekModel> get week => _week.stream;

  getWeek1(){
    _api.week.get('379d057b-85b1-41b6-a1bd-6448c132745b', 2018, 26).listen((WeekModel week) {
      _week.add(week);
    });
  }

  @override
  void dispose() {
    _week.close();
 }
}