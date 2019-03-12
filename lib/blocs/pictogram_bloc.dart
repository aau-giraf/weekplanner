import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:weekplanner/models/pictogram_model.dart';
import 'package:weekplanner/providers/api/api.dart';

class PictogramBloc extends BlocBase {

  Stream<List<PictogramModel>> get pictograms => _pictograms.stream;

  final BehaviorSubject<List<PictogramModel>> _pictograms = BehaviorSubject();

  final Api _api;

  PictogramBloc(this._api);

  void search(String query) {
    _api.pictogram.getAll(page: 1, pageSize: 10, query: query).listen((
        List<PictogramModel> results) {
      _pictograms.add(results);
    });
  }

  @override
  void dispose() {
    _pictograms.close();
  }
}