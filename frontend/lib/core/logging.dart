import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

/// Log an error, extracting the server response body from [DioException]
/// when available. Falls back to standard [Logger.severe] for other errors.
void logServerError(
  Logger logger,
  String message,
  Object error,
  StackTrace stackTrace,
) {
  if (error is DioException) {
    final responseData = error.response?.data;
    logger.severe('$message — server: $responseData', error, stackTrace);
  } else {
    logger.severe(message, error, stackTrace);
  }
}
