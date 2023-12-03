import 'dart:async';

import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/choose_citizen_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/new_citizen_screen.dart';
import 'package:weekplanner/screens/settings_screens/user_settings_screen.dart';
import 'package:weekplanner/screens/weekplan_selector_screen.dart';
import 'package:weekplanner/style/font_size.dart';
import 'package:weekplanner/widgets/citizen_avatar_widget.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_drawer.dart';
import 'package:weekplanner/widgets/input_fields_weekplan.dart';
import 'package:weekplanner/widgets/navigation_menu.dart';

/// The screen to choose a citizen
class ChooseCitizenScreen extends StatefulWidget {
  @override
  _ChooseCitizenScreenState createState() => _ChooseCitizenScreenState();

  ///Variable representing the screen height
  dynamic screenHeight;

  ///Variable representing the screen width
  dynamic screenWidth;
}

class _ChooseCitizenScreenState extends State<ChooseCitizenScreen> {
  final ChooseCitizenBloc _bloc = di.get<ChooseCitizenBloc>();
  final AuthBloc _authBloc = di.get<AuthBloc>();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool portrait = MediaQuery.of(context).orientation == Orientation.portrait;

    widget.screenHeight = MediaQuery.of(context).size.height;
    widget.screenWidth = MediaQuery.of(context).size.width;


    /// screen background
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            /// The blue left part of screen
            Expanded(
              flex: 1,
              child: InputNavigationMenu(),
            ),
            /// The white middle of the screen
            Expanded(
              flex: 7,
              child: Container(
                width: screenSize.width,
                height: screenSize.height,
                padding: portrait
                    ? const EdgeInsets.fromLTRB(0, 0, 0, 0)
                    : const EdgeInsets.fromLTRB(0, 20, 0,0),
                child: Stack(children: <Widget>[
                  Row(children: <Widget>[
                    Container(
                      padding: portrait
                          ? const EdgeInsets.fromLTRB(0, 0, 0, 0)
                          : const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Vælg bruger',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: GirafFont.headline, fontFamily: 'Quicksand-Bold'),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(widget.screenHeight * 0.78, 0, 0, 0),
                      child: Column(children: <Widget>[
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            key: const Key('EditUser'),
                            padding: portrait
                                ? const EdgeInsets.fromLTRB(0, 0, 0, 0)
                                : const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            color: Colors.black,
                            icon: const Icon(Icons.delete, size: 50),
                            onPressed: () {
                              ///_pushEditWeekPlan(context); //Does not work yet
                            },
                          ),
                        ),
                      ],
                      ),
                    ),
                  ],
                  ),
                  Container(
                    padding: portrait
                        ? const EdgeInsets.fromLTRB(0, 0, 0, 0)
                        : const EdgeInsets.fromLTRB(0, 70, 0, 0),
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
                                children:
                                _buildCitizenSelectionList(context, snapshot)),
                          );
                        } else {
                          return Container(
                            child: const Text('Loading...'),
                          );
                        }
                      },
                    ),
                  ),
                ],
                ),
              ),
            ),
            /// The blue right part of screen
            Expanded(
                flex: 1,
                child: Container(
                  height: screenSize.height,
                  child: Image.asset(
                    'assets/icons/giraf_blue_long.png',
                    repeat: ImageRepeat.repeat,
                    fit: BoxFit.cover,
                  ),
                )
            ),
          ]
      ),
      drawer: GirafDrawer(),
    );
  }



  @override
  Widget build2(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
//_api.user.getUserByName("Guardian-dev")
    final bool portrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/login_screen_background_image.png'),
            fit: BoxFit.cover,
          ),
        ),
        // Creates a new Dialog
        child: Dialog(
          child: Scaffold(
            appBar: GirafAppBar(
              title: 'Vælg borger',
              appBarIcons: <AppBarIcon, VoidCallback>{
                AppBarIcon.logout: null,
                AppBarIcon.settings: () =>
                    Routes().push(context, UserSettingsScreen())
              },
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
                            children:
                                _buildCitizenSelectionList(context, snapshot)),
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
      ),
    );
  }

  Future<void> _pushWeekplanSelector(DisplayNameModel user) async {
    bool repush = true;
    while (repush) {
      final bool result =
          await Routes().push<bool>(context, WeekplanSelectorScreen(user));
      repush = result ?? false;
    }
    return;
  }

  /// Builds the list of citizens together with the "add citizen" button
  List<Widget> _buildCitizenSelectionList(
      BuildContext context, AsyncSnapshot<List<DisplayNameModel>> snapshot) {
    final List<Widget> list = snapshot.data
        .map<Widget>((DisplayNameModel user) => CitizenAvatar(
              displaynameModel: user,
     onPressed: () async {
             await Routes().push(context,
                 WeekplanSelectorScreen(user));
             _bloc.updateBloc();
           })).toList();

    /// Defines variables needed to check user role
    final Role role = _authBloc.loggedInUser.role;

    if (role != null) {
      /// Checks user role and gives option to add Citizen if user is Guardian
      if (role == Role.Guardian) {
        list.insert(0, TextButton(
          onPressed: () async {
            final Object result =
            await Routes().push(context, NewCitizenScreen());
            final DisplayNameModel newUser =
            DisplayNameModel.fromGirafUser(result);
            list.add(CitizenAvatar(
                displaynameModel: newUser,
                onPressed: () => _pushWeekplanSelector(newUser)
            )
            );
            ///Update the screen with the new citizen
            _bloc.updateBloc();
            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
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
                          style: TextStyle(fontSize: GirafFont.large,
                              color: Colors.black)
                      ),
                    )
                )
              ],
            ),
          ),
        ));
      }
    }
    return list;
  }
}