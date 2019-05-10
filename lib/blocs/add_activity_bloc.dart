import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

/// Bloc used for adding activities to a citizen's day
class AddActivityBloc extends BlocBase{

  /// Stream holding the chosen pictogram
  Stream<Image> get chosenImage => _chosenImage.stream;

  final BehaviorSubject<Image> _chosenImage = BehaviorSubject<Image>();

  @override
  void dispose() {
    _chosenImage.close();
  }


}
