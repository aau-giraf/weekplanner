import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart' as rx_dart;
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/api/api.dart';
import 'package:mutex/mutex.dart';

import 'blocs_api_exceptions.dart';

/// Pictogram-Image Business Logic Component
class PictogramImageBloc extends BlocBase {
  /// Pictogram-Image Business Logic Component
  ///
  /// Provides ability to load an pictogram-image and display it
  PictogramImageBloc(this._api);

  /// Provides loaded pictogram-images
  Stream<Image> get image => _image.stream;

  final rx_dart.BehaviorSubject<Image> _image
  = rx_dart.BehaviorSubject<Image>();

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
    try{
      _api.pictogram.getImage(pictogram.id).listen(_image.add);
    }on SocketException{throw BlocsApiException('Sock');}
    on HttpException{throw BlocsApiException('Http');}
    on TimeoutException{throw BlocsApiException('Time');}
    on FormatException{throw BlocsApiException('Form');}
    on Error catch(error)
    {throw BlocsApiException('spec', '', error);}
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
        rx_dart.Rx.retry<Image>(() {
          try{
            return _api.pictogram.getImage(id);
          }on SocketException{throw BlocsApiException('Sock');}
          on HttpException{throw BlocsApiException('Http');}
          on TimeoutException{throw BlocsApiException('Time');}
          on FormatException{throw BlocsApiException('Form');}
          on Error catch(error)
          {throw BlocsApiException('spec', '', error);}
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

  /// Delete pictogram
   bool delete (PictogramModel pm){
    bool result;
    try{
      final Stream<bool> res = _api.pictogram.delete(pm.id);

      if (res != null) {
        res.listen((bool success) {
          result = success ?? false;
        });
      }
      else{
        result = false;
      }
      return result;

    }on SocketException{throw BlocsApiException('Sock');}
    on HttpException{throw BlocsApiException('Http');}
    on TimeoutException{throw BlocsApiException('Time');}
    on FormatException{throw BlocsApiException('Form');}
    on Error catch(error)
    {throw BlocsApiException('spec', '', error);}
  }

  @override
  void dispose() {
    _image.close();
  }
}
