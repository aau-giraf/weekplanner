import 'package:flutter/material.dart';

class GirafAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  GirafAppBar({Key key, this.title}) : preferredSize = Size.fromHeight(56.0), super(key: key);

  @override
  final Size preferredSize;
  // Adding this.variablename to the constructor automatically assigns the value to the right variable.

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: Color(0xAAFF6600),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings),
          tooltip: 'Indstillinger',
          onPressed: () {
            Navigator.pushNamed(context, '/settings');
          },
        ),

        IconButton(
          icon: Icon(Icons.people),
          tooltip: 'trains',

          onPressed: () {

          },
        ),

        IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {

            },
        ),


        IconButton(
          icon: Icon(Icons.edit),
          tooltip: 'trains',
          onPressed: () {

          },
        ),
      ]
    );
  }
}
