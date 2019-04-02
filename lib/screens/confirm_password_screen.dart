import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/routes.dart';

class ConfirmPassword extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController passwordCtrl = TextEditingController();
  final AuthBloc _authBloc = di.getDependency<AuthBloc>();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
      width: screenSize.width,
      height: screenSize.height,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/login_screen_background_image.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
            Image(image: const AssetImage('assets/giraf_splash_logo.png')),
            Expanded(
                child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      text: 'Du er logget ind som ' + 
                      _authBloc.loggedInUsername,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black
                        
                        )
                    ),
                    textAlign: TextAlign.center, 
                  ),
                  TextField(
                    controller: passwordCtrl,
                    obscureText: true,
                    // Use email input type for emails.
                    decoration: InputDecoration(
                      hintText: 'Bekræft dit kodeord',
                      labelText: '',
                      fillColor: Colors.white,
                      alignLabelWithHint: true
                    ),
                  ),
                  Container(
                    child: RaisedButton(
                      child: Text(
                        'Bekræft',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        login(context, _authBloc.loggedInUsername,
                            passwordCtrl.value.text);
                            if (Navigator.canPop(context)) {
                              Routes.pop(context);
                            }
                      },
                      color: Colors.blue,
                    ),
                  ),
                  Container(
                    child: RaisedButton(
                      child: Text(
                        'Fortryd',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
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
    _authBloc.authenticate(username, password);
  }
}
