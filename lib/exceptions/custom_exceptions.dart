/// The file containing all custom exceptions, which
/// are relevant for the weekplaner (Not ApiClient)
class serverException implements Exception
{
  /// The cause of the error
  String errorCause;

  /// Constructor for the exception
  serverException(this.errorCause);
}