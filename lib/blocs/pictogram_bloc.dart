import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:weekplanner/models/pictogram_model.dart';
import 'package:weekplanner/providers/api/api.dart';

/// For how long the debouncer should wait
const int _milliseconds = 250;

/// Pictogram Business Logic Component
class PictogramBloc extends BlocBase {
  /// Pictogram Business Logic Component
  ///
  /// Gives the ability to search for pictograms and await the results.
  PictogramBloc(this._api);

  /// This stream is where all results from searching for pictograms are put in.
  ///
  /// The null value is used as a way to communicate loading. That is, if you
  /// receive null from this stream, you know to discard your previous results
  /// and display a loading indicator
  Stream<List<PictogramModel>> get pictograms => _pictograms.stream;

  final BehaviorSubject<List<PictogramModel>> _pictograms =
      BehaviorSubject<List<PictogramModel>>();

  final Api _api;
  Timer _timer;

  /// Initializes a search for [query].
  ///
  /// This does not accept empty strings.
  ///
  /// This function is debounced, so calling it twice, will cancel the first
  /// call, and replace it with the second. Waiting over 250ms will without any
  /// calls with execute the waiting search.
  ///
  /// The results are published in [pictograms].
  void search(String query) {
    if (query.isEmpty) {
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
