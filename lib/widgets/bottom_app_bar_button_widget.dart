import 'package:flutter/cupertino.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';

/// Creates a button in the ButtomAppBar.
class BottomAppBarButton extends StatelessWidget {
  
  /// Constrtuctor to get required information.
  const BottomAppBarButton({
    Key key,
    @required this.context,
    @required this.buttonText,
    @required this.buttonKey,
    @required this.assetPath,
    @required this.dialogFunction,
  }) : super(key: key);

  ///
  final BuildContext context;

  /// Text to be dispayed on the button.
  final String buttonText;
  
  /// Key to identify the button when testing. 
  final String buttonKey;

  /// Path to the ImageIcon.
  final String assetPath;

  /// Function to handle when the button is pressed. 
  final Function dialogFunction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: GirafButton(
        text: buttonText,
        key: Key(buttonKey),
        icon: ImageIcon(AssetImage(assetPath)),
        onPressed: () {
          dialogFunction(context);
        },
      ),
    );
  }
}
