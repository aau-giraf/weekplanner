import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';


/// Toolbar of the application.
class GirafAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Toolbar of the application.
  GirafAppBar({Key key, this.title, this.appBarIcons})
      : toolbarBloc = di.getDependency<ToolbarBloc>(),
        preferredSize = const Size.fromHeight(56.0),
        super(key: key);

  /// Used to store the title of the toolbar.
  final String title;

  /// Used to store the icons that should be displayed in the appbar.
  final List<AppBarIcon> appBarIcons;

  /// Contains the functionality of the toolbar.
  final ToolbarBloc toolbarBloc;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    toolbarBloc.updateIcons(appBarIcons, context);
    return AppBar(
        title: Text(title),
        backgroundColor: const Color(0xAAFF6600),
        actions: <Widget>[
          StreamBuilder<List<IconButton>>(
              initialData: <IconButton>[],
              key: const Key('streambuilderVisibility'),
              stream: toolbarBloc.visibleButtons,
              builder: (BuildContext context, 
                AsyncSnapshot<List<IconButton>> snapshot) {
                return Row(
                  children: snapshot.data
                );
              }),
        ]);
  }
}
