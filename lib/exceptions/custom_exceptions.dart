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

class SaveButtonException implements Exception {
  /// Constructor for the exception
  SaveButtonException(this.errorCause, this.details);

  /// The cause of the error
  String errorCause;

  /// Details regarding the error
  String details;
}
