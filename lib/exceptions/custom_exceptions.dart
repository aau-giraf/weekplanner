class serverException implements Exception
{
  String errorCause;

  serverException(this.errorCause);
}