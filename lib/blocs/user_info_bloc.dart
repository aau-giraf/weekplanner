import 'package:flutter/material.dart';
import 'package:quiver/time.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart'; //curently just used to alert
import 'package:tuple/tuple.dart';

///The UserInfoBloc is used to switch between Guardian and citizen mode
class UserInfoBloc extends BlocBase{

  /// Mainly used for testing, in order to simulate that it is different days.
  Clock clock;

  UserInfoBloc([Clock clock]) {
    if (clock != null){
      this.clock = clock;
    }
    else{
      this.clock = new Clock();
    }
  }

  /// Indicates which mode we are in.
  bool isGuardian = true;

  /// Stream used to signal which mode we are in.
  Stream<String> get changeUserMode => _changeUserMode.stream;
  BehaviorSubject<String> _changeUserMode = new BehaviorSubject<String>.seeded('Guardian');

  /// Stream to signal both which day and mode we are in. Used for signaling which
  /// days to show and not to show.
  Stream<Tuple2<String, int>> get dayOfWeekAndUsermode => _dayOfWeekAndUsermode.stream;
  BehaviorSubject<Tuple2<String,int>> _dayOfWeekAndUsermode = new BehaviorSubject<Tuple2<String,int>>.seeded(Tuple2<String,int>('Guardian',0));

  /// Used for handling the logic of which mode to change to.
  void setUserMode(String isGuardian){
    if (isGuardian == 'Guardian'){
        _changeUserMode.add('Guardian');
        this.isGuardian = true;
        _dayOfWeekAndUsermode.add(Tuple2<String,int>('Guardian', getDate()));
      }
    else{
        _changeUserMode.add('Citizen');
        this.isGuardian = false;
        _dayOfWeekAndUsermode.add(Tuple2<String,int>('Citizen', getDate()));
    }
  }

  /// Gets the current day as an integer
  int getDate(){
    return clock.now().weekday;
  }


  @override
  void dispose() {
    _changeUserMode.close();
    _dayOfWeekAndUsermode.close();
  }




}