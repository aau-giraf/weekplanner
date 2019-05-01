import 'package:flutter/material.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/giraf_title_header.dart';

///A dialog widget presented to the user to confirm an action based on
///a dropdown menu presented in the dialog. The dialog consists of a title,
///a description, and two buttons and a dropdown menu. One button to cancel
///the action and one button to accept and perform the action.
class GirafDropdownDialog<T> extends StatelessWidget {
  ///The dialog displays the title and description, with two buttons and a
  ///dropdown menu
  const GirafDropdownDialog(
      {Key key,
        @required this.title,
        this.description,
        @required this.confirmButtonText,
        @required this.confirmButtonIcon,
        @required this.confirmOnPressed,
        @required this.items})
      : super(key: key);

  ///title of the dialogBox, displayed in the header of the dialogBox
  final String title;

  ///description of the dialogBox, displayed under the header, describing the
  ///encountered problem
  final String description;

  /// The items in the dropdown list
  final List<DropdownMenuItem<T>> items;

  ///text on the confirm button, describing the confirmed action
  final String confirmButtonText;

  ///icon on the confirm button, visualizing the confirmed action
  final ImageIcon confirmButtonIcon;

  ///the method to call when the confirmation button is pressed
  final Function(T) confirmOnPressed;

  @override
  Widget build(BuildContext context) {
    T _selectedMenuPoint;
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              DropdownButton<T>(
                items: items,
                onChanged: (T value) {_selectedMenuPoint = value;},
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: RaisedButton(
                        key: const Key('ConfirmDialogCancelButton'),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(
                                color: Color.fromRGBO(0, 0, 0, 0.3))),
                        color: const Color.fromRGBO(255, 157, 0, 1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                    ),
                  ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: RaisedButton(
                        key: const Key('ConfirmDialogConfirmButton'),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(
                                color: Color.fromRGBO(0, 0, 0, 0.3))),
                        color: const Color.fromRGBO(255, 157, 0, 1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            confirmButtonIcon,
                            Flexible(
                              fit: FlexFit.tight,
                              child: Text(
                                confirmButtonText,
                                style: const TextStyle(color: Colors.white),
                                ),
                              ),
                          ],
                          ),
                        onPressed: () {
                          confirmOnPressed(_selectedMenuPoint);
                        }),
                    ),
                  ),
              ],
              ),
            )
        ],
        ),
      );
  }
}
