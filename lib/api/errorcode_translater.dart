import 'package:api_client/models/enums/error_key.dart';
import 'package:api_client/api/api_exception.dart';

/// Class for translating error codes to readable messages for the users
class ApiErrorTranslater {
  ///Get apropriate error message based on error code
  String getErrorMessage(ApiException error) {
    switch (error.errorKey) {
      case ErrorKey.UserAlreadyExists:
        return 'Brugernavnet eksisterer allerede';
      case ErrorKey.Error:
        // Undefined errors, the message is in english
        // as we cant predict why it was cast
        return 'message: ' +
            error.errorMessage +
            '\nDetails: ' +
            error.errorDetails;
      default:
        return 'Ukendt fejl';
    }
  }
}
