import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/bloc_base.dart';

/// This class servers as the authentication enforcer. That is, if you're not
/// logged in, this class will send you back to the login screen.
class ApplicationBloc extends BlocBase{

  Stream<bool> get ready => _ready.stream;

  BehaviorSubject<bool> _ready = BehaviorSubject();

  AuthBloc _authBloc;

  ApplicationBloc(this._authBloc);

  void checkLoggedIn(BuildContext context){
    _authBloc.loggedIn.listen((status){
      if(!status){
        Navigator.pushNamed(context, "/login");
      } else{
        _ready.add(true);
      }
    });
  }

  @override
  void dispose() {
    _ready.close();
  }

}