import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/di.dart';

/// The Default AppBar for every screen
class GirafAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Default constructor.
  ///
  /// Takes a [title] which will be displayed at the left hand side of the bar
  GirafAppBar({Key key, this.title})
      : _authBloc = di.getDependency<AuthBloc>(),
        preferredSize = const Size.fromHeight(56.0),
        super(key: key);

  /// Title of the Screen
  final String title;
  final AuthBloc _authBloc;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(title),
        backgroundColor: const Color(0xAAFF6600),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Indstillinger',
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          IconButton(
            icon: const Icon(Icons.subdirectory_arrow_right),
            tooltip: 'trains',
            onPressed: () {
              _authBloc.logout();
            },
          ),
          IconButton(
            icon: const Icon(Icons.place),
            tooltip: 'trains',
            onPressed: () {},
          )
        ]);
  }
}
