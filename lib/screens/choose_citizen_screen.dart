import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/choose_citizen_bloc.dart';
import 'package:weekplanner/models/username_model.dart';
import 'package:weekplanner/widgets/giraf_app_bar_simple_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/weekplan_screen.dart';

class ChooseCitizenScreen extends StatelessWidget {
  final ChooseCitizenBloc _bloc;
  ChooseCitizenScreen() : _bloc = di.getDependency<ChooseCitizenBloc>();
  @override
  Widget build(BuildContext context) {
    _bloc.load();
    final Size screenSize = MediaQuery.of(context).size;

    bool Portrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/login_screen_background_image.png"),
            fit: BoxFit.cover,
          ),
        ),
        // Creates a new Dialog
        child: Dialog(
          child: Scaffold(
            appBar: GirafAppBarSimple(title: "Vælg Borger"),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: StreamBuilder<List<UsernameModel>>(
                  stream: _bloc.citizen,
                  initialData: [],
                  builder: (BuildContext context,
                      AsyncSnapshot<List<UsernameModel>> snapshot) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 0, horizontal: Portrait ? 20 : 60),
                      child: GridView.count(
                          crossAxisCount: Portrait ? 2 : 4,
                          children: snapshot.data
                              .map((UsernameModel user) =>
                                  citizenEntry(user, context))
                              .toList()),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget chooseCitizenDialog() {}

  Widget citizenEntry(UsernameModel user, BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: GestureDetector(
        onTap: () {
          Routes.push(context, WeekplanScreen());
        },
        child: Container(
            child: Column(
          children: <Widget>[
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          child: CircleAvatar(
                            radius: 20,
                            //TODO: Rigtige profil billeder
                            backgroundImage: AssetImage(
                                "assets/login_screen_background_image.png"),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: AutoSizeText(
                        user.name,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
