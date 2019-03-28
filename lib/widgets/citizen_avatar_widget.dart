import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/models/username_model.dart';
import 'package:weekplanner/screens/weekplan_screen.dart';

class CitizenAvatar extends StatelessWidget {
  BuildContext parentContext;
  UsernameModel usernameModel;

  CitizenAvatar(this.usernameModel, this.parentContext);

  @override
  Widget build(BuildContext context) {
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
                        usernameModel.name,
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
