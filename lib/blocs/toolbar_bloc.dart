import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/settings_screen.dart';

/// Contains the functionality of the toolbar.
class ToolbarBloc extends BlocBase {
  /// The current visibility of the edit-button.
  Stream<List<IconButton>> get visibleButtons => _visibleButtons.stream;

  final BehaviorSubject<List<IconButton>> _visibleButtons =
      BehaviorSubject<List<IconButton>>.seeded(<IconButton>[]);

  final AuthBloc _authBloc = di.getDependency<AuthBloc>();

  //// Based on a list of the enum AppBarIcon this method populates a list of IconButtons to render in the nav-bar
  void updateIcons(List<AppBarIcon> icons, BuildContext context) {
  List<IconButton> _iconsToAdd = <IconButton>[];
    for (AppBarIcon icon in icons) {
      _iconsToAdd.add(_addIconButton(icon, context));
        //IconButton(
          // icon: Image.asset('assets/icons/settings.png'), onPressed: () {}));
    }
    _visibleButtons.add(_iconsToAdd);
  }
  /// Find the icon picture based on the input string
  IconButton _addIconButton(AppBarIcon icon, BuildContext context) {
    switch (icon) {
      case AppBarIcon.accept:
        
        break;
      case AppBarIcon.add:
        break;
      case AppBarIcon.addTimer:
        break;
      case AppBarIcon.back:
        break;
      case AppBarIcon.burgerMenu:
        break;
      case AppBarIcon.camera:
        break;
      case AppBarIcon.cancel:
        break;
      case AppBarIcon.changeToCitizen:
        
      case AppBarIcon.changeToGuardian:
        return IconButton(
            icon: Image.asset('assets/icons/changeToGuardian.png'),
            tooltip: 'Skift til værge tilstand',
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
                      onPressed: () {
                        login(context, _authBloc.loggedInUsername,
                            passwordCtrl.value.text);
                        Routes.pop(context);
                      },
                      child: const Text(
                        'Bekræft',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: const Color.fromRGBO(255, 157, 0, 100),
                    )
                  ]).show();
            },
          );
      case AppBarIcon.copy:
        break;
      case AppBarIcon.delete:
        break;
      case AppBarIcon.edit:
        break;
      case AppBarIcon.help:
        break;
      case AppBarIcon.home:
        break;
      case AppBarIcon.logout:
        return IconButton(
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
          );
      case AppBarIcon.profile:
        break;
      case AppBarIcon.redo:
        break;
      case AppBarIcon.save:
        break;
      case AppBarIcon.search:
        break;
      case AppBarIcon.settings:
        return IconButton(
            icon: Image.asset('assets/icons/settings.png'),
            tooltip: 'Indstillinger',
            onPressed: () {
              Routes.push(context, SettingsScreen());
            },
          );
      case AppBarIcon.undo:
        break;
      default:
        throw Exception("IconButton not implemented");
        return null;
    }
    
  }

  final TextEditingController passwordCtrl = TextEditingController();

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

  @override
  void dispose() {
    _visibleButtons.close();
  }
}
