import 'package:flutter/cupertino.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';

/// Class to build CopyDialogButtons
class CopyDialogButtons extends StatelessWidget {
  /// Constructor to get required information
  const CopyDialogButtons({
    Key key,
    @required this.confirmButtonText,
    @required this.confirmButtonIcon,
    @required this.confirmOnPressed,
    @required this.checkMarkValues,
  }) : super(key: key);

  /// Text to be displayed on the confirm button.
  final String confirmButtonText;

  /// Path to the confirm ImageIcon.
  final ImageIcon confirmButtonIcon;

  /// Function to be called when the button is pressed.
  final void Function(List<bool>, BuildContext) confirmOnPressed;

  /// A list containing check mark values
  final List<bool> checkMarkValues;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            fit: FlexFit.loose,
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: GirafButton(
                key: const Key('DialogCancelButton'),
                text: 'Fortryd',
                icon: const ImageIcon(AssetImage('assets/icons/cancel.png')),
                onPressed: () {
                  Routes.pop(context);
                },
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: GirafButton(
                key: const Key('DialogConfirmButton'),
                text: confirmButtonText,
                icon: confirmButtonIcon,
                onPressed: () {
                  confirmOnPressed(checkMarkValues, context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
