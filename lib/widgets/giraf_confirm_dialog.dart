import 'package:flutter/material.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/giraf_title_header.dart';
import '../style/custom_color.dart' as theme;

///A dialog widget presented to the user to confirm an action, such as
///logging out or deleting a weekplan. The dialog consists of a title,
///a description, and two buttons. One button to cancel the action and
///one button to accept and perform the action.
class GirafConfirmDialog extends StatelessWidget {
  ///The dialog displays the title and description, with two buttons
  ///to either confirm the action, or cancel, which simply closes the dialog.
  const GirafConfirmDialog(
      {Key key,
      required this.title,
      this.description,
      this.descriptionRichText,
      this.inputField,
      required this.confirmButtonText,
      required this.confirmButtonIcon,
      required this.confirmOnPressed,
      this.cancelOnPressed})
      : super(key: key);

  ///title of the dialogBox, displayed in the header of the dialogBox
  final String title;

  ///description of the dialogBox, displayed under the header, describing the
  ///encountered problem
  final String description;

  ///description of the dialogBox, displayed under the header, describing the
  ///encountered problem
  ///this version allows for formatting, such as text styling
  final RichText descriptionRichText;

  ///text field for optional input
  final TextField inputField;

  ///text on the confirm button, describing the confirmed action
  final String confirmButtonText;

  ///icon on the confirm button, visualizing the confirmed action
  final ImageIcon confirmButtonIcon;

  ///the method to call when the confirmation button is pressed
  final VoidCallback confirmOnPressed;

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
                      child: descriptionRichText // ??
                      // Text(
                      //   description ?? '',
                      //   textAlign: TextAlign.center,
                      // ),
                      )),
            ],
          ),
          //if an inputfield is provided, display it
          inputField != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                      Expanded(
                          child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: inputField))
                    ])
              : Container(),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5),
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
                ),
                Flexible(
                    fit: FlexFit.loose,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: GirafButton(
                            key: const Key('ConfirmDialogConfirmButton'),
                            text: confirmButtonText,
                            icon: confirmButtonIcon,
                            onPressed: () {
                              confirmOnPressed();
                            })))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
