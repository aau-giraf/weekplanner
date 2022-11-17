/// The file containing all custom exceptions, which
/// are relevant for the weekplanner (Not ApiClient)
class ServerException implements Exception {
  /// Constructor for the exception
  ServerException(this.errorCause, this.details);

  /// The cause of the error
  String errorCause;

  /// Details regarding the error
  String details;
}

/// EditWeekplanButtonException
class EditWeekplanButtonException implements Exception {
  /// Constructor for the exception
  EditWeekplanButtonException(this.errorCause, this.details);

  /// The cause of the error
  String errorCause;

  /// Details regarding the error
  String details;
}

/// OrientationException
class OrientationException implements Exception {
  /// Constructor for the exception
  OrientationException(this.errorCause, this.details);

  /// The cause of the error
  String errorCause;

  /// Details regarding the error
  String details;
}
