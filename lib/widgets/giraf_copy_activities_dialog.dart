import 'package:api_client/models/enums/weekday_enum.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/copy_activities_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/giraf_title_header.dart';

/// A dialog widget presented to the user to confirm an action based on
/// a list of checkboxes presented in the dialog. The dialog consists of a
/// title, a description, and two buttons and a dropdown menu. One button to
/// cancel the action and one button to accept and perform the action.
class GirafCopyActivitiesDialog extends StatelessWidget {
  /// The dialog displays the title and description, with two buttons and a
  /// list of checkboxes
  GirafCopyActivitiesDialog(
      {Key key,
      @required this.title,
      this.description,
      @required this.confirmButtonText,
      @required this.confirmButtonIcon,
      @required this.confirmOnPressed})
      : super(key: key);

  /// Bloc to keep track of which checkboxes are marked
  final CopyActivitiesBloc copyActivitiesBloc =
      di.getDependency<CopyActivitiesBloc>();

  /// title of the [dialogBox], displayed in the header of the [dialogBox]
  final String title;

  /// description of the [dialogBox], displayed under the header
  final String description;

  /// text on the confirm button, describing the confirmed action
  final String confirmButtonText;

  /// icon on the confirm button, visualizing the confirmed action
  final ImageIcon confirmButtonIcon;

  /// the method to call when the confirmation button is pressed
  final void Function(List<bool>, BuildContext) confirmOnPressed;

  /// color of checkbox
  static const Color checkboxColor = Color(0xFFFF9D00);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0.0),
      titlePadding: const EdgeInsets.all(0.0),
      shape:
          Border.all(color: const Color.fromRGBO(112, 112, 112, 1), width: 5.0),
      title: Center(
          child: GirafTitleHeader(
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
                  //if description is null, its replaced with empty.
                  description ?? '',
                  textAlign: TextAlign.center,
                ),
              ))
            ],
          ),
          StreamBuilder<List<bool>>(
              stream: copyActivitiesBloc.checkboxValues,
              initialData: List<bool>.filled(7, false),
              builder:
                  (BuildContext context, AsyncSnapshot<List<bool>> snapshot) {
                return Container(
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
                                  _buildCheckboxListTile(
                                      Weekday.Monday,
                                      const Key('MonCheckbox'),
                                      'Mandag',
                                      snapshot.data[Weekday.Monday.index]),
                                  _buildCheckboxListTile(
                                      Weekday.Wednesday,
                                      const Key('WedCheckbox'),
                                      'Onsdag',
                                      snapshot.data[Weekday.Wednesday.index]),
                                  _buildCheckboxListTile(
                                      Weekday.Friday,
                                      const Key('FriCheckbox'),
                                      'Fredag',
                                      snapshot.data[Weekday.Friday.index])
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Column(
                                children: <Widget>[
                                  _buildCheckboxListTile(
                                      Weekday.Tuesday,
                                      const Key('TueCheckbox'),
                                      'Tirsdag',
                                      snapshot.data[Weekday.Tuesday.index]),
                                  _buildCheckboxListTile(
                                      Weekday.Thursday,
                                      const Key('ThuCheckbox'),
                                      'Torsdag',
                                      snapshot.data[Weekday.Thursday.index]),
                                  _buildCheckboxListTile(
                                      Weekday.Saturday,
                                      const Key('SatCheckbox'),
                                      'Lørdag',
                                      snapshot.data[Weekday.Saturday.index])
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
                                  _buildCheckboxListTile(
                                      Weekday.Sunday,
                                      const Key('SunCheckbox'),
                                      'Søndag',
                                      snapshot.data[Weekday.Sunday.index])
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
                );
              }),
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
                      key: const Key('DialogCancelButton'),
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
                      key: const Key('DialogConfirmButton'),
                      text: confirmButtonText,
                      icon: confirmButtonIcon,
                      onPressed: () {
                        confirmOnPressed(
                            copyActivitiesBloc.getCheckboxValues(), context);
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

  CheckboxListTile _buildCheckboxListTile(
      Weekday weekday, Key checkboxKey, String checkboxTitle, bool value) {
    return CheckboxListTile(
      key: checkboxKey,
      value: value,
      onChanged: (bool value) =>
          copyActivitiesBloc.toggleCheckboxState(weekday.index),
      title: Text(checkboxTitle),
      controlAffinity: ListTileControlAffinity.trailing,
      activeColor: checkboxColor,
    );
  }
}
