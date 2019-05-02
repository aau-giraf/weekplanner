import 'package:api_client/models/enums/weekday_enum.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/giraf_title_header.dart';

///A dialog widget presented to the user to confirm an action based on
///a list of checkboxes presented in the dialog. The dialog consists of a
///title, a description, and two buttons and a dropdown menu. One button to
///cancel the action and one button to accept and perform the action.
class GirafCopyActivitiesDialog extends StatefulWidget {
  ///The dialog displays the title and description, with two buttons and a
  /// list of checkboxes
  const GirafCopyActivitiesDialog(
      {Key key,
      @required this.title,
      this.description,
      @required this.confirmButtonText,
      @required this.confirmButtonIcon,
      @required this.confirmOnPressed})
      : super(key: key);

  ///title of the dialogBox, displayed in the header of the dialogBox
  final String title;

  ///description of the dialogBox, displayed under the header
  final String description;

  ///text on the confirm button, describing the confirmed action
  final String confirmButtonText;

  ///icon on the confirm button, visualizing the confirmed action
  final ImageIcon confirmButtonIcon;

  ///the method to call when the confirmation button is pressed
  final void Function(List<bool>, BuildContext) confirmOnPressed;

  @override
  _State createState() => _State();
}

class _State extends State<GirafCopyActivitiesDialog> {
  static const Color checkboxColor = Color(0xFFFF9D00);

  final List<bool> _checkboxDays = List<bool>.filled(7, false);

  void _checkboxChanged(bool value, Weekday day) =>
      setState(() => _checkboxDays[day.index] = value);

  void _checkboxMonChanged(bool value) {
    _checkboxChanged(value, Weekday.Monday);
  }

  void _checkboxTueChanged(bool value) {
    _checkboxChanged(value, Weekday.Tuesday);
  }

  void _checkboxWedChanged(bool value) {
    _checkboxChanged(value, Weekday.Wednesday);
  }

  void _checkboxThuChanged(bool value) {
    _checkboxChanged(value, Weekday.Thursday);
  }

  void _checkboxFriChanged(bool value) {
    _checkboxChanged(value, Weekday.Friday);
  }

  void _checkboxSatChanged(bool value) {
    _checkboxChanged(value, Weekday.Saturday);
  }

  void _checkboxSunChanged(bool value) {
    _checkboxChanged(value, Weekday.Sunday);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0.0),
      titlePadding: const EdgeInsets.all(0.0),
      shape:
          Border.all(color: const Color.fromRGBO(112, 112, 112, 1), width: 5.0),
      title: Center(
          child: GirafTitleHeader(
        title: widget.title,
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
                  //if description is null, its replaced with empty.
                  widget.description ?? '',
                  textAlign: TextAlign.center,
                ),
              ))
            ],
          ),
          Container(
            padding: const EdgeInsets.all(30.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: <Widget>[
                            CheckboxListTile(
                              value: _checkboxDays[Weekday.Monday.index],
                              onChanged: _checkboxMonChanged,
                              title: const Text('Mandag'),
                              controlAffinity: ListTileControlAffinity.trailing,
                              activeColor: checkboxColor,
                            ),
                            CheckboxListTile(
                              value: _checkboxDays[Weekday.Wednesday.index],
                              onChanged: _checkboxWedChanged,
                              title: const Text('Onsdag'),
                              controlAffinity: ListTileControlAffinity.trailing,
                              activeColor: checkboxColor,
                            ),
                            CheckboxListTile(
                              value: _checkboxDays[Weekday.Friday.index],
                              onChanged: _checkboxFriChanged,
                              title: const Text('Fredag'),
                              controlAffinity: ListTileControlAffinity.trailing,
                              activeColor: checkboxColor,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: <Widget>[
                            CheckboxListTile(
                              value: _checkboxDays[Weekday.Tuesday.index],
                              onChanged: _checkboxTueChanged,
                              title: const Text('Tirsdag'),
                              controlAffinity: ListTileControlAffinity.trailing,
                              activeColor: checkboxColor,
                            ),
                            CheckboxListTile(
                              value: _checkboxDays[Weekday.Thursday.index],
                              onChanged: _checkboxThuChanged,
                              title: const Text('Torsdag'),
                              controlAffinity: ListTileControlAffinity.trailing,
                              activeColor: checkboxColor,
                            ),
                            CheckboxListTile(
                              value: _checkboxDays[Weekday.Saturday.index],
                              onChanged: _checkboxSatChanged,
                              title: const Text('Lørdag'),
                              controlAffinity: ListTileControlAffinity.trailing,
                              activeColor: checkboxColor,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: <Widget>[
                            CheckboxListTile(
                              value: _checkboxDays[Weekday.Sunday.index],
                              onChanged: _checkboxSunChanged,
                              title: const Text('Søndag'),
                              controlAffinity: ListTileControlAffinity.trailing,
                              activeColor: checkboxColor,
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
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
                          AssetImage('assets/icons/cancel.png')),
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
                      key: const Key('ConfirmDialogConfirmButton'),
                      text: widget.confirmButtonText,
                      icon: widget.confirmButtonIcon,
                      onPressed: () {
                        widget.confirmOnPressed(_checkboxDays, context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
