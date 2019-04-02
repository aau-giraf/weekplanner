import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/api/api.dart';

/// Pictogram-Image Business Logic Component
class PictogramImageBloc extends BlocBase {
  /// Pictogram-Image Business Logic Component
  ///
  /// Provides ability to load an pictogram-image and display it
  PictogramImageBloc(this._api);

  /// Provides loaded pictogram-images
  Stream<Image> get image => _image.stream;

  final BehaviorSubject<Image> _image = BehaviorSubject<Image>();

  final Api _api;

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
