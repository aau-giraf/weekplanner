import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:weekplanner/models/pictogram_model.dart';
import 'package:weekplanner/providers/api/api.dart';

class PictogramBloc extends BlocBase {
  Stream<List<PictogramModel>> get pictograms => _pictograms.stream;

  final BehaviorSubject<List<PictogramModel>> _pictograms = BehaviorSubject();

  final Api _api;
  DateTime lastUpdate;
  Timer _timer;
  final int _milliseconds = 250;

  PictogramBloc(this._api);

  void search(String query) {
    if (query.length < 1) {
      return;
    }

    if (_timer != null) {
      _timer.cancel();
    }

    _pictograms.add(null);

    _timer = Timer(Duration(milliseconds: _milliseconds), () {
      _api.pictogram
          .getAll(page: 1, pageSize: 10, query: query)
          .listen((List<PictogramModel> results) {
        _pictograms.add(results);
      });
    });
  }

  @override
  void dispose() {
    _pictograms.close();
  }
}
