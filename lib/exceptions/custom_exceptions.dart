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

class EditWeekPlanButtonException implements Exception {
  /// Constructor for the exception
  EditWeekPlanButtonException(this.errorCause, this.details);

  /// The cause of the error
  String errorCause;

  /// Details regarding the error
  String details;
}
