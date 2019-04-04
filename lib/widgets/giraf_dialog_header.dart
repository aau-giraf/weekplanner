import 'package:flutter/material.dart';

class GirafDialogHeader extends StatelessWidget implements PreferredSizeWidget {
  const GirafDialogHeader({Key key, this.title}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
  final String title;

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
                gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: <double>[
                  0.33,
                  0.66
                ],
                    colors: <Color>[
                  Color.fromRGBO(254, 215, 108, 1),
                  Color.fromRGBO(253, 187, 85, 1),
                ])),
          ),
        ),
      ],
    );
  }
}
