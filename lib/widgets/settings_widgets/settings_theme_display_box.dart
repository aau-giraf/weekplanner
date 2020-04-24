import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


/// Class for color theme display box
class ThemeBox extends StatelessWidget {

  /// Constructor
  const ThemeBox(this._leftColor, this._rightColor);

  /// Constructer that takes hex values as input
  factory ThemeBox.fromHexValues(String leftHexValue, String rightHexValue){
    return ThemeBox(_colorFromHex(leftHexValue), _colorFromHex(rightHexValue));
  }

  final Color _leftColor;
  final Color _rightColor;

  static Color _colorFromHex(String hexColorValue) {
    return Color(int.parse(hexColorValue.replaceFirst('#', '0xff')));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Row(children: <Widget>[
          Container(
            height: 20.0,
            width: 20.0,
            color: _leftColor,
          ),
          Container(
            height: 20.0,
            width: 20.0,
            color: _rightColor,
          ),
        ]),
      ),
    );
  }
}
