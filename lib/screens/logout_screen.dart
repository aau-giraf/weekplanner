import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/di.dart';

// Screen used to confirm the users logout.
class LogoutScreen extends StatelessWidget {
  final AuthBloc _authBloc;

  // The logout screen uses the AuthBloc to determine if the user has logged in or not and will use its function to logout.
  LogoutScreen() : _authBloc = di.getDependency<AuthBloc>();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    bool portrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool keyboard = MediaQuery.of(context).viewInsets.bottom > 100;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        padding: portrait
            ? EdgeInsets.fromLTRB(50, 0, 50, 0)
            : EdgeInsets.fromLTRB(200, 0, 200, 8),
        decoration: BoxDecoration(
          // The background of the login-screen
          image: const DecorationImage(
            image: const AssetImage("assets/login_screen_background_image.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GetLogo(keyboard, portrait),
              Form(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Container(
                        child: Transform.scale(
                          scale: 1.5,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0)),
                            child: Text(
                              'Log ud',
                              style: const TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              // Once the logout method is called the auth controller will redirect to the login screen.
                              this._authBloc.logout();
                            },
                            color: const Color.fromRGBO(48, 81, 118, 1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ]),
      ),
    );
  }

  Widget GetLogo(bool Keyboard, bool Portrait) {
    if (Keyboard) {
      return Container();
    }

    return Transform.scale(
      scale: Portrait ? 1.0 : 0.5,
      child: const Image(
        image: const AssetImage("assets/giraf_splash_logo.png"),
      ),
    );
  }

}
