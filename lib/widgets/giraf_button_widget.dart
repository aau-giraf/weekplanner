import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

/// A button for the Giraf application.
class GirafButton extends StatefulWidget {
  /// A button for the Giraf application.
  /// The button can contain some text and an icon both of which are optional.
  /// isEnabled determines whether the button is enabled or disabled by default.
  /// isEnabledStream is a stream which is listened to, to update the
  /// enabled/disabled state of the button.
  const GirafButton({
    Key key,
    this.text,
    this.icon,
    this.width = double.infinity,
    this.height = 50.0,
    this.onPressed,
    this.isEnabled = true,
    this.isEnabledStream,
  }) : super(key: key);

  /// The text placed at the center of the button.
  final String text;

  /// The icon placed next to the text on the button.
  final IconData icon;

  /// The width of the button.
  final double width;

  /// The height of the button.
  final double height;

  /// The function to be called when the button is pressed.
  /// The function must be a void funtion with no input parameters.
  final VoidCallback onPressed;

  /// Determines whether the button is enabled or disabled by default. If
  /// isEnabledStream is also supplied, the latest emitted item from the stream
  /// will determine whether the button is enabled. If the stream emits a null
  /// value, isEnabled will be used instead.
  final bool isEnabled;

  /// A stream which tells whether the button should be enabled or disabled.
  /// If the stream emits a null value, the value of isEnabled will be used
  /// instead.
  final Observable<bool> isEnabledStream;

  @override
  _GirafButtonState createState() => _GirafButtonState();
}

class _GirafButtonState extends State<GirafButton> {
  @override
  void initState() {
    _isEnabled = widget.isEnabled;
    _isPressed = false;
    if (widget.isEnabledStream != null) {
      _isEnabledSubscription = widget.isEnabledStream.listen((bool value) =>
          setState(() => {
                _isEnabled = value ?? widget.isEnabled
              })); // If a null value is emitted reset enabled state to default.
    }
    super.initState();
  }

  final Gradient _gradientDefault = const LinearGradient(colors: <Color>[
    Color.fromARGB(0xff, 0xff, 0xcd, 0x59),
    Color.fromARGB(0xff, 0xff, 0x9d, 0x00)
  ], begin: Alignment(0.5, -1.0), end: Alignment(0.5, 1.0));

  final Gradient _gradientPressed = const LinearGradient(colors: <Color>[
    Color.fromARGB(0xff, 0xd4, 0xad, 0x2f),
    Color.fromARGB(0xff, 0xff, 0x9d, 0x00)
  ], begin: Alignment(0.5, -1.0), end: Alignment(0.5, 1.0));

  final Gradient _gradientDisabled = const LinearGradient(colors: <Color>[
    Color.fromARGB(0x46, 0xff, 0xcd, 0x59),
    Color.fromARGB(0x46, 0xff, 0x9d, 0x00)
  ], begin: Alignment(0.5, -1.0), end: Alignment(0.5, 1.0));

  final Color _borderDefault = const Color.fromARGB(0xff, 0x8a, 0x6e, 0x00);
  final Color _borderPressed = const Color.fromARGB(0xff, 0x49, 0x37, 0x00);
  final Color _borderDisabled = const Color.fromARGB(0xa6, 0x8a, 0x6e, 0x00);

  bool _isPressed;
  bool _isEnabled;
  StreamSubscription<bool> _isEnabledSubscription;

  @override
  Widget build(BuildContext context) {
    final Widget result = Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        gradient: _isEnabled
            ? (_isPressed ? _gradientPressed : _gradientDefault)
            : _gradientDisabled,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
            color: _isEnabled
                ? (_isPressed ? _borderPressed : _borderDefault)
                : _borderDisabled,
            width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: _isEnabled
            ? InkWell(
                onTap: () => _onTapped(widget.onPressed),
                child: _widgetsOnButton())
            : _widgetsOnButton(),
      ),
    );
    return result;
  }

  void _onTapped(VoidCallback widgetOnPressed) {
    if (_isEnabled) {
      setState(() => {_isPressed = true});
      widgetOnPressed();
    }
  }

  Widget _widgetsOnButton() {
    const TextStyle textStyle = TextStyle(
      color: Colors.black,
    );

    if (widget.text != null && widget.icon != null)
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(widget.icon),
          const SizedBox(
            width: 10,
          ),
          Text(
            widget.text,
            style: textStyle,
          ),
        ],
      );
    else if (widget.text != null)
      return Center(
          child: Text(
        widget.text,
        style: textStyle,
      ));
    else if (widget.icon != null) {
      return Center(
        child: Icon(widget.icon),
      );
    }

    return null;
  }

  @override
  void dispose() {
    _isEnabledSubscription?.cancel();
    super.dispose();
  }
}
