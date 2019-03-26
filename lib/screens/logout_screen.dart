import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/di.dart';

class LogoutScreen extends StatelessWidget {
  final AuthBloc authBloc;

  LogoutScreen() : authBloc = di.getDependency<AuthBloc>();

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
                                'Log ud',
                                style: new TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                this.authBloc.logout();
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