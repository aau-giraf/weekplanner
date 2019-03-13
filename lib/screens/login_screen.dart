import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/widgets/bloc_provider_tree_widget.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  bool Loading = false;
  AuthBloc authBloc;

  @override
  Widget build(BuildContext context) {
    authBloc = BlocProviderTree.of<AuthBloc>(context);
    final Size screenSize = MediaQuery.of(context).size;
    bool Portrait = MediaQuery.of(context).orientation == Orientation.portrait;
    bool Keyboard = MediaQuery.of(context).viewInsets.bottom > 100;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        padding: Portrait
            ? EdgeInsets.fromLTRB(50, 0, 50, 250)
            : Keyboard
                ? EdgeInsets.fromLTRB(200, 0, 200, 120)
                : EdgeInsets.fromLTRB(200, 20, 200, 10),
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
              GetLogo(Keyboard, Portrait),
              Form(
                key: this._formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: Portrait
                          ? EdgeInsets.fromLTRB(0, 20, 0, 10)
                          : EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Container(
                        decoration: new BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius:
                                new BorderRadius.all(new Radius.circular(20.0)),
                            color: Colors.white),
                        padding: new EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                        child: TextField(
                          style: Portrait
                              ? TextStyle(fontSize: 30)
                              : TextStyle(fontSize: 20),
                          controller: usernameCtrl,
                          keyboardType: TextInputType.text,
                          // Use email input type for emails.
                          decoration: InputDecoration.collapsed(
                            hintText: "Brugernavn",
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Container(
                        decoration: new BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius:
                                new BorderRadius.all(new Radius.circular(20.0)),
                            color: Colors.white),
                        padding: new EdgeInsets.all(8.0),
                        child: TextField(
                          onSubmitted: (newValue) {
                            authBloc.loggedIn.take(1).listen((status) {
                              if (status) {
                                Navigator.pushNamed(context, "/choosecitizen");
                              }
                            });
                            authBloc.authenticate(
                                usernameCtrl.value.text, newValue);
                          },
                          style: Portrait
                              ? TextStyle(fontSize: 30)
                              : TextStyle(fontSize: 20),
                          controller: passwordCtrl,
                          obscureText: true,
                          decoration: InputDecoration.collapsed(
                            hintText: 'Adgangskode',
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                      child: Container(
                        child: Transform.scale(
                          scale: 1.5,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0)),
                            child: Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              authBloc.loggedIn.take(1).listen((status) {
                                if (status) {
                                  Navigator.pushNamed(
                                      context, "/choosecitizen");
                                }
                              });
                              authBloc.authenticate(usernameCtrl.value.text,
                                  passwordCtrl.value.text);
                            },
                            color: Color.fromRGBO(48, 81, 118, 1),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Transform.scale(
                        scale: 1.2,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Text(
                            'Auto-Login',
                            style: new TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            usernameCtrl.text = "Graatand";
                            passwordCtrl.text = "password";
                          },
                          color: Color.fromRGBO(48, 81, 118, 1),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ])),
      ),
    );
  }

  Widget GetLogo(bool Keyboard, bool Portrait) {
    if (Keyboard && !Portrait) {
      return Container();
    }

    return Transform.scale(
      scale: Portrait ? 1.0 : 0.5,
      child: Image(
        image: AssetImage("assets/giraf_splash_logo.png"),
      ),
    );
  }


}
