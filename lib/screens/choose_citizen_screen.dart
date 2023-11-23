// ignore_for_file: always_specify_types, lines_longer_than_80_chars, duplicate_ignore

import 'dart:async';

import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/choose_citizen_bloc.dart';
import 'package:weekplanner/di.dart';
//import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';
//import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/new_citizen_screen.dart';
//import 'package:weekplanner/screens/settings_screens/user_settings_screen.dart';
import 'package:weekplanner/screens/weekplan_selector_screen.dart';
import 'package:weekplanner/style/font_size.dart';
import 'package:weekplanner/widgets/citizen_avatar_widget.dart';
//import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

/// The screen to choose a citizen
class ChooseCitizenScreen extends StatefulWidget {
  @override
  _ChooseCitizenScreenState createState() => _ChooseCitizenScreenState();
}

class _ChooseCitizenScreenState extends State<ChooseCitizenScreen> {
  final ChooseCitizenBloc _bloc = di.get<ChooseCitizenBloc>();
  final AuthBloc _authBloc = di.get<AuthBloc>();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool portrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              child: Stack(
                children: <Widget>[
                  Image.asset(
                    'assets/icons/giraf_blue_long.png',
                    repeat: ImageRepeat.repeat,
                    height: screenSize.height,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    padding: const EdgeInsets.all(50.0),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Builder(
                            builder: (BuildContext context) {
                              return IconButton(
                                key: const Key('NavigationMenu'),
                                padding: const EdgeInsets.all(0.0),
                                color: Colors.white,
                                icon: const Icon(Icons.menu, size: 55),
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),


          Expanded(
            flex: 7,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text(
                  'Title',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 50.0,
                  ),
                ),
                centerTitle: false,
                automaticallyImplyLeading: false,
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: StreamBuilder<List<DisplayNameModel>>(
                    stream: _bloc.citizen,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<DisplayNameModel>> snapshot) {
                      if (snapshot.connectionState != ConnectionState.waiting) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 20,
                          ),
                          child: GridView.count(
                            crossAxisCount: portrait ? 2 : 4,
                            children: _buildCitizenSelectionList(
                                context, snapshot),
                          ),
                        );
                      } else {
                        return Container(
                          child: const Text('Loading...'),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: screenSize.height,
              child: Image.asset(
                'assets/icons/giraf_blue_long.png',
                repeat: ImageRepeat.repeat,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Ugeplaner'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profil');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Skift bruger'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/skift bruger');
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Log af'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/log af');
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pushWeekplanSelector(DisplayNameModel user) async {
    bool repush = true;
    while (repush) {
      final bool result = await Navigator.push<bool>(
        context,
        // ignore: always_specify_types
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (BuildContext context) => WeekplanSelectorScreen(user),
        ),
      );
      repush = result ?? false;
    }
    return;
  }

  List<Widget> _buildCitizenSelectionList(
      BuildContext context, AsyncSnapshot<List<DisplayNameModel>> snapshot) {
    final List<Widget> list = snapshot.data
        .map<Widget>((DisplayNameModel user) => CitizenAvatar(
      displaynameModel: user,
      onPressed: () async {
        await _pushWeekplanSelector(user);
        _bloc.updateBloc();
      },
    ))
        .toList();

    final Role role = _authBloc.loggedInUser.role;

    if (role != null) {
      if (role == Role.Guardian) {
        list.insert(
          0,
          TextButton(
            onPressed: () async {
              final Object result =
              await Navigator.push(context, MaterialPageRoute(
                fullscreenDialog: true, // Set this to true for full-screen dialog
                builder: (BuildContext context) => NewCitizenScreen(),
              ));
              final DisplayNameModel newUser =
              DisplayNameModel.fromGirafUser(result);
              list.add(
                CitizenAvatar(
                  displaynameModel: newUser,
                  onPressed: () => _pushWeekplanSelector(newUser),
                ),
              );
              _bloc.updateBloc();
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          return Icon(
                            Icons.person_add,
                            size: constraints.biggest.height,
                            color: Colors.black,
                          );
                        }),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 200.0,
                      maxWidth: 200.0,
                      minHeight: 15.0,
                      maxHeight: 50.0,
                    ),
                    child: const Center(
                      child: AutoSizeText(
                        'Tilføj Bruger',
                        style: TextStyle(
                          fontSize: GirafFont.large,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
    }
    return list;
  }
}