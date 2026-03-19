import 'package:flutter/foundation.dart';
import 'package:weekplanner/shared/models/pictogram.dart';
import 'package:weekplanner/shared/services/core_api_service.dart';

class PictogramRepository extends ChangeNotifier {
  final CoreApiService _coreApiService;

  PictogramRepository({required CoreApiService coreApiService})
      : _coreApiService = coreApiService;

  List<Pictogram> _pictograms = [];
  bool _isLoading = false;
  String? _error;

  List<Pictogram> get pictograms => _pictograms;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> searchPictograms(String query) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _coreApiService.searchPictograms(query: query);
      _pictograms = response.items;
    } catch (e) {
      _error = 'Kunne ikke søge piktogrammer';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<Pictogram?> fetchPictogram(int id) async {
    try {
      return await _coreApiService.fetchPictogram(id);
    } catch (e) {
      return null;
    }
  }
}
