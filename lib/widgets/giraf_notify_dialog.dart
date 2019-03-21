import 'package:flutter/material.dart';
import 'package:weekplanner/widgets/giraf_dialog_header.dart';

class GirafNotifyDialog extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String description;

  GirafNotifyDialog({Key key, @required this.title, this.description})
      : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(0.0),
      titlePadding: EdgeInsets.all(0.0),
      shape:
          Border.all(color: const Color.fromRGBO(112, 112, 112, 1), width: 5.0),
      title: Center(
          child: GirafDialogHeader(
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
                  description,
                  textAlign: TextAlign.center,
                ),
              ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                        side: const BorderSide(
                            color: const Color.fromRGBO(0, 0, 0, 0.3))),
                    color: const Color.fromRGBO(255, 157, 0, 1),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.check,
                          color: const Color.fromRGBO(0, 0, 0, 1),
                        ),
                        Text(
                          'Okay',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
