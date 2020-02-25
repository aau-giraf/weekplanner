import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

class EditWeekPlanState extends State<EditWeekPlanScreen> {



  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool portrait = MediaQuery.of(context).orientation == Orientation.portrait;

    ///Used to check if the keyboard is visible
    final bool keyboard = MediaQuery.of(context).viewInsets.bottom > 0;

    //TODO: steal from the screen new_weekplan_screen
    return Scaffold (                   // Add from here...,
      appBar: GirafAppBar(title: 'Rediger ugeplan'),
      body: ListView(children: <Widget>[
          Text('TEST'),
      ],)
    );

  }

  void _popEditWeekPlanScreen() {
    Routes.pop(context);
  }
}

class EditWeekPlanScreen extends StatefulWidget {

  @override
  EditWeekPlanState createState() => EditWeekPlanState();
}