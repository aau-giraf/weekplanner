import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/api/errorcode_translater.dart';
import 'package:weekplanner/widgets/giraf_notify_dialog.dart';
import '../main.dart';

///This class handles all api exeptions
class BlocsApiException{

  ///this constructor allows developers to costumize errors
  BlocsApiException(String errorType,
      [this.errormessage = 'opps noget gik galt',
        Object error]){
    ///this switch finds the relevent exeption
    switch (errorType){
      case 'Sock':
        errormessage = 'kunne ikke få forbindelse til internettet';
        showMyDialog();
        break;
      case 'Http':
        errormessage = 'kunne ikke finde den søgte side';
        showMyDialog();
        break;
      case 'Time':
        errormessage = 'der skete en timeout fejl';
        showMyDialog();
        break;
      case 'Form':
        errormessage = 'en formaterings fejl opstod';
        showMyDialog();
        break;
      case 'spec'://if the exeption is not a exeption but a error send it to
      // the error handler
         _translator.catchApiError(error, navigatorKey.currentContext);
        break;
    }
  }

  final ApiErrorTranslater _translator = ApiErrorTranslater();

  ///This string is used to contain error messages
  String errormessage;

 ///This part creates the message
  void showMyDialog() {
    showDialog<Center>(
        context: navigatorKey.currentContext,
        builder: (BuildContext context) {
          return GirafNotifyDialog(
              title: 'Noget gik galt',
              description: errormessage,
              key: const Key('ErrorMessageDialog'));
        });
  }

}