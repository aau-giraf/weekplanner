import 'package:flutter/material.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/giraf_title_header.dart';
import '../style/custom_color.dart' as theme;

///A dialog widget presented to the user to confirm an action, such as
///logging out or deleting a weekplan. The dialog consists of a title,
///a description, and two buttons. One button to cancel the action and
///one button to accept and perform the action.
class Giraf3ButtonDialog extends StatelessWidget {
  ///The dialog displays the title and description, with two buttons
  ///to either confirm the action, or cancel, which simply closes the dialog.
  const Giraf3ButtonDialog(
      {Key key,
      @required this.title,
      this.description,
      @required this.option1Text,
      @required this.option1Icon,
      @required this.option1OnPressed,
      @required this.option2Text,
      @required this.option2Icon,
      @required this.option2OnPressed,
      this.cancelOnPressed})
      : super(key: key);

  ///title of the dialogBox, displayed in the header of the dialogBox
  final String title;

  ///description of the dialogBox, displayed under the header, describing the
  ///encountered problem
  final String description;

  ///text for option 1 button
  final String option1Text;

  ///text for option 2 button
  final String option2Text;

  ///icon for option 1
  final ImageIcon option1Icon;

  ///icon for option 2
  final ImageIcon option2Icon;

  ///the method to call when option 1 is pressed
  final VoidCallback option1OnPressed;

  ///the method to call when option 2 is pressed
  final VoidCallback option2OnPressed;

  ///the method is call when the cancel button is pressed. Optional
  final VoidCallback cancelOnPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0.0),
      titlePadding: const EdgeInsets.all(0.0),
      shape:
          Border.all(color: theme.GirafColors.transparentDarkGrey, width: 5.0),
      title: Center(
          child: GirafTitleHeader(
        title: title,
      )),
      content: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Text(
                  //if description is null,
                  // its replaced with empty.
                  description ?? '',
                  textAlign: TextAlign.center,
                ),
                    ))
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                    fit: FlexFit.loose,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GirafButton(
                          key: const Key('Option1Button'),
                          text: option1Text,
                          icon: option1Icon,
                          onPressed: () {
                            option1OnPressed();
                          }),
                    )),
                Flexible(
                    fit: FlexFit.loose,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GirafButton(
                          key: const Key('Option2Button'),
                          text: option2Text,
                          icon: option2Icon,
                          onPressed: () {
                            option2OnPressed();
                          }),
                    ))
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: GirafButton(
                      key: const Key('ConfirmDialogCancelButton'),
                      text: 'Fortryd',
                      icon: const ImageIcon(
                          AssetImage('assets/icons/cancel.png'),
                          color: theme.GirafColors.black),
                      onPressed: () {
                        if (cancelOnPressed != null) {
                          cancelOnPressed();
                        }

                        Routes().pop(context);
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
