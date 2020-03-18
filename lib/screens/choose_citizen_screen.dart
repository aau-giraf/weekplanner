import 'package:api_client/models/username_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/choose_citizen_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/new_citizen_screen.dart';
import 'package:weekplanner/screens/weekplan_selector_screen.dart';
import 'package:weekplanner/widgets/citizen_avatar_widget.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

/// The screen to choose a citizen
class ChooseCitizenScreen extends StatelessWidget {
  final ChooseCitizenBloc _bloc = di.getDependency<ChooseCitizenBloc>();
  final AutoSizeGroup _selectionAutoSizeGroup = AutoSizeGroup();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

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
              appBarIcons: const <AppBarIcon, VoidCallback>{
                AppBarIcon.logout: null
              },
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: StreamBuilder<List<UsernameModel>>(
                  stream: _bloc.citizen,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<UsernameModel>> snapshot) {
                    if (snapshot.connectionState != ConnectionState.waiting) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 20,
                        ),
                        child: GridView.count(
                            crossAxisCount: portrait ? 2 : 4,
                            children: _buildCitizenSelectionList(context,
                                snapshot)
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
      ),
    );
  }

  /// Builds the list of citizens together with the "add citizen" button
  /// TODO: Write tests for this method
  List<Widget> _buildCitizenSelectionList(BuildContext context,
    AsyncSnapshot<List<UsernameModel>> snapshot) {
    final List<Widget> list = snapshot.data
        .map<Widget>((UsernameModel user) =>
        CitizenAvatar(
            usernameModel: user,
            onPressed:  () => Routes.push(context,
                WeekplanSelectorScreen(user)))).toList();

    list.insert(0, FlatButton(
      onPressed: () { Routes.push(context, NewCitizenScreen());},
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          children: <Widget>[
            Expanded(
              child: LayoutBuilder(builder:
              (BuildContext context, BoxConstraints constraints) {
                return Icon(
                    Icons.person_add,
                    size: constraints.biggest.height
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
                child: Center(
                  child: AutoSizeText(
                    'Tilføj Borger',
                    style: const TextStyle(fontSize: 30),
                    group: _selectionAutoSizeGroup,
                  ),
                )
            )
          ],
        ),
      ),
    )
    );
    return list;
  }
}
