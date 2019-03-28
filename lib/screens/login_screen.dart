import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/di.dart';

/// Logs the user in
class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
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
                  TextField(
                    controller: _usernameCtrl,
                    keyboardType: TextInputType.text,
                    // Use email input type for emails.
                    decoration: InputDecoration(
                      hintText: '',
                      labelText: 'Brugernavn',
                      fillColor: Colors.white,
                    ),
                  ),
                  TextField(
                    controller: _passwordCtrl,
                    obscureText: true,
                    // Use email input type for emails.
                    decoration: InputDecoration(
                      hintText: '',
                      labelText: 'Adgangskode',
                      fillColor: Colors.white,
                    ),
                  ),
                  Container(
                    child: RaisedButton(
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _login(context, _usernameCtrl.value.text,
                            _passwordCtrl.value.text);
                      },
                      color: Colors.blue,
                    ),
                  ),
                  Container(
                    child: RaisedButton(
                      child: Text(
                        'Auto-Login',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _login(context, 'graatand', 'password');
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

  void _login(BuildContext context, String username, String password) {
    _authBloc.authenticate(username, password);
  }
}
