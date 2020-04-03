import 'package:flutter/material.dart';
import '../style/custom_color.dart' as theme;

/// The GirafDialogHeader is to be used at the title location of widgets
class GirafTitleHeader extends StatelessWidget implements PreferredSizeWidget {
  ///The header takes the title as input, so it is similar for all titles.
  const GirafTitleHeader({Key key, this.title}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  ///title of the header
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Center(
                  child: Text(
                title ?? '',
                textAlign: TextAlign.center,
              )),
            ),
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: <double>[
                  0.33,
                  0.66
                ],
                    colors: <Color>[
                  theme.GirafColors.appBarYellow,
                  theme.GirafColors.appBarOrange,
                ])),
          ),
        ),
      ],
    );
  }
}
