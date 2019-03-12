import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/globals.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

class Logout extends StatelessWidget {
  AuthBloc authBloc = Globals.authBloc;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

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
                      key: this._formKey,
                      child: ListView(
                        children: <Widget>[
                          Container(
                            child: new RaisedButton(
                              child: new Text(
                                'Log out',
                                style: new TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                this.authBloc.logout();
                                Navigator.pushNamed(context, "/login");
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
}