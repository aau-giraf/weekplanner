import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart'; //curently just used to alert

///The UserInfoBloc is used to switch between Guardian and citizen mode
class UserInfoBloc extends BlocBase{

  bool isGuardian = true;

  Stream<bool> get changeUserMode => _changeUserMode.stream;

  Stream<int> get dayOfWeek => _dayOfWeek.stream;

  BehaviorSubject<int> _dayOfWeek = new BehaviorSubject();

  BehaviorSubject<bool> _changeUserMode = new BehaviorSubject();



  void setUserMode(String isGuardian){
    if (isGuardian == 'Guardian')
      {
        _changeUserMode.add(true);
        this.isGuardian = true;
      }
    else{
        _changeUserMode.add(false);
        this.isGuardian = false;
        _dayOfWeek.add(getDate());
    }
  }

  int getDate(){
    return DateTime.now().weekday;
  }


  @override
  void dispose() {
    _changeUserMode.close();
    _dayOfWeek.close();
  }




}