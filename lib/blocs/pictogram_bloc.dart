import 'dart:async';

import 'package:rxdart/rxdart.dart' as rx_dart;
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/api/api.dart';

/// For how long the debouncer should wait
const int _debounceTime = 250;
const int _timeoutTime = 10000;

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

  final rx_dart.BehaviorSubject<List<PictogramModel>> _pictograms =
      rx_dart.BehaviorSubject<List<PictogramModel>>();

  final Api _api;
  Timer _debounceTimer;

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
    if (_debounceTimer != null) {
      _debounceTimer.cancel();
    }

    _pictograms.add(null);
    List<PictogramModel> _resultPlaceholder;
    _debounceTimer = Timer(const Duration(milliseconds: _debounceTime), () {
      //Timer for sending an error if getting pictogram results takes too long
      Timer(const Duration(milliseconds: _timeoutTime), () {
        if (_resultPlaceholder == null || _resultPlaceholder.isEmpty) {
          _pictograms.addError('Søgningen gav ingen resultater. '
              'Tjek internetforbindelsen.');
        }
      });
      _api.pictogram
          .getAll(page: 1, pageSize: 10, query: query)
          .listen((List<PictogramModel> results) {
        _resultPlaceholder = results;
        _pictograms.add(_resultPlaceholder);
      });
    });
  }

  ///
  /// Deletes a chosen pictogram
  ///
  void delete(PictogramModel pm){
    _api.pictogram.delete(pm.id);
  }

  @override
  void dispose() {
    _pictograms.close();
  }
}
