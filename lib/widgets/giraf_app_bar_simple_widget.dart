import 'package:flutter/material.dart';

class GirafAppBarSimple extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  GirafAppBarSimple({Key key, this.title}) : preferredSize = Size.fromHeight(56.0), super(key: key);

  @override
  final Size preferredSize;
  // Adding this.variablename to the constructor automatically assigns the value to the right variable.

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: Color(0xAAFF6600),
    );
  }
}
