import 'dart:async';
import 'package:flutter/material.dart';

void show_loading_spinner(BuildContext context, bool dismissible,
    [void callback(), int timeoutMS]) {
  if (callback != null) {
    timeoutMS ??= 2000;
    Timer(Duration(milliseconds: timeoutMS), callback);
  }
  showDialog<Center>(
      barrierDismissible: dismissible,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Transform.scale(
              scale: 2,
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromRGBO(255, 157, 0, 0.8)),
              )),
        );
      });
}
