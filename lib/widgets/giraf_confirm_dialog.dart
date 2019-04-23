import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/giraf_title_header.dart';

///A dialog widget presented to the user to confirm an action, such as
///logging out or deleting a weekplan. The dialog consists of a title,
///a description, and two buttons. One button to cancel the action and
///one button to accept and perform the action.
class GirafConfirmDialog extends StatelessWidget {
  ///The dialog displays the title and description, with two buttons
  ///to either confirm the action, or cancel, which simply closes the dialog.
  const GirafConfirmDialog(
      {Key key,
      @required this.title,
      this.description,
      @required this.confirmButtonText,
      @required this.confirmButtonIcon,
      @required this.confirmOnPressed})
      : super(key: key);

  ///title of the dialogBox, displayed in the header of the dialogBox
  final String title;

  ///description of the dialogBox, displayed under the header, describing the
  ///encountered problem
  final String description;

  ///text on the confirm button, describing the confirmed action
  final String confirmButtonText;

  ///icon on the confirm button, visualizing the confirmed action
  final ImageIcon confirmButtonIcon;

  ///the method to call when the confirmation button is pressed
  final VoidCallback confirmOnPressed;

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
              mainAxisSize: MainAxisSize.min,
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                    key: const Key('ConfirmDialogCancelButton'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(
                            color: Color.fromRGBO(0, 0, 0, 0.3))),
                    color: const Color.fromRGBO(255, 157, 0, 1),
                    child: Row(
                      children: const <Widget>[
                        ImageIcon(
                          AssetImage('assets/icons/cancel.png'),
                          color: Color.fromRGBO(0, 0, 0, 1),
                        ),
                        Text(
                          'Fortryd',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    onPressed: () {
                      Routes.pop(context);
                    }),
                RaisedButton(
                    key: const Key('ConfirmDialogConfirmButton'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(
                            color: Color.fromRGBO(0, 0, 0, 0.3))),
                    color: const Color.fromRGBO(255, 157, 0, 1),
                    child: Center(
                      child: Row(
                        children: <Widget>[
                          confirmButtonIcon,
                          Container(
                            child: AutoSizeText(
                              confirmButtonText,
                              style: const TextStyle(color: Colors.white),
                              maxLines: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () {
                      confirmOnPressed();
                    })
              ],
            ),
          )
        ],
      ),
    );
  }
}
