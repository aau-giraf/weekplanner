import 'dart:async';

import 'package:flutter/material.dart';

class GirafDefaultButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final double width;
  final double height;
  final Function onPressed;

  const GirafDefaultButton({
    Key key,
    this.text,
    this.icon,
    this.width = double.infinity,
    this.height = 50.0,
    this.onPressed,
  }) : super(key: key);

  @override
  _GirafDefaultButtonState createState() => _GirafDefaultButtonState();
}

class _GirafDefaultButtonState extends State<GirafDefaultButton> {
  final Gradient gradientDefault = const LinearGradient(colors: <Color>[
    Color.fromARGB(0xff, 0xff, 0xcd, 0x59),
    Color.fromARGB(0xff, 0xff, 0x9d, 0x00)
  ], begin: Alignment(0.5, -1.0), end: Alignment(0.5, 1.0));

  final Gradient gradientPressed = const LinearGradient(colors: <Color>[
    Color.fromARGB(0xff, 0xd4, 0xad, 0x2f),
    Color.fromARGB(0xff, 0xff, 0x9d, 0x00)
  ], begin: Alignment(0.5, -1.0), end: Alignment(0.5, 1.0));

  final Gradient gradientDisabled = const LinearGradient(colors: <Color>[
    Color.fromARGB(0xa6, 0xff, 0xcd, 0x59),
    Color.fromARGB(0xa6, 0xff, 0x9d, 0x00)
  ], begin: Alignment(0.5, -1.0), end: Alignment(0.5, 1.0));

  final Color borderDefault = const Color.fromARGB(0xff, 0x8a, 0x6e, 0x00);
  final Color borderPressed = const Color.fromARGB(0xff, 0x49, 0x37, 0x00);
  final Color borderDisabled = const Color.fromARGB(0xa6, 0x8a, 0x6e, 0x00);
  
  bool isPressed = false;
  bool isEnabled = true;

  @override
  Widget build(BuildContext context) {
    Widget result = Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
          gradient: isEnabled ? (isPressed ? gradientPressed : gradientDefault) : gradientDisabled,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isEnabled ? (isPressed ? borderPressed : borderDefault) : borderDisabled),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[500],
              offset: Offset(0.0, 1.5),
              blurRadius: 1.5,
            ),
          ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: () => _onTapped(widget.onPressed),
            child: widgetsOnButton()),
      ),
    );
    isPressed = false;
    return result;
  }

  void _onTapped(Function widgetOnPressed){
    setState(() => {isPressed = true});
    widgetOnPressed();
  }

  Widget widgetsOnButton(){
    TextStyle textStyle = TextStyle(color: Colors.black,);
    if (widget.text != null && widget.icon != null)
      return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(widget.icon),
                SizedBox(width: 10,),
                Text(
                  widget.text,
                  style: textStyle,
                ),
              ],
            );
    else if (widget.text != null)
      return Center(child: Text(widget.text, style: textStyle,));
    else if (widget.icon != null)
      return Center(child: Icon(widget.icon),);
    
    return null;
  }
}
