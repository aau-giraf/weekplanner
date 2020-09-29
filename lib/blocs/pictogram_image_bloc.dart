import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/api/api.dart';
import 'package:mutex/mutex.dart';

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

  static final Map<int, Image> _cache = <int, Image>{};
  static final Queue<int> _cacheQueue = Queue<int>();
  static const int _cacheMaxSize = 100;

  /// Lock for adding pictograms to cache
  static Mutex lock = Mutex();

  /// Initializes loading of a specific pictogram image
  ///
  /// The [pictogram] model should contain an ID which the API can then fetch.
  void load(PictogramModel pictogram) {
    _api.pictogram.getImage(pictogram.id).listen(_image.add);
  }

  /// Initialize loading of a specific [PictogramModel] from its [id].
  Future<bool> loadPictogramById(int id) async {
    await lock.acquire();
    try {
      if (_cache.containsKey(id)) {
        // Renew queue position
        _cacheQueue.removeWhere((int x) => x == id);
        _cacheQueue.add(id);

        _image.add(_cache[id]);
      } else {
        Observable<Image>.retry(() {
          return _api.pictogram.getImage(id);
        }, 3)
            .listen(
          (Image image) async {
            _image.add(image);

            await lock.acquire();
            try {
              _cache.putIfAbsent(id, () => image);
              _cacheQueue.add(id);

              while (_cacheQueue.length > _cacheMaxSize) {
                _cache.remove(_cacheQueue.removeFirst());
              }
            } finally {
              lock.release();
            }
          },
        );
      }
    } finally {
      lock.release();
    }
    return true;
  }

  void delete(PictogramModel pm){
    _api.pictogram.delete(pm.id);
  }

  @override
  void dispose() {
    _image.close();
  }
}
