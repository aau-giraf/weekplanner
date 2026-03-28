import 'package:file_picker/file_picker.dart';
import 'package:fpdart/fpdart.dart';

import 'package:weekplanner/core/errors/pictogram_failure.dart';
import 'package:weekplanner/shared/models/pictogram.dart';

/// Contract for pictogram data operations.
abstract class PictogramRepository {
  Future<Either<PictogramFailure, List<Pictogram>>> searchPictograms(
    String query,
  );
  Future<Either<PictogramFailure, Pictogram>> fetchPictogram(int id);
  Future<Either<PictogramFailure, Pictogram>> createPictogram({
    required String name,
    String? imageUrl,
    int? organizationId,
    bool generateImage = false,
    bool generateSound = true,
  });
  Future<Either<PictogramFailure, Pictogram>> uploadPictogram({
    required String name,
    required PlatformFile imageFile,
    PlatformFile? soundFile,
    int? organizationId,
    bool generateSound = true,
  });
}
