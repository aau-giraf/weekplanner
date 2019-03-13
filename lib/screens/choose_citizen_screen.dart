import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/choose_citizen_bloc.dart';
import 'package:weekplanner/globals.dart';
import 'package:weekplanner/models/username_model.dart';

class ChooseCitizenScreen extends StatelessWidget {
  final ChooseCitizenBloc _bloc = ChooseCitizenBloc(Globals.api);

  @override
  Widget build(BuildContext context) {
    _bloc.load();
    final Size screenSize = MediaQuery
        .of(context)
        .size;

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
        child: Dialog(
          insetAnimationCurve: ElasticInCurve(),
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(40),
              child: AppBar(
                title: Text(
                  "Vælg Borger",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                centerTitle: true,
                titleSpacing: 0,
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
                //elevation: 0,
              ),
            ),
            body: Container(
              child: StreamBuilder<List<UsernameModel>>(
                stream: _bloc.citizen,
                initialData: [],
                builder: (BuildContext context,
                    AsyncSnapshot<List<UsernameModel>> snapshot) {
                  return Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: GridView.count(
                      crossAxisCount: 2,
                      children: snapshot.data
                          .map((UsernameModel user) => citizenEntry(user, context))
                          .toList(),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget chooseCitizenDialog() {

  }

  Widget citizenEntry(UsernameModel user, BuildContext context) {
    return GestureDetector(
      onTap: () {Navigator.pushNamed(context, "/weekplan");},
      child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image:
                        AssetImage("assets/login_screen_background_image.png"),
                      ),
                    ),
                  ),
                ),
              ),
              FittedBox(
                fit: BoxFit.contain,
                child: Padding(
                  padding: const EdgeInsets.all(100),
                  child: Text(
                    user.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 300,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
