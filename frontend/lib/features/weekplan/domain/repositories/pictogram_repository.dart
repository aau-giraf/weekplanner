import 'package:fpdart/fpdart.dart';

import 'package:weekplanner/core/errors/pictogram_failure.dart';
import 'package:weekplanner/shared/models/file_data.dart';
import 'package:weekplanner/shared/models/pictogram.dart';

/// Contract for pictogram data operations.
abstract interface class PictogramRepository {
  /// Search pictograms by query string.
  Future<Either<PictogramFailure, List<Pictogram>>> searchPictograms(
    String query,
  );

  /// Fetch a single pictogram by ID.
  Future<Either<PictogramFailure, Pictogram>> fetchPictogram(int id);

  /// Create a pictogram (optionally AI-generated).
  Future<Either<PictogramFailure, Pictogram>> createPictogram({
    required String name,
    String? imageUrl,
    int? organizationId,
    bool generateImage = false,
    bool generateSound = true,
  });

  /// Upload a pictogram with a local image file.
  Future<Either<PictogramFailure, Pictogram>> uploadPictogram({
    required String name,
    required FileData imageFile,
    FileData? soundFile,
    int? organizationId,
    bool generateSound = true,
  });
}
