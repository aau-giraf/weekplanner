import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';
import 'package:weekplanner/style/custom_color.dart';
import 'package:weekplanner/widgets/giraf_title_header.dart';

/// Toolbar of the application.
class GirafAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Toolbar of the application.
  GirafAppBar({Key key, this.title, this.appBarIcons, this.isGuardian = true})
      : toolbarBloc = di.getDependency<ToolbarBloc>(),
        preferredSize = const Size.fromHeight(56.0),
        super(key: key);

  /// Used to store the title of the toolbar.
  final String title;
  /// Used to decide if there should be a back button on the AppBar
  final bool isGuardian;

  /// Used to store the icons that should be displayed in the appbar.
  final Map<AppBarIcon, VoidCallback> appBarIcons;

  /// Contains the functionality of the toolbar.
  final ToolbarBloc toolbarBloc;
  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    toolbarBloc.updateIcons(appBarIcons, context);
    return AppBar(
      iconTheme: const IconThemeData(
        color: GirafColors.black,
      ),
        title: Text(title, overflow: TextOverflow.clip,
          style: const TextStyle(color: GirafColors.black)),
        flexibleSpace: const GirafTitleHeader(),
        actions: <Widget>[
          StreamBuilder<List<IconButton>>(
              initialData: const <IconButton>[],
              key: const Key('streambuilderVisibility'),
              stream: toolbarBloc.visibleButtons,
              builder: (BuildContext context, 
                AsyncSnapshot<List<IconButton>> snapshot) {
                return Row(
                  children: snapshot.data
                );
              }),
        ],
        automaticallyImplyLeading: isGuardian,
    );
  }
}
