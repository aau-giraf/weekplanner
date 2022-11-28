import 'dart:io';
import 'package:flutter/material.dart';

/// The screen that contains functionality for loggin in with pictograms.
class PictogramLoginScreen extends StatefulWidget {
  @override
  _PictogramLoginState createState() => _PictogramLoginState();
}

class _PictogramLoginState extends State<PictogramLoginScreen> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      width: screenSize.width,
      height: screenSize.height,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        // The background of the login-screen
        image: DecorationImage(
          image: AssetImage('assets/login_screen_background_image.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: const Image(
              image: AssetImage('assets/giraf_splash_logo.png'),
            ),
            padding: const EdgeInsets.only(bottom: 10),
          ),
        ],
      ),
    ));
  }
}
