import 'package:api_client/models/enums/error_key.dart';
import 'package:api_client/api/api_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/widgets/giraf_notify_dialog.dart';

/// Class for translating error codes to readable messages for the users
class ApiErrorTranslater {
  /// Catch errors thrown by the api_clien
  /// (Can only handle ApiExceptions for now)
  void catchApiError(Object error, BuildContext context) {
    showDialog<Center>(

        /// exception handler to handle web_api exceptions
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return GirafNotifyDialog(
              title: 'Fejl',
              description: getErrorMessage(error),
              key: const Key('ErrorMessageDialog'));
        });
  }

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
