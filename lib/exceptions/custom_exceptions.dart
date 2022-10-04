/// The file containing all custom exceptions, which
/// are relevant for the weekplanner (Not ApiClient)
class ServerException implements Exception
{
  /// Constructor for the exception
  ServerException(this.errorCause);

  /// The cause of the error
  String errorCause;
}