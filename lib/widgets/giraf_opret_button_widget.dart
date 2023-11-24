import 'dart:async';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../style/custom_color.dart' as theme;

/// A button for the Giraf application.
class GirafButtonOpret extends StatefulWidget {
  /// A button for the Giraf application.
  /// The button can contain some text and an icon both of which are optional.
  /// isEnabled determines whether the button is enabled or disabled by default.
  /// isEnabledStream is a stream which is listened to, to update the
  /// enabled/disabled state of the button.
  const GirafButtonOpret({
    Key key,
    this.text,
    this.fontSize = 35,
    this.fontWeight = FontWeight.bold,
    this.icon,
    this.width,
    this.height = 50.0,
    @required this.onPressed,
    this.isEnabled = true,
    // ignore: avoid_unused_constructor_parameters
    this.isEnabledStream, StreamBuilder<File> child,
  }) : super(key: key);

  /// The text placed at the center of the button.
  final String text;

  /// The size of the text
  final double fontSize;

  /// The icon placed next to the text on the button.
  final ImageIcon icon;

  /// The width of the button.
  final double width;

  /// The height of the button.
  final double height;

  /// The typeface thickness to use when painting the text (e.g., bold)
  final FontWeight fontWeight;

  /// The function to be called when the button is pressed.
  /// The function must be a void funtion with no input parameters.
  /// If this is set to null, the button will be disabled.
  final VoidCallback onPressed;

  /// Determines whether the button is enabled or disabled by default. If
  /// isEnabledStream is also supplied, the latest emitted item from the stream
  /// will determine whether the button is enabled. If the stream emits a null
  /// value, isEnabled will be used instead.
  final bool isEnabled;

  /// A stream which tells whether the button should be enabled or disabled.
  /// If the stream emits a null value, the value of isEnabled will be used
  /// instead.
  final Stream<bool> isEnabledStream;

  @override
  _GirafButtonOpretNewState createState() => _GirafButtonOpretNewState();
}

class _GirafButtonOpretNewState extends State<GirafButtonOpret> {
  @override
  void initState() {
    // If onPressed callback is null, the button should be disabled.
    _isEnabled = widget.isEnabled && widget.onPressed != null;
    _isPressed = false;
    if (widget.isEnabledStream != null) {
      _isEnabledSubscription =
          widget.isEnabledStream.listen(_handleIsEnabledStreamEvent);
    }
    super.initState();
  }

  static const Gradient _gradientDefault = LinearGradient(
      colors: <Color>[theme.GirafColors.gradientDefaultBlue,
        theme.GirafColors.gradientDefaultDarkBlue],
      begin: Alignment(0.0, -1.0),
      end: Alignment(0.0, 1.0));

  static const Gradient _gradientPressed = LinearGradient(
      colors: <Color>[theme.GirafColors.gradientDefaultBluePressed,
        theme.GirafColors.gradientDefaultDarkBlue],
      begin: Alignment(0.0, -1.0),
      end: Alignment(0.0, 1.0));

  static const Gradient _gradientDisabled = LinearGradient(
      colors: <Color>[theme.GirafColors.gradientDefaultBluePressed,
        theme.GirafColors.gradientDefaultBlue],
      begin: Alignment(0.0, -1.0),
      end: Alignment(0.0, 1.0));

  static const Color _borderDefault = theme.GirafColors.gradientBlueBorder;
  static const Color _borderPressed = theme.GirafColors.gradientBlueBorder;
  static const Color _borderDisabled = theme.GirafColors.gradientBlueBorder;

  bool _isPressed;
  bool _isEnabled;
  StreamSubscription<bool> _isEnabledSubscription;
  Timer _timer;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          gradient: _isEnabled
              ? (_isPressed ? _gradientPressed : _gradientDefault)
              : _gradientDisabled,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
              color: _isEnabled
                  ? (_isPressed ? _borderPressed : _borderDefault)
                  : _borderDisabled,
              width: 1.2),
        ),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: _buildWidgetsOnButton()),
      ),
    );
  }

  void _onTapDown(TapDownDetails details) {
    if (_isEnabled) {
      setState(() => _isPressed = true);
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (_isEnabled) {
      widget.onPressed();
      // On a quick tap the pressed state is not shown, because the state
      // changes too fast, hence we introduce a delay.
      _timer = Timer(const Duration(milliseconds: 100),
          () => setState(() => _isPressed = false));
    }
  }

  void _onTapCancel() {
    if (_isEnabled) {
      setState(() => _isPressed = false);
    }
  }

  void _handleIsEnabledStreamEvent(bool value) {
    // If a null value is emitted reset enabled state to default.
    value ??= widget.isEnabled;

    // If onPressed callback is null, the button should be disabled.
    if (widget.onPressed == null) {
      value = false;
    }

    // Only update state if the new value is different from the previous.
    if (value != _isEnabled) {
      setState(() {
        _isEnabled = value;
      });
    }
  }

  Widget _buildWidgetsOnButton() {
    final TextStyle textStyle = TextStyle(color: Colors.white,
        fontSize: widget.fontSize, fontWeight: widget.fontWeight);

    if (widget.text != null && widget.icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          widget.icon,
          const SizedBox(
            width: 5, // space between the icon and the text
          ),
          Text(
            widget.text,
            style: textStyle,
          ),
        ],
      );
    } else if (widget.text != null) {
      return Center(
          child: AutoSizeText(
            widget.text,
            style: textStyle,
            minFontSize: 5,
      ));
    } else if (widget.icon != null) {
      return Center(
        child: widget.icon,
      );
    }

    return null;
  }

  @override
  void dispose() {
    _isEnabledSubscription?.cancel();
    _timer?.cancel();
    super.dispose();
  }
}
