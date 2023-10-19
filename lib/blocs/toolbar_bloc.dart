import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rxdart/rxdart.dart' as rx_dart;
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';
import 'package:weekplanner/models/enums/weekplan_mode.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/style/font_size.dart';
import 'package:weekplanner/widgets/giraf_confirm_dialog.dart';
import 'package:weekplanner/widgets/giraf_notify_dialog.dart';
import 'package:weekplanner/widgets/loading_spinner_widget.dart';
import '../style/custom_color.dart' as theme;

final AuthBloc _authBloc = di.get<AuthBloc>();

/// Contains the functionality of the toolbar.
class ToolbarBloc extends BlocBase {
  /// If the confirm button in popup is clickable.
  bool _clickable = true;

  final rx_dart.BehaviorSubject<List<IconButton>> _visibleButtons =
      rx_dart.BehaviorSubject<List<IconButton>>.seeded(<IconButton>[]);

  /// The current visibility of the edit-button.
  Stream<List<IconButton>> get visibleButtons => _visibleButtons.stream;

  //// Based on a list of the enum AppBarIcon this method populates a list of IconButtons to render in the nav-bar
  void updateIcons(
      Map<AppBarIcon, VoidCallback>? icons, BuildContext? context) {
    List<IconButton>? _iconsToAdd;
    _iconsToAdd = <IconButton>[];

    // Assigns a map to icons, if icons is null.
    icons ??= <AppBarIcon, VoidCallback>{AppBarIcon.logout: () {}};

    for (AppBarIcon icon in icons.keys) {
      _addIconButton(_iconsToAdd, icon, icons[icon], context);
    }

    _visibleButtons.add(_iconsToAdd);
  }

  /// Find the icon picture based on the input enum
  void _addIconButton(List<IconButton> _iconsToAdd, AppBarIcon icon,
      VoidCallback? callback, BuildContext? context) {
    switch (icon) {
      case AppBarIcon.accept:
        _iconsToAdd.add(_createIconAccept(callback!));
        break;
      case AppBarIcon.add:
        _iconsToAdd.add(_createIconAdd(callback!));
        break;
      case AppBarIcon.addTimer:
        _iconsToAdd.add(_createIconAddTimer(callback!));
        break;
      case AppBarIcon.back:
        _iconsToAdd.add(_createIconBack(context!));
        break;
      case AppBarIcon.burgerMenu:
        _iconsToAdd.add(_createIconBurgermenu(callback!));
        break;
      case AppBarIcon.camera:
        _iconsToAdd.add(_createIconCamera(callback!));
        break;
      case AppBarIcon.cancel:
        _iconsToAdd.add(_createIconCancel(callback!));
        break;
      case AppBarIcon.changeToCitizen:
        _iconsToAdd.add(_createIconChangeToCitizen(context!));
        break;
      case AppBarIcon.changeToGuardian:
        _iconsToAdd.add(_createIconChangeToGuardian(context!));
        break;
      case AppBarIcon.copy:
        _iconsToAdd.add(_createIconCopy(callback!));
        break;
      case AppBarIcon.delete:
        _iconsToAdd.add(_createIconDelete(callback!));
        break;
      case AppBarIcon.edit:
        _iconsToAdd.add(_createIconEdit(callback!));
        break;
      case AppBarIcon.help:
        _iconsToAdd.add(_createIconHelp(callback!));
        break;
      case AppBarIcon.home:
        _iconsToAdd.add(_createIconHome(callback!));
        break;
      case AppBarIcon.logout:
        _iconsToAdd.add(_createIconLogout(context));
        break;
      case AppBarIcon.profile:
        _iconsToAdd.add(_createIconProfile(callback!));
        break;
      case AppBarIcon.redo:
        _iconsToAdd.add(_createIconRedo(callback!));
        break;
      case AppBarIcon.save:
        _iconsToAdd.add(_createIconSave(callback!));
        break;
      case AppBarIcon.search:
        _iconsToAdd.add(_createIconSearch(callback!));
        break;
      case AppBarIcon.settings:
        _iconsToAdd.add(_createIconSettings(callback!));
        break;
      case AppBarIcon.undo:
        _iconsToAdd.add(_createIconUndo(callback!));
        break;
      case AppBarIcon.gallery:
        _iconsToAdd.add(_createIconGallery(callback!));
        break;
      default:
        throw Exception('IconButton not implemented');
      //break;
    }
  }

  IconButton _createIconAccept(VoidCallback callback) {
    return IconButton(
      icon: Image.asset('assets/icons/accept.png'),
      tooltip: 'Accepter',
      onPressed: callback,
    );
  }

  IconButton _createIconAdd(VoidCallback callback) {
    return IconButton(
      icon: Image.asset('assets/icons/add.png'),
      tooltip: 'Tilføj',
      onPressed: callback,
    );
  }

  IconButton _createIconAddTimer(VoidCallback callback) {
    return IconButton(
      icon: Image.asset('assets/icons/addTimer.png'),
      tooltip: 'Tilføj timer',
      onPressed: callback,
    );
  }

  IconButton _createIconBack(BuildContext context) {
    return IconButton(
      key: const Key('BackButton'),
      icon: Image.asset('assets/icons/back.png'),
      tooltip: 'Tilbage',
      onPressed: () {
        Routes().pop(context);
      },
    );
  }

  IconButton _createIconBurgermenu(VoidCallback callback) {
    return IconButton(
      icon: Image.asset('assets/icons/burgermenu.png'),
      tooltip: 'Åbn menu',
      onPressed: callback,
    );
  }

  IconButton _createIconCamera(VoidCallback callback) {
    return IconButton(
      icon: Image.asset('assets/icons/camera.png'),
      tooltip: 'Åbn kamera',
      onPressed: callback,
    );
  }

  IconButton _createIconCancel(VoidCallback callback) {
    return IconButton(
      icon: Image.asset('assets/icons/cancel.png'),
      tooltip: 'Fortryd',
      onPressed: callback,
    );
  }

  IconButton _createIconGallery(VoidCallback callback) {
    return IconButton(
      icon: Image.asset('assets/icons/gallery.png'),
      tooltip: 'Tilføj fra galleri',
      onPressed: callback,
    );
  }

  IconButton _createIconChangeToCitizen(BuildContext context) {
    return IconButton(
        key: const Key('IconChangeToCitizen'),
        icon: Image.asset('assets/icons/changeToCitizen.png'),
        tooltip: 'Skift til borger tilstand',
        onPressed: () {
          showDialog<GirafConfirmDialog>(
              context: context,
              builder: (BuildContext context) {
                return GirafConfirmDialog(
                  confirmButtonIcon: const ImageIcon(
                      AssetImage('assets/icons/changeToCitizen.png')),
                  confirmButtonText: 'Skift',
                  description: 'Vil du skifte til borger tilstand?',
                  confirmOnPressed: () {
                    _authBloc.setMode(WeekplanMode.citizen);
                    Routes().pop(context);
                  },
                  title: 'Skift til borger',
                  key: UniqueKey(),
                );
              });
        });
  }

  IconButton _createIconChangeToGuardian(BuildContext context) {
    return IconButton(
      key: const Key('IconChangeToGuardian'),
      icon: Image.asset('assets/icons/changeToGuardian.png'),
      tooltip: 'Skift til værge tilstand',
      onPressed: () {
        createPopupDialog(context).show();
      },
    );
  }

  /// Return the dialog of the popup.
  Alert createPopupDialog(BuildContext context) {
    /// UserName/Password controller for passing information from a text field
    /// to the authenticator.
    final TextEditingController userNameCtrl = TextEditingController();
    final TextEditingController passwordCtrl = TextEditingController();

    return Alert(
        context: context,
        style: _alertStyle,
        title: 'Skift til værge',
        content: Column(
          children: <Widget>[
            RichText(
              text: TextSpan(
                text: 'Log ind som værger',
                style: DefaultTextStyle.of(context).style,
              ),
            ),
            TextField(
              key: const Key('SwitchToGuardianUserName'),
              controller: userNameCtrl,
              obscureText: false,
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Brugernavn',
              ),
            ),
            TextField(
              key: const Key('SwitchToGuardianPassword'),
              controller: passwordCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                icon: Icon(Icons.lock),
                labelText: 'Adgangskode',
              ),
            ),
          ],
        ),
        buttons: <DialogButton>[
          DialogButton(
            key: const Key('SwitchToGuardianSubmit'),
            // Debouncer for button, so it cannot
            // be tapped than each 2 seconds.
            onPressed: _clickable
                ? () {
                    if (_clickable) {
                      _clickable = false;
                      loginFromPopUp(context, userNameCtrl.value.text,
                          passwordCtrl.value.text);
                      // Timer makes it clicable again after 2 seconds.
                      Timer(const Duration(milliseconds: 2000), () {
                        _clickable = true;
                      });
                    }
                  }
                : null,
            child: const Text(
              'Bekræft',
              style: TextStyle(
                  color: theme.GirafColors.white, fontSize: GirafFont.small),
            ),
            color: theme.GirafColors.dialogButton,
          )
        ]);
  }

  IconButton _createIconCopy(VoidCallback callback) {
    return IconButton(
      icon: Image.asset('assets/icons/copy.png'),
      tooltip: 'Kopier',
      onPressed: callback,
    );
  }

  IconButton _createIconDelete(VoidCallback callback) {
    return IconButton(
      icon: Image.asset('assets/icons/delete.png'),
      tooltip: 'Slet',
      onPressed: callback,
    );
  }

  IconButton _createIconEdit(VoidCallback callback) {
    return IconButton(
      icon: Image.asset('assets/icons/edit.png'),
      tooltip: 'Rediger',
      onPressed: callback,
    );
  }

  IconButton _createIconHelp(VoidCallback callback) {
    return IconButton(
      icon: Image.asset('assets/icons/help.png'),
      tooltip: 'Hjælp',
      onPressed: callback,
    );
  }

  IconButton _createIconHome(VoidCallback callback) {
    return IconButton(
      icon: Image.asset('assets/icons/home.png'),
      tooltip: 'Gå til startside',
      onPressed: callback,
    );
  }

  IconButton _createIconLogout(BuildContext? context) {
    return IconButton(
      icon: Image.asset('assets/icons/logout.png'),
      tooltip: 'Log ud',
      onPressed: () {
        showDialog<Center>(
            barrierDismissible: false,
            context: context!,
            builder: (BuildContext context) {
              return GirafConfirmDialog(
                title: 'Log ud',
                description: 'Vil du logge ud?',
                confirmButtonText: 'Log ud',
                confirmButtonIcon:
                    const ImageIcon(AssetImage('assets/icons/logout.png')),
                confirmOnPressed: () {
                  _authBloc.logout();
                  Routes().goHome(context);
                },
                key: UniqueKey(),
              );
            });
      },
    );
  }

  IconButton _createIconProfile(VoidCallback callback) {
    return IconButton(
      icon: Image.asset('assets/icons/profile.png'),
      tooltip: 'Vis profil',
      onPressed: callback,
    );
  }

  IconButton _createIconRedo(VoidCallback callback) {
    return IconButton(
      icon: Image.asset('assets/icons/redo.png'),
      tooltip: 'Gendan',
      onPressed: callback,
    );
  }

  IconButton _createIconSave(VoidCallback callback) {
    return IconButton(
      icon: Image.asset('assets/icons/save.png'),
      tooltip: 'Gem',
      onPressed: callback,
    );
  }

  IconButton _createIconSearch(VoidCallback callback) {
    return IconButton(
      icon: Image.asset('assets/icons/search.png'),
      tooltip: 'Søg',
      onPressed: callback,
    );
  }

  IconButton _createIconSettings(VoidCallback callback) {
    return IconButton(
      icon: Image.asset('assets/icons/settings.png'),
      tooltip: 'Indstillinger',
      onPressed: callback,
    );
  }

  IconButton _createIconUndo(VoidCallback callback) {
    return IconButton(
      icon: Image.asset('assets/icons/undo.png'),
      tooltip: 'Fortryd',
      onPressed: callback,
    );
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
        color: theme.GirafColors.white,
      ),
    ),
    titleStyle: const TextStyle(
      color: theme.GirafColors.black,
    ),
  );

  /// Status of last login attempt from popup
  bool _loginStatus = false;

  /// Indicates if the popup have been popped in this instance of the screen.
  bool _popCalled = false;

  /// Holds the current context
  late BuildContext _currentContext;

  /// Used to authenticate a user from popup.
  void loginFromPopUp(BuildContext context, String username, String password) {
    showLoadingSpinner(context, false, _showFailureDialog, 2000);
    _loginStatus = false;
    _currentContext = context;

    // Skip 1, since we should skip the seeded value.
    _authBloc.loginAttempt.skip(1).listen((bool snapshot) {
      _loginStatus = snapshot;
      if (snapshot && !_popCalled) {
        // Pop the loading spinner
        Routes().pop(context);
        // Pop the pop up.
        Routes().pop(context);
        _popCalled = true;
      }
    });

    _authBloc.authenticateFromPopUp(username, password);
  }

  /// Shows a failure dialog
  void _showFailureDialog() {
    if (!_loginStatus) {
      //Pop the loading spinner.
      Routes().pop(_currentContext);
      showDialog<Center>(
          barrierDismissible: false,
          context: _currentContext,
          builder: (BuildContext context) {
            return const GirafNotifyDialog(
                title: 'Fejl',
                description: 'Forkert adgangskode',
                key: Key('WrongPasswordDialog'));
          });
    }
  }

  @override
  void dispose() {
    _visibleButtons.close();
  }
}
