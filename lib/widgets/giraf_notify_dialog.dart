import 'package:flutter/material.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/giraf_title_header.dart';

/// An AlertDialog for notifications, with a title and description as input.
/// The only action that the dialog can do is pressing okay, as the
/// dialog is intended to only notify the user.
/// Other dialogs can be seen at: https://github.com/aau-giraf/wiki/blob/master/design_guide/dialog.md
class GirafNotifyDialog extends StatelessWidget implements PreferredSizeWidget {
  ///The dialog displays the title and description, with a button
  ///to conform the notification, which simply closes the dialog.
  const GirafNotifyDialog({Key key, @required this.title, this.description})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  ///title of the dialogBox, displayed in the header of the dialogBox
  final String title;

  ///description of the dialogBox, displayed under the header, describing the
  ///encountered problem
  final String description;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0.0),
      titlePadding: const EdgeInsets.all(0.0),
      shape:
      Border.all(color: const Color.fromRGBO(112, 112, 112, 1), width: 5.0),
      title: Center(
          child: GirafTitleHeader(
            title: title,
          )),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Text(
                      //if description is null, its replaced with empty.
                      description ?? '',
                      textAlign: TextAlign.center,
                    ),
                  ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                    key: const Key('NotifyDialogOkayButton'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(
                            color: Color.fromRGBO(0, 0, 0, 0.3))),
                    color: const Color.fromRGBO(255, 157, 0, 1),
                    child: Row(
                      children: const <Widget>[
                        ImageIcon(
                          AssetImage('assets/icons/accept.png'),
                          color: Color.fromRGBO(0, 0, 0, 1),),
                        Text(
                          'Okay',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    onPressed: () {
                      Routes.pop(context);
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
