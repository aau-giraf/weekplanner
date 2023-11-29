// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';
import 'package:weekplanner/style/custom_color.dart';
import 'package:weekplanner/widgets/giraf_title_header.dart';

class GirafAppBar extends StatelessWidget implements PreferredSizeWidget {
  GirafAppBar({Key? key, this.title, this.appBarIcons, this.leading,})
      : toolbarBloc = di.get<ToolbarBloc>(),
        preferredSize = const Size.fromHeight(56.0),
        super(key: key);

  final String? title;
  final Map<AppBarIcon, VoidCallback>? appBarIcons;
  final ToolbarBloc toolbarBloc;

  @override
  final Size preferredSize;
  final Widget? leading; // Define a leading widget
  @override
  Widget build(BuildContext context) {
    toolbarBloc.updateIcons(appBarIcons, context);

    return AppBar(
      iconTheme: const IconThemeData(
        color: GirafColors.black,
      ),
      title: Text(title ?? '',
          overflow: TextOverflow.clip,
          style: const TextStyle(color: GirafColors.black)),
      leading: leading, // set the leading widget
      flexibleSpace: const GirafTitleHeader(),
      actions: <Widget>[
        StreamBuilder<List<IconButton>>(
            initialData: const <IconButton>[],
            key: const Key('streambuilderVisibility'),
            stream: toolbarBloc.visibleButtons,
            builder: (BuildContext context,
                AsyncSnapshot<List<IconButton>> snapshot) {
              return Row(children: snapshot.data!);
            }),
      ],
    );
  }
}
