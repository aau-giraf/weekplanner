import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/settings_screen.dart';

/// Toolbar of the application.
class GirafAppBar extends StatelessWidget implements PreferredSizeWidget {

  /// Toolbar of the application.
  GirafAppBar({Key key, this.title})
      : authBloc = di.getDependency<AuthBloc>(),
        toolbarBloc = di.getDependency<ToolbarBloc>(),
        preferredSize = const Size.fromHeight(56.0),
        super(key: key);

  /// Used to store the title of the toolbar.
  final String title;

  /// Contains the functionality regarding login, logout etc.
  final AuthBloc authBloc;

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
          icon: const Icon(Icons.people),
          tooltip: 'Skift mode',

          onPressed: () {
            // Implemented in another user story
          },
        ),

        IconButton(
          icon: const Icon(Icons.settings),
          tooltip: 'Indstillinger',
          onPressed: () {
            Routes.push(context, SettingsScreen());
          },
        ),
      ]
    );
  }
}
