import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/choose_citizen_bloc.dart';
import 'package:weekplanner/models/username_model.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/weekplan_screen.dart';
import 'package:weekplanner/widgets/citizen_avatar_widget.dart';
import 'package:weekplanner/widgets/giraf_app_bar_simple_widget.dart';
import 'package:weekplanner/di.dart';

class ChooseCitizenScreen extends StatelessWidget {
  final ChooseCitizenBloc _bloc = di.getDependency<ChooseCitizenBloc>();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    final bool portrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/login_screen_background_image.png'),
            fit: BoxFit.cover,
          ),
        ),
        // Creates a new Dialog
        child: Dialog(
          child: Scaffold(
            appBar: const GirafAppBarSimple(title: 'Vælg Borger'),
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
                            children: snapshot.data
                                .map<Widget>((UsernameModel user) =>
                                    CitizenAvatar(
                                        usernameModel: user,
                                        onPressed: () => Routes.push(
                                            context, WeekplanScreen())))
                                .toList()),
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
}
