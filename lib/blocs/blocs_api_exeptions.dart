import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/api/errorcode_translater.dart';
import '../main.dart';

///This class handles all api exeptions
class BlocsApiExeptions{


  ///this constructor allows developers to costumize errors
  BlocsApiExeptions(String errorType,
      [this.errormessage = 'opps noget gik galt',
        Object error]){
    ///switchen her er bare for at give nogle basale api fejl
    switch (errorType){
      case 'Sock':
        errormessage = 'kunne ikke få forbindelse til internettet';
        break;
      case 'Http':
        errormessage = 'kunne ikke finde den søgte side';
        break;
      case 'Time':
        errormessage = 'der skete en timeout fejl';
        break;
      case 'Form':
        errormessage = 'en formaterings fejl opstod';
        break;
      case 'spec':
         _translator.catchApiError(error, navigatorKey.currentContext);
        break;
    }
  }

  final ApiErrorTranslater _translator = ApiErrorTranslater();

  ///This string is used to contain error messages
  String errormessage;

  ///dette gøre man bare kan kaste vores api fejl
 @override
  String toString() {
    print('i got the error');
   showMyDialog();
   return errormessage;
 }

 ///denne del lave en alret besked som popper op til brugeren
  void showMyDialog() {
    showDialog<Center>(
        context: navigatorKey.currentContext,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('En problem opstod'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(errormessage),
                ],
              ),
            ),
          );
        }
    );
  }


}