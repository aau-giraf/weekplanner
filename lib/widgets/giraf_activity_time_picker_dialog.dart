import 'package:api_client/models/activity_model.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/timer_bloc.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/giraf_title_header.dart';

///The acitivty time picker dialog is a dialog, asking for a duration input.
///The duration should be inserted in the textfield, and the user can either
///cancel the dialog, or confirm to create the timer for the activity.
class GirafActivityTimerPickerDialog extends StatelessWidget {

  ///The activity time picker takes the activity as input, to insert a timer
  ///to the given activity.
  GirafActivityTimerPickerDialog(
  this._activity,
      {Key key,})
      : super(key: key) {
    _timerBloc.load(_activity);
  }

  final ActivityModel _activity;
  final TimerBloc _timerBloc = TimerBloc();

  @override
  Widget build(BuildContext context) {
    _timerBloc.initTimer();
    final bool keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    final bool isInPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final TextEditingController txtController = TextEditingController();
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0.0),
      titlePadding: const EdgeInsets.all(0.0),
      shape: Border.all(
          color: const Color.fromRGBO(112, 112, 112, 1), width: 5.0),
      title: const Center(
          child: GirafTitleHeader(
            title: 'Vælg tid for aktivitet',
          )),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Center(child: Text('Indtast tid')),
          const Center(
            child: Text(
              'Timer : Minutter : Sekunder',
              style: TextStyle(
                  fontSize: 10, color: Color.fromRGBO(170, 170, 170, 1)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius:
                  const BorderRadius.all(Radius.circular(20.0)),
                  color: Colors.white),
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
              child: TextField(
                key: const Key('TimerKey'),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                controller: txtController,
                textDirection: TextDirection.ltr,
                cursorColor: Colors.white,
                autofocus: true,
                decoration: const InputDecoration.collapsed(
                  hintText: '00:00',
                  hintStyle:
                  TextStyle(color: Color.fromRGBO(170, 170, 170, 1)),
                  fillColor: Colors.white,
                ),
                onChanged: (String input) {
                  String placeholderText;
                  String stringToAddd = '';
                  if (input.length == 1) {
                    txtController.text = '00:0' + input;
                  } else {
                    placeholderText = input.substring(0, input.length);
                    placeholderText = placeholderText.replaceAll(':', '');
                    for (int i = 0; i < placeholderText.length; i++) {
                      if (placeholderText.substring(i, i + 1) != '0') {
                        if (placeholderText.length - i == 2) {
                          stringToAddd = '00:' +
                              placeholderText.substring(
                                  i, placeholderText.length);
                          break;
                        } else if (placeholderText.length < 4) {
                          stringToAddd = '0' + placeholderText;
                          stringToAddd = stringToAddd.replaceRange(
                              stringToAddd.length - 2,
                              stringToAddd.length,
                              ':' +
                                  stringToAddd.substring(
                                      stringToAddd.length - 2,
                                      stringToAddd.length));
                          break;
                        } else {
                          stringToAddd = placeholderText;
                          if (stringToAddd.length > 4) {
                            if (stringToAddd.substring(0, 1) == '0') {
                              stringToAddd =
                                  stringToAddd.replaceRange(0, 1, '');
                            } else {
                              stringToAddd = stringToAddd.replaceRange(
                                  stringToAddd.length - 4,
                                  stringToAddd.length - 2,
                                  ':' +
                                      stringToAddd.substring(
                                          stringToAddd.length - 4,
                                          stringToAddd.length - 2));
                            }
                          }
                          stringToAddd = stringToAddd.replaceRange(
                              stringToAddd.length - 2,
                              stringToAddd.length,
                              ':' +
                                  stringToAddd.substring(
                                      stringToAddd.length - 2,
                                      stringToAddd.length));
                          break;
                        }
                      }
                    }
                    txtController.text = stringToAddd;
                  }
                  txtController.selection = TextSelection.collapsed(
                      offset: txtController.text.length);
                },
              ),
            ),
          ),
          Visibility(
            visible: (isInPortrait && !keyboardVisible) ||
                (isInPortrait && keyboardVisible) ||
                (!isInPortrait && !keyboardVisible),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 5, 10),
                      child: GirafButton(
                        onPressed: () => Routes.pop(context),
                        icon: const ImageIcon(
                            AssetImage('assets/icons/cancel.png')),
                      )),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 10, 10),
                      child: GirafButton(
                        onPressed: () {
                          _timerBloc.addTimer(
                              calculateDuration(txtController.text));
                          Routes.pop(context);
                        },
                        icon: const ImageIcon(
                            AssetImage('assets/icons/accept.png')),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///Method for calculating duration from string
  Duration calculateDuration(String durationFromTextField) {
    int hours = 0;
    int minutes = 0;
    int seconds = 0;
    final List<String> parts = durationFromTextField.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    seconds = int.parse(parts[parts.length - 1]);
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  ///Method to check whether the user have input something wrong in the
  ///textfield when trying to accept
  bool checkTextInput(String input){

  }
}
