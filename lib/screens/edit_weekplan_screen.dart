import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/routes.dart';

class EditWeekPlanState extends State<EditWeekPlanScreen> {

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool portrait = MediaQuery.of(context).orientation == Orientation.portrait;

    ///Used to check if the keyboard is visible
    final bool keyboard = MediaQuery.of(context).viewInsets.bottom > 0;

    //TODO: steal from the screen new_weekplan_screen
    return Scaffold (                   // Add from here...
      body: Text('Hello'),
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list),
                     onPressed: _popEditWeekPlanScreen,
          ),
        ],
      ),
    );

  }

  void _popEditWeekPlanScreen() {
    Routes.pop(context);
    //Routes.push(context, new EditWeekPlanScreen());
  }
}

class EditWeekPlanScreen extends StatefulWidget {

  @override
  EditWeekPlanState createState() => EditWeekPlanState();
}