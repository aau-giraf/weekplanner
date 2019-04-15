import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';

/// Contains the functionality of the toolbar.
class ToolbarBloc extends BlocBase {
  /// The current visibility of the edit-button.
  Stream<List<IconButton>> get visibleButtons => _visibleButtons.stream;

  final BehaviorSubject<List<IconButton>> _visibleButtons =
      BehaviorSubject<List<IconButton>>.seeded(<IconButton>[]);

  //// Based on a list of the enum AppBarIcon this method populates a list of IconButtons to render in the nav-bar
  void updateIcons(List<AppBarIcon> icons) {
  List<IconButton> _iconsToAdd = <IconButton>[];
    for (AppBarIcon icon in icons) {
      _iconsToAdd.add(IconButton(
          // icon: Image.asset('assets/icons/settings.png'), onPressed: () {}));
          icon: _addSettingsToImage(icon.toString()), onPressed: () {}));
    }
    _visibleButtons.add(_iconsToAdd);
  }
  /// Find the icon picture based on the input string
  Image _addSettingsToImage(String input) {
    // Removing start of the string that describes the enum type
    input = input.substring(11);
    final String path = 'assets/icons/'+ input +'.png';
    return Image.asset(path);
  }

  void _addSwitchToGuardian() {
    
  }

  @override
  void dispose() {
    _visibleButtons.close();
  }
}
