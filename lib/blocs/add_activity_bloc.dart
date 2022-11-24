import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:rxdart/rxdart.dart' as rx_dart;
import 'package:flutter/material.dart';

/// Bloc used for adding activities to a citizen's day
class AddActivityBloc extends BlocBase{

  /// Stream holding the chosen pictogram
  Stream<Image> get chosenImage => _chosenImage.stream;

  final rx_dart.BehaviorSubject<Image> _chosenImage
  = rx_dart.BehaviorSubject<Image>();

  @override
  void dispose() {
    _chosenImage.close();
  }


}
