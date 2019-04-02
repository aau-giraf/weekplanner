import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/settings_screen.dart';
import 'package:weekplanner/blocs/user_info_bloc.dart';

/// The Default AppBar for every screen
class GirafAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Toolbar of the application.
  /// Default constructor.
  ///
  /// Takes a [title] which will be displayed at the left hand side of the bar
  GirafAppBar({Key key, this.title})
      : _authBloc = di.getDependency<AuthBloc>(),
        toolbarBloc = di.getDependency<ToolbarBloc>(),
        userInfoBloc = di.getDependency<UserInfoBloc>(),
        preferredSize = const Size.fromHeight(56.0),
        super(key: key);

  /// Used to store the title of the toolbar.
  final String title;

  /// Contains the functionality regarding login, logout etc.
  final AuthBloc _authBloc;

  /// Contains the functionality of the toolbar.
  final ToolbarBloc toolbarBloc;

  /// Contains the functionality of changing the weekplan.
  final UserInfoBloc userInfoBloc;

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
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
              return Visibility(
                key: const Key('visibilityEditBtn'),
                visible: snapshot.data,
                child: IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: 'Rediger',
                  onPressed: () {
                  },
                ),
              );
            }
        ),

        IconButton(
          icon: Image.asset('assets/icons/changeToCitizen.png'),
          tooltip: 'Skift mode',

          onPressed: () {
            if (userInfoBloc.isGuardian) {
              userInfoBloc.setUserMode('Citizen');
            }
            else{
              userInfoBloc.setUserMode('Guardian');
            }
          },
        ),
        
        IconButton(
            icon: Image.asset('assets/icons/logout.png'),
            tooltip: 'Log ud',
            onPressed: () {
              Alert(
                context: context,
                type: AlertType.none,
                style: _logoutStyle,
                title: 'Log ud',
                desc: 'Vil du logge ud?',
                buttons: <DialogButton> [
                  DialogButton(
                    child: Text(
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
                    child: Text(
                      'Log ud',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    onPressed: () {
                      _authBloc.logout();
                      Navigator.pop(context);
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
      ]
    );
  }

  final AlertStyle _logoutStyle = AlertStyle(
    animationType: AnimationType.grow,
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

