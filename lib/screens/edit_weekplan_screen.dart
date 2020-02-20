import 'package:flutter/cupertino.dart';

class EditWeekPlanScreen extends StatefulWidget {

  @override
  EditWeekPlanState createState() => EditWeekPlanState();

}

class EditWeekPlanState extends State<EditWeekPlanScreen> {

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool portrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    ///Used to check if the keyboard is visible
    final bool keyboard = MediaQuery.of(context).viewInsets.bottom > 0;

  }
}