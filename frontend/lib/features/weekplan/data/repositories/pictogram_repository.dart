import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logging/logging.dart';

import 'package:weekplanner/core/errors/pictogram_failure.dart';
import 'package:weekplanner/shared/models/pictogram.dart';
import 'package:weekplanner/shared/services/core_api_service.dart';

final _log = Logger('PictogramRepository');

/// Pure data layer for pictogram operations.
///
/// All methods return [Either] to communicate success or typed failure.
/// No state management — that responsibility belongs to the cubit.
class PictogramRepository {
  final CoreApiService _coreApiService;

  PictogramRepository({required CoreApiService coreApiService})
      : _coreApiService = coreApiService;

  /// Search pictograms by query string.
  Future<Either<PictogramFailure, List<Pictogram>>> searchPictograms(
    String query,
  ) async {
    try {
      final response = await _coreApiService.searchPictograms(query: query);
      return Right(response.items);
    } catch (e, stackTrace) {
      _log.severe('Failed to search pictograms', e, stackTrace);
      return Left(const SearchPictogramsFailure());
    }
  }

  /// Fetch a single pictogram by ID.
  Future<Either<PictogramFailure, Pictogram>> fetchPictogram(int id) async {
    try {
      final pictogram = await _coreApiService.fetchPictogram(id);
      return Right(pictogram);
    } catch (e, stackTrace) {
      _log.severe('Failed to fetch pictogram $id', e, stackTrace);
      return Left(const FetchPictogramFailure());
    }
  }

  /// Create a pictogram (optionally AI-generated).
  Future<Either<PictogramFailure, Pictogram>> createPictogram({
    required String name,
    String? imageUrl,
    int? organizationId,
    bool generateImage = false,
    bool generateSound = true,
  }) async {
    try {
      final pictogram = await _coreApiService.createPictogram(
        name: name,
        imageUrl: imageUrl,
        organizationId: organizationId,
        generateImage: generateImage,
        generateSound: generateSound,
      );
      return Right(pictogram);
    } catch (e, stackTrace) {
      _log.severe('Failed to create pictogram', e, stackTrace);
      return Left(const CreatePictogramFailure());
    }
  }

  /// Upload a pictogram with a local image file.
  Future<Either<PictogramFailure, Pictogram>> uploadPictogram({
    required String name,
    required PlatformFile imageFile,
    PlatformFile? soundFile,
    int? organizationId,
    bool generateSound = true,
  }) async {
    try {
      final pictogram = await _coreApiService.uploadPictogram(
        name: name,
        imageFile: _toMultipartFile(imageFile),
        soundFile: soundFile != null ? _toMultipartFile(soundFile) : null,
        organizationId: organizationId,
        generateSound: generateSound,
      );
      return Right(pictogram);
    } catch (e, stackTrace) {
      _log.severe('Failed to upload pictogram', e, stackTrace);
      return Left(const CreatePictogramFailure());
    }
  }

  /// Convert a [PlatformFile] to a Dio [MultipartFile].
  ///
  /// Uses bytes on web (where path is unavailable) and path on native.
  /// Throws [StateError] if neither bytes nor path is available.
  MultipartFile _toMultipartFile(PlatformFile file) {
    if (file.bytes != null) {
      return MultipartFile.fromBytes(file.bytes!, filename: file.name);
    }
    if (file.path != null) {
      return MultipartFile.fromFileSync(file.path!, filename: file.name);
    }
    throw StateError(
      'PlatformFile "${file.name}" has neither bytes nor path — '
      'cannot convert to MultipartFile',
    );
  }
}
