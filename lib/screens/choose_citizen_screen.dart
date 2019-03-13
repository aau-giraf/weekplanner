import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/choose_citizen_bloc.dart';
import 'package:weekplanner/globals.dart';
import 'package:weekplanner/models/username_model.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

class ChooseCitizenScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

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
        child: chooseCitizenDialog(),
      ),
    );
  }

  Widget chooseCitizenDialog() {
    final ChooseCitizenBloc _bloc = ChooseCitizenBloc(Globals.api);
    _bloc.load();

    return Dialog(
      insetAnimationCurve: ElasticInCurve(),

      child: Scaffold(
        appBar: AppBar(
          title: Text("Vælg Borger"),
          centerTitle: true,
          titleSpacing: 0,
          backgroundColor: Colors.orange,
          //elevation: 0,
        ),
        body: Container(
          child: StreamBuilder<List<UsernameModel>>(
            stream: _bloc.citizen,
            initialData: [],
            builder: (BuildContext context,
                AsyncSnapshot<List<UsernameModel>> snapshot) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: GridView.count(
                  crossAxisCount: 2,
                  children: snapshot.data.map(
                    (UsernameModel user) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: GestureDetector(
                          onTap: _bloc.choose,
                          child: Container(
                              child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage("assets/login_screen_background_image.png"),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                TrimString(user.name),
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                        ),
                      );
                    },
                  ).toList(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }


  // Trims strings with >= 7 chars
  String TrimString(String Input) {
    if (Input.length >= 7) {
      return Input.substring(0,7)+"...";
    }
    return Input;
  }

}

