import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
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

  Future<Pictogram> createPictogram({
    required String name,
    String? imageUrl,
    int? organizationId,
    bool generateImage = false,
    bool generateSound = true,
  }) async {
    return await _coreApiService.createPictogram(
      name: name,
      imageUrl: imageUrl,
      organizationId: organizationId,
      generateImage: generateImage,
      generateSound: generateSound,
    );
  }

  Future<Pictogram> uploadPictogram({
    required String name,
    required PlatformFile imageFile,
    PlatformFile? soundFile,
    int? organizationId,
    bool generateSound = true,
  }) async {
    return await _coreApiService.uploadPictogram(
      name: name,
      imageFile: _toMultipartFile(imageFile),
      soundFile: soundFile != null ? _toMultipartFile(soundFile) : null,
      organizationId: organizationId,
      generateSound: generateSound,
    );
  }

  Future<Pictogram> uploadSound({
    required int pictogramId,
    required PlatformFile soundFile,
  }) async {
    return await _coreApiService.uploadPictogramSound(
      pictogramId: pictogramId,
      soundFile: _toMultipartFile(soundFile),
    );
  }

  /// Convert a [PlatformFile] to a Dio [MultipartFile].
  /// Uses bytes on web (where path is unavailable) and path on native.
  MultipartFile _toMultipartFile(PlatformFile file) {
    if (file.bytes != null) {
      return MultipartFile.fromBytes(file.bytes!, filename: file.name);
    }
    // file.path is only available on native platforms
    return MultipartFile.fromFileSync(file.path!, filename: file.name);
  }
}
