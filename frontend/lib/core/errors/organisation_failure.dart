/// Typed failures for organisation operations.
sealed class OrganisationFailure {
  /// Human-readable error message.
  final String message;

  const OrganisationFailure(this.message);
}

/// Failed to fetch the list of organisations.
final class FetchOrganisationsFailure extends OrganisationFailure {
  const FetchOrganisationsFailure()
      : super('Kunne ikke hente organisationer');
}

/// Failed to fetch citizens or grades for a selected organisation.
final class FetchCitizensFailure extends OrganisationFailure {
  const FetchCitizensFailure()
      : super('Kunne ikke hente borgere');
}
