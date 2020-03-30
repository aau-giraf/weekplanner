import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';

/// Creates a button in the ButtomAppBar.
class BottomAppBarButton extends StatelessWidget {
  
  /// Constrtuctor to get required information.
  const BottomAppBarButton({
    Key key,
    @required this.buttonText,
    @required this.buttonKey,
    @required this.assetPath,
    @required this.dialogFunction,
    this.isEnabled  = true,
    this.isEnabledStream,
  }) : super(key: key);

  /// Text to be dispayed on the button.
  final String buttonText;
  
  /// Key to identify the button when testing. 
  final String buttonKey;

  /// Path to the ImageIcon.
  final String assetPath;

  /// Function to handle when the button is pressed. 
  final Function dialogFunction;

  /// Determines whether the button is enabled or disabled by default. If no
  /// isEnabledStream is supplied.
  final bool isEnabled;

  /// A stream which tells whether the button should be enabled or disabled.
  /// If the stream emits a null value, isEnabled will be used instead.
  final Observable<bool> isEnabledStream;

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
        isEnabled: isEnabled,
        isEnabledStream: isEnabledStream,
      ),
    );
  }
}
