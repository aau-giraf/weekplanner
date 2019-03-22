import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:weekplanner/models/pictogram_model.dart';
import 'package:weekplanner/providers/api/api.dart';

class PictogramImageBloc extends BlocBase {
  /// Provides loaded pictogram-images
  Stream<Image> get image => _image.stream;

  final BehaviorSubject<Image> _image = BehaviorSubject();

  final Api _api;

  /// Pictogram-Image Business Logic Component
  ///
  /// Provides ability to load an pictogram-image and display it
  PictogramImageBloc(this._api);

  /// Initializes loading of a specific pictogram image
  ///
  /// The [pictogram] model should contain an ID which the API can then fetch.
  void load(PictogramModel pictogram) {
    _api.pictogram.getImage(pictogram.id).listen(_image.add);
  }

  @override
  void dispose() {
    _image.close();
  }
}