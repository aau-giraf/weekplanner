import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart'; //curently just used to alert

///The UserInfoBloc is used to switch between Guradian and citizen mode
class UserInfoBloc extends BlocBase{

  bool _isGuardian = true;

  Stream<bool> get changeUserMode => _changeUserMode.stream;

  BehaviorSubject<bool> _changeUserMode = new BehaviorSubject();



  void setUserMode(bool isGuardian){
    _changeUserMode.add(isGuardian);
  }

  void getDate(){
    print(DateTime.now().weekday);
  }


  @override
  void dispose() {

  }




}