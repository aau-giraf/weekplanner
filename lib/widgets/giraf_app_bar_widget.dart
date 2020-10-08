import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';
import 'package:weekplanner/widgets/giraf_title_header.dart';

/// Toolbar of the application.
class GirafAppBar extends StatefulWidget implements PreferredSizeWidget {
  /// Toolbar of the application.
  GirafAppBar(
      {Key key,
      this.title,
      this.appBarIcons,
      this.isGuardian = true,
      this.bottom})
      : toolbarBloc = di.getDependency<ToolbarBloc>(),
        preferredSize = const Size.fromHeight(53.0),
        super(key: key);

  /// Used to store the title of the toolbar.
  final String title;

  /// Used to decide if there should be a back button on the AppBar
  final bool isGuardian;

  /// Used to store the icons that should be displayed in the appbar.
  final Map<AppBarIcon, VoidCallback> appBarIcons;

  /// This widget appears across the bottom of the app bar.
  final PreferredSizeWidget bottom;

  /// Contains the functionality of the toolbar.
  final ToolbarBloc toolbarBloc;
  @override
  final Size preferredSize;

  @override
  _GirafAppBarState createState() => _GirafAppBarState();
}

class _GirafAppBarState extends State<GirafAppBar> {
  @override
  Widget build(BuildContext context) {
    widget.toolbarBloc.updateIcons(widget.appBarIcons, context);
    return AppBar(
      title: Text(widget.title, overflow: TextOverflow.clip),
      flexibleSpace: const GirafTitleHeader(),
      actions: <Widget>[
        StreamBuilder<List<IconButton>>(
            initialData: const <IconButton>[],
            key: const Key('streambuilderVisibility'),
            stream: widget.toolbarBloc.visibleButtons,
            builder: (BuildContext context,
                AsyncSnapshot<List<IconButton>> snapshot) {
              return Row(children: snapshot.data);
            }),
      ],
      automaticallyImplyLeading: widget.isGuardian,
      bottom: widget.bottom,
    );
  }
}
