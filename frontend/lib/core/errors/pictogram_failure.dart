/// Typed failures for pictogram operations.
sealed class PictogramFailure {
  /// Human-readable error message.
  final String message;

  const PictogramFailure(this.message);
}

/// Failed to search pictograms.
final class SearchPictogramsFailure extends PictogramFailure {
  const SearchPictogramsFailure()
      : super('Kunne ikke søge piktogrammer');
}

/// Failed to fetch a single pictogram.
final class FetchPictogramFailure extends PictogramFailure {
  const FetchPictogramFailure()
      : super('Kunne ikke hente piktogram');
}

/// Failed to create or upload a pictogram.
final class CreatePictogramFailure extends PictogramFailure {
  const CreatePictogramFailure()
      : super('Kunne ikke oprette piktogram');
}
