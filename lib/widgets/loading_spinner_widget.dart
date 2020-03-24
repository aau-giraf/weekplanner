import 'dart:async';
import 'package:flutter/material.dart';
import '../style/custom_color.dart' as theme;

/// Callback is optional and gives functionality that allows a
/// method to be called after the timeout
///
/// Callback should be a void method, with no parameters
///
/// timeoutMS defaults to 2000 ms
void showLoadingSpinner(BuildContext context, bool dismissible,
    [void callback(), int timeoutMS]) {
  // If there is no callback method, no need for a timer
  if (callback != null) {
    timeoutMS ??= 2000;
    Timer(Duration(milliseconds: timeoutMS), callback);
  }

  showDialog<Center>(
      barrierDismissible: dismissible,
      context: context,
      builder: (BuildContext context) {
        return const LoadingSpinnerWidget();
      });
}

/// The Giraf standardized loading spinner used throughout the application
class LoadingSpinnerWidget extends StatelessWidget {
	/// Default constructor
  const LoadingSpinnerWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.scale(
          scale: 2,
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                theme.GirafColors.loadingColor),
          )),
    );
  }
}
