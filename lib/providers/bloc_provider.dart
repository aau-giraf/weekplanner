import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/bloc_base.dart';

class BlocProvider<T extends BlocBase>{

  final T bloc;

  BlocProvider({@required this.bloc});

  Type typeOf() => T;
}

