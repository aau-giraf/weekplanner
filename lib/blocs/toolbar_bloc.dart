import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/di.dart';

/// Contains the functionality of the toolbar.
class ToolbarBloc extends BlocBase {
  /// The current visibility of the edit-button.
  Stream<List<IconButton>> get visibleButtons => _visibleButtons.stream;

  final BehaviorSubject<List<IconButton>> _visibleButtons =
      BehaviorSubject<List<IconButton>>.seeded(<IconButton>[]);

  final AuthBloc _authBloc = di.getDependency<AuthBloc>();
  //// Based on a list of the enum AppBarIcon this method populates a list of IconButtons to render in the nav-bar
  void updateIcons(List<AppBarIcon> icons) {
  List<IconButton> _iconsToAdd = <IconButton>[];
    for (AppBarIcon icon in icons) {
      _iconsToAdd.add(_addIconButton(icon));
        //IconButton(
          // icon: Image.asset('assets/icons/settings.png'), onPressed: () {}));
    }
    _visibleButtons.add(_iconsToAdd);
  }
  /// Find the icon picture based on the input string
  IconButton _addIconButton(AppBarIcon icon) {
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
        break;
      case AppBarIcon.changeToGuardian:
        break;
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
        break;
      case AppBarIcon.undo:
        break;
      default:
        throw Exception("IconButton not implemented");
        return null;
    }
    
  }

  void _addSwitchToGuardian() {
    
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

  @override
  void dispose() {
    _visibleButtons.close();
  }
}
