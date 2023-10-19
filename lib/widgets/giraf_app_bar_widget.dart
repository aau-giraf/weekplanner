import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';
import 'package:weekplanner/style/custom_color.dart';
import 'package:weekplanner/widgets/giraf_title_header.dart';

class GirafAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Map<AppBarIcon, VoidCallback>? appBarIcons;
  final ToolbarBloc toolbarBloc;

  GirafAppBar({Key? key, this.title, this.appBarIcons})
      : toolbarBloc = di.get<ToolbarBloc>(),
        preferredSize = const Size.fromHeight(56.0),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    final acceptButton = AppBarIcon.accept;
    toolbarBloc.updateIcons(appBarIcons, context);

    return AppBar(
      iconTheme: const IconThemeData(
        color: GirafColors.black,
      ),
      title: Text(title ?? '',
          overflow: TextOverflow.clip,
          style: const TextStyle(color: GirafColors.black)),
      flexibleSpace: const GirafTitleHeader(),
      actions: <Widget>[
        if (appBarIcons != null && appBarIcons!.containsKey(acceptButton))
          IconButton(
            tooltip: 'Accepter',
            icon: const Icon(Icons.check),
            onPressed: appBarIcons?[acceptButton],
          ),
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
