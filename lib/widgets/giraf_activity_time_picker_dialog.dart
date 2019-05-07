import 'package:api_client/models/activity_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    this._timerBloc, {
    Key key,
  }) : super(key: key) {
    _timerBloc.load(_activity);
  }

  final ActivityModel _activity;
  final TimerBloc _timerBloc;

  final TextEditingController _textEditingControllerHours =
      TextEditingController();
  final TextEditingController _textEditingControllerMinutes =
      TextEditingController();
  final TextEditingController _textEditingControllerSeconds =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
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
            Container(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  _timerTextField(
                      'Timer', _textEditingControllerHours, context),
                  _timerTextField(
                      'Minutter', _textEditingControllerMinutes, context),
                  _timerTextField(
                      'Sekunder', _textEditingControllerSeconds, context)
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 5, 10),
                      child: GirafButton(
                        key: const Key('TimePickerDialogCancelButton'),
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
                        key: const Key('TimePickerDialogAcceptButton'),
                        onPressed: () {
                          _acceptInput(context);
                        },
                        icon: const ImageIcon(
                            AssetImage('assets/icons/accept.png')),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _timerTextField(String fieldName, TextEditingController textController,
      BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(fieldName),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  color: Colors.white),
              child: TextField(
                  key: Key(fieldName + 'TextFieldKey'),
                  onSubmitted: (String s) {
                    _acceptInput(context);
                  },
                  controller: textController,
                  style: const TextStyle(
                    fontSize: 50,
                  ),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration.collapsed(
                    hintText: '',
                  ),
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(2)
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  void _acceptInput(BuildContext context) {
    final Duration duration = Duration(
      hours: int.tryParse(_textEditingControllerHours.text) ?? 0,
      minutes: int.tryParse(_textEditingControllerMinutes.text) ?? 0,
      seconds: int.tryParse(_textEditingControllerSeconds.text) ?? 0,
    );

    if (duration.inSeconds != 0) {
      _timerBloc.addTimer(duration);
      Routes.pop(context);
    }
  }
}
