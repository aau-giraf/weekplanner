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

  //// I am a documentation proud and pretty
  void updateIcons(List<AppBarIcon> icons) {
  List<IconButton> _iconsToAdd = <IconButton>[];
    for (AppBarIcon icon in icons) {
      _iconsToAdd.add(IconButton(
          icon: Image.asset('assets/icons/settings.png'), onPressed: () {}));
    }
    _visibleButtons.add(_iconsToAdd);
  }

  @override
  void dispose() {
    _visibleButtons.close();
  }
}
