import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/routes.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:weekplanner/screens/settings_screen.dart';

/// Toolbar of the application.
class GirafAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Toolbar of the application.
  GirafAppBar({Key key, this.title})
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
          StreamBuilder<bool>(
              key: const Key('streambuilderVisibility'),
              stream: toolbarBloc.editVisible,
              initialData: false,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return Visibility(
                  key: const Key('visibilityEditBtn'),
                  visible: snapshot.data,
                  child: IconButton(
                    icon: Image.asset('assets/icons/edit.png'),
                    tooltip: 'Rediger',
                    onPressed: () {},
                  ),
                );
              }),
          IconButton(
                key: const Key('changeUserMode'),
                icon: Image.asset('assets/icons/changeToCitizen.png'),
                tooltip: 'Skift til borger tilstand',
                onPressed: () {
                  Alert(
                      context: context,
                      style: _alertStyle,
                      title: 'Skift til værge',
                      content: Column(
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                              text: 'Logget ind som ',
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                    text: _authBloc.loggedInUsername,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          TextField(
                            key: const Key('passwordField'),
                            controller: passwordCtrl,
                            obscureText: true,
                            decoration: InputDecoration(
                              icon: const Icon(Icons.lock),
                              labelText: 'Adgangskode',
                            ),
                          ),
                        ],
                      ),
                      buttons: <DialogButton>[
                        DialogButton(
                          key: const Key('dialogBtn'),
                          onPressed: () {
                            loginFromPopUp(context, _authBloc.loggedInUsername,
                                passwordCtrl.value.text);
                          },
                          child: const Text(
                            'Bekræft',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          color: const Color.fromRGBO(255, 157, 0, 100),
                        )
                      ]).show();
                },
              ),
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
          IconButton(
            icon: Image.asset('assets/icons/settings.png'),
            tooltip: 'Indstillinger',
            onPressed: () {
              Routes.push(context, SettingsScreen());
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

  /// This functions calls the correct authenticate functions to authenticate
  /// a login done from the popup window.
  void loginFromPopUp(BuildContext context, String username, String password) {
     _authBloc.authenticateFromPopUp(username, password, context);
  }
}
