import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
        body: Center(child: Container(
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
                        TextFormField(
                            keyboardType: TextInputType.text, // Use email input type for emails.
                            decoration: InputDecoration(
                                hintText: '',
                                labelText: 'Brugernavn',
                                fillColor: Colors.white,
                            ),
                        ),
                        TextFormField(
                          obscureText: true, // Use email input type for emails.
                          decoration: InputDecoration(
                            hintText: '',
                            labelText: 'Adgangskode',
                            fillColor: Colors.white,
                          ),
                        ),
                        Container(
                          child: new RaisedButton(
                            child: new Text(
                              'Login',
                              style: new TextStyle(
                                  color: Colors.white
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, "/weekplan");
                            },
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ))])),
        )
    ));
  }
}
