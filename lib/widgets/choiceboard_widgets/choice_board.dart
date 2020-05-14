import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/activity_bloc.dart';

import 'choice_board_part.dart';

/// class that defines a ChoiceBoard
class ChoiceBoard extends StatelessWidget {
  /// Constructor for ChoiceBoard widget
  const ChoiceBoard(this._activity, this._bloc);

  final ActivityModel _activity;

  final ActivityBloc _bloc;

  @override
  Widget build(BuildContext context) {
    final List<ChoiceBoardPart> _parts = <ChoiceBoardPart>[];

    for (int i = 0; i < _activity.pictograms.length; i++) {
      _parts.add(ChoiceBoardPart(_activity.pictograms[i], _bloc, _activity));
    }

    return GridView.count(
        physics: const NeverScrollableScrollPhysics(), // disables scrolling
        crossAxisCount: 2,
        children: List<Widget>.generate(
          _parts.length,
          (int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.black,
                  width: 2,
                )),
                child: _parts[index],
              ),
            );
          },
        ));
  }
}
