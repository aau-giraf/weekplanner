import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/routes.dart';

class ConfirmPassword extends StatelessWidget {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final TextEditingController passwordCtrl = TextEditingController();
  final AuthBloc authBloc;

  ConfirmPassword() : authBloc = di.getDependency<AuthBloc>();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
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
              key: this._formKey,
              child: ListView(
                children: <Widget>[
                  
                  TextField(
                    controller: passwordCtrl,
                    obscureText: true,
                    // Use email input type for emails.
                    decoration: InputDecoration(
                      hintText: '',
                      labelText: 'Bekræft dit kodeord',
                      fillColor: Colors.white,
                    ),
                  ),
                  Container(
                    child: new RaisedButton(
                      child: new Text(
                        'Bekræft',
                        style: new TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        login(context, authBloc.loggedInUsername,
                            passwordCtrl.value.text);
                            if (Navigator.canPop(context)) {
                              Routes.pop(context);
                            }
                      },
                      color: Colors.blue,
                    ),
                  ),
                  Container(
                    child: new RaisedButton(
                      child: new Text(
                        'Auto-Bekræft',
                        style: new TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        login(context, "graatand", "password");
                        if (Navigator.canPop(context)) {
                          Routes.pop(context);
                        }
                      },
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ))
          ])),
    ));
  }

  void login(BuildContext context, String username, String password) {
    authBloc.authenticate(username, password);
  }
}
