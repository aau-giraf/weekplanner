import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/widgets/giraf_notify_dialog.dart';

class blocs_api_exeptions{

  BuildContext currentContext;

  ///This string is used to contain error messages
  final String errormessage;

  ///this constructor allows developers to costumize errors
  blocs_api_exeptions([this.errormessage = 'opps something went wrong']);

  @override
  String toString(){
    

    return errormessage;
  }

}