import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

/// Simple version of the toolbar of the application.
class GirafAppBarSimple extends StatelessWidget implements PreferredSizeWidget {
  /// Toolbar of the application.
  GirafAppBarSimple({Key key, this.title})
      : _authBloc = di.getDependency<AuthBloc>(),
        toolbarBloc = di.getDependency<ToolbarBloc>(),
        preferredSize = const Size.fromHeight(56.0),
        super(key: key);

  /// Used to store the title of the toolbar.
  final String title;

  /// Used to pass the password from the text field to the authBloc.
  final TextEditingController passwordCtrl = TextEditingController();

  /// Contains the functionality regarding login, logout etc.
  final AuthBloc _authBloc;

  /// Contains the functionality of the toolbar.
  final ToolbarBloc toolbarBloc;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(title),
        backgroundColor: const Color(0xAAFF6600),
        actions: <Widget>[
          IconButton(
            icon: Image.asset('assets/icons/logout.png'),
            tooltip: 'Log ud',
            onPressed: () {
              Alert(
                context: context,
                type: AlertType.none,
                style: _alertStyle,
                title: 'Log ud',
                desc: 'Vil du logge ud?',
                buttons: <DialogButton>[
                  DialogButton(
                    child: const Text(
                      'Fortryd',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: const Color.fromRGBO(255, 157, 0, 100),
                    width: 120,
                  ),
                  DialogButton(
                    child: const Text(
                      'Log ud',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    onPressed: () {
                      _authBloc.logout();
                    },
                    color: const Color.fromRGBO(255, 157, 0, 100),
                    width: 120,
                  ),
                ],
              ).show();
            },
          ),
        ]);
  }

  final AlertStyle _alertStyle = AlertStyle(
    animationType: AnimationType.grow,
    isCloseButton: true,
    isOverlayTapDismiss: true,
    descStyle: const TextStyle(fontWeight: FontWeight.normal),
    animationDuration: const Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0.0),
      side: const BorderSide(
        color: Colors.white,
      ),
    ),
    titleStyle: const TextStyle(
      color: Colors.black,
    ),
  );

  void login(BuildContext context, String username, String password) {
    _authBloc.authenticate(username, password);
  }
}
