import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/settings_screen.dart';
import 'package:weekplanner/widgets/giraf_confirm_dialog.dart';

/// Contains the functionality of the toolbar.
class ToolbarBloc extends BlocBase {
  /// The current visibility of the edit-button.
  Stream<List<IconButton>> get visibleButtons => _visibleButtons.stream;

  BehaviorSubject<List<IconButton>> _visibleButtons =
      BehaviorSubject<List<IconButton>>.seeded(<IconButton>[]);

  final AuthBloc _authBloc = di.getDependency<AuthBloc>();

  //// Based on a list of the enum AppBarIcon this method populates a list of IconButtons to render in the nav-bar
  void updateIcons(List<AppBarIcon> icons, BuildContext context) {
    List<IconButton> _iconsToAdd;
    _iconsToAdd = <IconButton>[];

    if (icons == null) {
      icons = <AppBarIcon>[];
      icons.add(AppBarIcon.settings);
      icons.add(AppBarIcon.logout);
    }
    for (AppBarIcon icon in icons) {
      _addIconButton(_iconsToAdd, icon, context);
    }

    final BehaviorSubject<List<IconButton>> iconList =
        BehaviorSubject<List<IconButton>>.seeded(<IconButton>[]);
    iconList.add(_iconsToAdd);
    _visibleButtons = iconList;
  }

  /// Find the icon picture based on the input enum
  void _addIconButton(
      List<IconButton> _iconsToAdd, AppBarIcon icon, BuildContext context) {
    switch (icon) {
      case AppBarIcon.accept:
        _iconsToAdd.add(_createIconAccept());
        break;
      case AppBarIcon.add:
        _iconsToAdd.add(_createIconAdd());
        break;
      case AppBarIcon.addTimer:
        _iconsToAdd.add(_createIconAddTimer());
        break;
      case AppBarIcon.back:
        _iconsToAdd.add(_createIconBack());
        break;
      case AppBarIcon.burgerMenu:
        _iconsToAdd.add(_createIconBurgermenu());
        break;
      case AppBarIcon.camera:
        _iconsToAdd.add(_createIconCamera());
        break;
      case AppBarIcon.cancel:
        _iconsToAdd.add(_createIconCancel());
        break;
      case AppBarIcon.changeToCitizen:
        _iconsToAdd.add(_createIconChangeToCitizen(context));
        break;
      case AppBarIcon.changeToGuardian:
        _iconsToAdd.add(_createIconChangeToGuardian(context));
        break;
      case AppBarIcon.copy:
        _iconsToAdd.add(_createIconCopy());
        break;
      case AppBarIcon.delete:
        _iconsToAdd.add(_createIconDelete());
        break;
      case AppBarIcon.edit:
        _iconsToAdd.add(_createIconEdit());
        break;
      case AppBarIcon.help:
        _iconsToAdd.add(_createIconHelp());
        break;
      case AppBarIcon.home:
        _iconsToAdd.add(_createIconHome());
        break;
      case AppBarIcon.logout:
        _iconsToAdd.add(_createIconLogout(context));
        break;
      case AppBarIcon.profile:
        _iconsToAdd.add(_createIconProfile());
        break;
      case AppBarIcon.redo:
        _iconsToAdd.add(_createIconRedo());
        break;
      case AppBarIcon.save:
        _iconsToAdd.add(_createIconSave());
        break;
      case AppBarIcon.search:
        _iconsToAdd.add(_createIconSearch());
        break;
      case AppBarIcon.settings:
        _iconsToAdd.add(_createIconSettings(context));
        break;
      case AppBarIcon.undo:
        _iconsToAdd.add(_createIconUndo());
        break;
      default:
        throw Exception('IconButton not implemented');
        break;
    }
  }

  IconButton _createIconAccept() {
    return IconButton(
      icon: Image.asset('assets/icons/accept.png'),
      tooltip: 'Accepter',
      onPressed: () {},
    );
  }

  IconButton _createIconAdd() {
    return IconButton(
      icon: Image.asset('assets/icons/add.png'),
      tooltip: 'Tilføj',
      onPressed: () {},
    );
  }

  IconButton _createIconAddTimer() {
    return IconButton(
      icon: Image.asset('assets/icons/addTimer.png'),
      tooltip: 'Tilføj timer',
      onPressed: () {},
    );
  }

  IconButton _createIconBack() {
    return IconButton(
      icon: Image.asset('assets/icons/back.png'),
      tooltip: 'Tilbage',
      onPressed: () {},
    );
  }

  IconButton _createIconBurgermenu() {
    return IconButton(
      icon: Image.asset('assets/icons/burgermenu.png'),
      tooltip: 'Åbn menu',
      onPressed: () {},
    );
  }

  IconButton _createIconCamera() {
    return IconButton(
      icon: Image.asset('assets/icons/camera.png'),
      tooltip: 'Åbn kamera',
      onPressed: () {},
    );
  }

  IconButton _createIconCancel() {
    return IconButton(
      icon: Image.asset('assets/icons/cancel.png'),
      tooltip: 'Fortryd',
      onPressed: () {},
    );
  }

  IconButton _createIconChangeToCitizen(BuildContext context) {
    return IconButton(
      icon: Image.asset('assets/icons/changeToCitizen.png'),
      tooltip: 'Skift til borger tilstand',
      onPressed: () {},
    );
  }

  IconButton _createIconChangeToGuardian(BuildContext context) {
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
                          style: const TextStyle(fontWeight: FontWeight.bold)),
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
  }

  IconButton _createIconCopy() {
    return IconButton(
      icon: Image.asset('assets/icons/copy.png'),
      tooltip: 'Kopier',
      onPressed: () {},
    );
  }

  IconButton _createIconDelete() {
    return IconButton(
      icon: Image.asset('assets/icons/delete.png'),
      tooltip: 'Slet',
      onPressed: () {},
    );
  }

  IconButton _createIconEdit() {
    return IconButton(
      icon: Image.asset('assets/icons/edit.png'),
      tooltip: 'Rediger',
      onPressed: () {},
    );
  }

  IconButton _createIconHelp() {
    return IconButton(
      icon: Image.asset('assets/icons/help.png'),
      tooltip: 'Hjælp',
      onPressed: () {},
    );
  }

  IconButton _createIconHome() {
    return IconButton(
      icon: Image.asset('assets/icons/home.png'),
      tooltip: 'Gå til startside',
      onPressed: () {},
    );
  }

  IconButton _createIconLogout(BuildContext context) {
    return IconButton(
      icon: Image.asset('assets/icons/logout.png'),
      tooltip: 'Log ud',
      onPressed: () {
        showDialog<Center>(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return GirafConfirmDialog(
                title: 'Log ud',
                description: 'Vil du logge ud?',
                confirmButtonText: 'Log ud',
                confirmButtonIcon:
                    const ImageIcon(AssetImage('assets/icons/logout.png')),
                confirmOnPressed: () => _authBloc.logout(),
              );
            });
      },
    );
  }

  IconButton _createIconProfile() {
    return IconButton(
      icon: Image.asset('assets/icons/profile.png'),
      tooltip: 'Vis profil',
      onPressed: () {},
    );
  }

  IconButton _createIconRedo() {
    return IconButton(
      icon: Image.asset('assets/icons/redo.png'),
      tooltip: 'Gendan',
      onPressed: () {},
    );
  }

  IconButton _createIconSave() {
    return IconButton(
      icon: Image.asset('assets/icons/save.png'),
      tooltip: 'Gem',
      onPressed: () {},
    );
  }

  IconButton _createIconSearch() {
    return IconButton(
      icon: Image.asset('assets/icons/search.png'),
      tooltip: 'Søg',
      onPressed: () {},
    );
  }

  IconButton _createIconSettings(BuildContext context) {
    return IconButton(
      icon: Image.asset('assets/icons/settings.png'),
      tooltip: 'Indstillinger',
      onPressed: () {
        Routes.push(context, SettingsScreen());
      },
    );
  }

  IconButton _createIconUndo() {
    return IconButton(
      icon: Image.asset('assets/icons/undo.png'),
      tooltip: 'Fortryd',
      onPressed: () {},
    );
  }

  /// Password controller for passing information from a text field
  /// to the authenticator.
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

  /// Used to authenticate a user.
  void login(BuildContext context, String username, String password) {
    _authBloc.authenticate(username, password);
  }

  @override
  void dispose() {
    _visibleButtons.close();
  }
}
