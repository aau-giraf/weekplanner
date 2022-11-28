import 'package:flutter/material.dart';
import 'package:weekplanner/screens/login_screen.dart';
import 'package:weekplanner/widgets/pictogram_password_widgets/pictogram_password_widget.dart';
import '../style/custom_color.dart' as theme;

/// The screen that contains functionality for logging in with pictograms.
class PictogramLoginScreen extends StatefulWidget {
  @override
  _PictogramLoginState createState() => _PictogramLoginState();
}

class _PictogramLoginState extends State<PictogramLoginScreen> {
  final ButtonStyle girafButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: theme.GirafColors.loginButtonColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
  );
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
          PictogramPassword(onPasswordChanged: onPasswordChanged, api: di.get<api>),
          Container(
            child: Transform.scale(
              scale: 1.2,
              child: ElevatedButton(
                style: girafButtonStyle,
                child: const Text(
                  'Brug standard adgangskode',
                  key: Key('UseNormalPasswordKey'),
                  style:
                  TextStyle(color: theme.GirafColors.white),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              LoginScreen()
                      )
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
