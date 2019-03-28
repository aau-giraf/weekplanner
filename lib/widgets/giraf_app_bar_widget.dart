import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class GirafAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final AuthBloc _authBloc;

  GirafAppBar({Key key, this.title})
      : _authBloc = di.getDependency<AuthBloc>(),
        preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(title),
        backgroundColor: Color(0xAAFF6600),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: 'Indstillinger',
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          IconButton(
            icon: Icon(Icons.lock),
            tooltip: 'trains',
            onPressed: () {
              Alert(
                context: context,
                type: AlertType.none,
                style: logoutStyle,
                title: "Log ud",
                desc: "Vil du at logge ud?",
                buttons: [
                  DialogButton(
                    child: Text(
                      "Log ud",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    onPressed: () {
                      this._authBloc.logout();
                      Navigator.pop(context);
                    },
                    color: Color.fromRGBO(255, 157, 0, 100),
                    width: 120,
                  ),
                  DialogButton(
                    child: Text(
                      "Fortryd",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Color.fromRGBO(255, 157, 0, 100),
                    width: 120,
                  )
                ],
              ).show();
            },
          ),
          IconButton(
            icon: Icon(Icons.place),
            tooltip: 'trains',
            onPressed: () {},
          )
        ]);
  }

  var logoutStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: false,
    isOverlayTapDismiss: true,
    descStyle: TextStyle(fontWeight: FontWeight.normal),
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0.0),
      side: BorderSide(
        color: Colors.white,
      ),
    ),
    titleStyle: TextStyle(
      color: Colors.black,
    ),
  );
}

