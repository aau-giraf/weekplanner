import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/choose_citizen_bloc.dart';
import 'package:weekplanner/globals.dart';
import 'package:weekplanner/models/username_model.dart';
import 'package:weekplanner/widgets/giraf_app_bar_simple_widget.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

class ChooseCitizenScreen extends StatelessWidget {
  final ChooseCitizenBloc _bloc = ChooseCitizenBloc(Globals.api);

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
        child: Dialog(
          child: Scaffold(
            appBar: GirafAppBarSimple(title: "Vælg Borger"),
            body: Container(
              child: StreamBuilder<List<UsernameModel>>(
                stream: _bloc.citizen,
                initialData: [],
                builder: (BuildContext context,
                    AsyncSnapshot<List<UsernameModel>> snapshot) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 20, horizontal: Portrait ? 20 : 60),
                    child: GridView.count(
                      crossAxisCount: Portrait ? 2 : 4,
                      children: snapshot.data
                          .map((UsernameModel user) =>
                              citizenEntry(user, context))
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

  Widget chooseCitizenDialog() {}

  Widget citizenEntry(UsernameModel user, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/weekplan");
      },
      child: Container(
          child: Column(
        children: <Widget>[
          Expanded(
            child: AspectRatio(
                aspectRatio: 1,
                child: CircleAvatar(
                  radius: 20,
                  //TODO: Rigtige profil billeder
                  backgroundImage:
                      AssetImage("assets/login_screen_background_image.png"),
                )),
          ),
          Text(
            user.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      )),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  final String title;
  final double barHeight = 50.0; // change this for different heights

  CustomAppBar(this.title);

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight = MediaQuery.of(context).padding.top;

    return new Container(
      padding: new EdgeInsets.only(top: statusbarHeight),
      height: statusbarHeight + barHeight,
      child: Container(
        color: Color.fromRGBO(248, 248, 247, 1),
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Color.fromRGBO(228, 224, 224, 1)))),
          child: Column(children: <Widget>[
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Globals.authBloc.logout();
                    //Navigator.pushNamed(context, "/login");
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
                    child: Text(
                      "Log ud",
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      title,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
                  child: Text(
                    "Logud",
                    style: TextStyle(
                        color: Color.fromRGBO(248, 248, 247, 1), fontSize: 20),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
