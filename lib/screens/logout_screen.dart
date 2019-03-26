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
    return Scaffold(
      appBar: GirafAppBar(
        title: 'Ugeplan',
      ),
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        padding: new EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/login_screen_background_image.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage("assets/giraf_splash_logo.png")),
              Expanded(
                child: Form(
                  child: ListView(
                    children: <Widget>[
                      Container(
                        child: new RaisedButton(
                          child: new Text(
                            'Log ud',
                            style: new TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            // Once the logout function has been called the user will be redirected to the login screen.
                            this._authBloc.logout();
                          },
                          color: Colors.blue,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
