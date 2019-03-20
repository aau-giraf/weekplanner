import 'package:flutter/material.dart';

class GirafDialogHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  GirafDialogHeader({Key key, this.title})
      : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  final Size preferredSize;

  // Adding this.variablename to the constructor automatically assigns the value to the right variable.

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Center(child: Text(title)),
            ),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [
                  0.33,
                  0.66
                ],
                    colors: [
                  Color.fromRGBO(254, 215, 108, 1),
                  Color.fromRGBO(253, 187, 85, 1),
                ])),
          ),
        ),
      ],
    );
  }
}
