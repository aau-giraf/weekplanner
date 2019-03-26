import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/pictogram_model.dart';
import 'package:weekplanner/providers/api/api.dart';

class PictogramImageBloc extends BlocBase {
  Stream<Image> get image => _image.stream;

  final BehaviorSubject<Image> _image = BehaviorSubject();

  final Api _api;

  PictogramImageBloc(this._api);

  void load(PictogramModel pictogram) {
    _api.pictogram.getImage(pictogram.id).listen(_image.add);
  }

  void loadPictogramById(int id) {
    _api.pictogram.getImage(id).listen(_image.add);
  }

  @override
  void dispose() {
    _image.close();
  }
}