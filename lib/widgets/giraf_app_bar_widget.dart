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
        if (appBarIcons != null && appBarIcons!.containsKey(AppBarIcon.accept))
          IconButton(
            tooltip: 'Accepter',
            icon: const Icon(Icons.check),
            onPressed: appBarIcons?[AppBarIcon.accept],
          ),
        if (appBarIcons != null && appBarIcons!.containsKey(AppBarIcon.add))
          IconButton(
            tooltip: 'Tilføj',
            icon: const Icon(Icons.add),
            onPressed: appBarIcons?[AppBarIcon.add],
          ),
        if (appBarIcons != null &&
            appBarIcons!.containsKey(AppBarIcon.addTimer))
          IconButton(
            tooltip: 'Tilføj timer',
            icon: const Icon(Icons.timer),
            onPressed: appBarIcons?[AppBarIcon.addTimer],
          ),
        if (appBarIcons != null && appBarIcons!.containsKey(AppBarIcon.back))
          IconButton(
            tooltip: 'Tilbage',
            icon: const Icon(Icons.arrow_back),
            onPressed: appBarIcons?[AppBarIcon.back],
          ),
        if (appBarIcons != null &&
            appBarIcons!.containsKey(AppBarIcon.burgerMenu))
          IconButton(
            tooltip: 'Åbn menu',
            icon: const Icon(Icons.menu),
            onPressed: appBarIcons?[AppBarIcon.burgerMenu],
          ),
        if (appBarIcons != null && appBarIcons!.containsKey(AppBarIcon.camera))
          IconButton(
            tooltip: 'Åbn kamera',
            icon: const Icon(Icons.camera),
            onPressed: appBarIcons?[AppBarIcon.camera],
          ),
        if (appBarIcons != null && appBarIcons!.containsKey(AppBarIcon.cancel))
          IconButton(
            tooltip: 'Fortryd',
            icon: const Icon(Icons.cancel),
            onPressed: appBarIcons?[AppBarIcon.cancel],
          ),
        if (appBarIcons != null &&
            appBarIcons!.containsKey(AppBarIcon.changeToCitizen))
          IconButton(
            tooltip: 'Skift til borger tilstand',
            icon: const Icon(Icons.person),
            onPressed: appBarIcons?[AppBarIcon.changeToCitizen],
          ),
        if (appBarIcons != null &&
            appBarIcons!.containsKey(AppBarIcon.changeToGuardian))
          IconButton(
            tooltip: 'Skift til værge tilstand',
            icon: const Icon(Icons.people),
            onPressed: appBarIcons?[AppBarIcon.changeToGuardian],
          ),
        if (appBarIcons != null && appBarIcons!.containsKey(AppBarIcon.copy))
          IconButton(
            tooltip: 'Kopier',
            icon: const Icon(Icons.copy),
            onPressed: appBarIcons?[AppBarIcon.copy],
          ),
        if (appBarIcons != null && appBarIcons!.containsKey(AppBarIcon.delete))
          IconButton(
            tooltip: 'Slet',
            icon: const Icon(Icons.delete),
            onPressed: appBarIcons?[AppBarIcon.delete],
          ),
        if (appBarIcons != null && appBarIcons!.containsKey(AppBarIcon.edit))
          IconButton(
            tooltip: 'Rediger',
            icon: const Icon(Icons.edit),
            onPressed: appBarIcons?[AppBarIcon.edit],
          ),
        if (appBarIcons != null && appBarIcons!.containsKey(AppBarIcon.help))
          IconButton(
            tooltip: 'Hjælp',
            icon: const Icon(Icons.help),
            onPressed: appBarIcons?[AppBarIcon.help],
          ),
        if (appBarIcons != null && appBarIcons!.containsKey(AppBarIcon.home))
          IconButton(
            tooltip: 'Gå til startside',
            icon: const Icon(Icons.home),
            onPressed: appBarIcons?[AppBarIcon.home],
          ),
        if (appBarIcons != null && appBarIcons!.containsKey(AppBarIcon.logout))
          IconButton(
            tooltip: 'Log ud',
            icon: const Icon(Icons.logout),
            onPressed: appBarIcons?[AppBarIcon.logout],
          ),
        if (appBarIcons != null && appBarIcons!.containsKey(AppBarIcon.profile))
          IconButton(
            tooltip: 'Vis profil',
            icon: const Icon(Icons.person),
            onPressed: appBarIcons?[AppBarIcon.profile],
          ),
        if (appBarIcons != null && appBarIcons!.containsKey(AppBarIcon.redo))
          IconButton(
            tooltip: 'Gendan',
            icon: const Icon(Icons.restore),
            onPressed: appBarIcons?[AppBarIcon.redo],
          ),
        if (appBarIcons != null && appBarIcons!.containsKey(AppBarIcon.save))
          IconButton(
            tooltip: 'Gem',
            icon: const Icon(Icons.save),
            onPressed: appBarIcons?[AppBarIcon.save],
          ),
        if (appBarIcons != null && appBarIcons!.containsKey(AppBarIcon.search))
          IconButton(
            tooltip: 'Søg',
            icon: const Icon(Icons.search),
            onPressed: appBarIcons?[AppBarIcon.search],
          ),
        if (appBarIcons != null &&
            appBarIcons!.containsKey(AppBarIcon.settings))
          IconButton(
            tooltip: 'Indstillinger',
            icon: const Icon(Icons.settings),
            onPressed: appBarIcons?[AppBarIcon.settings],
          ),
        if (appBarIcons != null && appBarIcons!.containsKey(AppBarIcon.undo))
          IconButton(
            tooltip: 'Fortryd',
            icon: const Icon(Icons.undo),
            onPressed: appBarIcons?[AppBarIcon.undo],
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
