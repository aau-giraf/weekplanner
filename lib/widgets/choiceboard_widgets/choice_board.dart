import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:flutter/material.dart';

import 'choice_board_part.dart';

/// class that defines a Choiceboard
class ChoiceBoard extends StatelessWidget {
  /// Constructor for ChoiceBoard widget
  const ChoiceBoard(this._pictograms, this._user);

  final List<PictogramModel> _pictograms;

  final DisplayNameModel _user;

  @override
  Widget build(BuildContext context) {
    final List<ChoiceBoardPart> _parts = <ChoiceBoardPart>[];

    for (int i = 0; i < _pictograms.length; i++) {
      _parts.add(ChoiceBoardPart(_pictograms[i], _user));
    }

    return GridView.count(
      crossAxisCount: 2,
      children:

      List<Container>.generate(
       _parts.length,
       (index) {
        return Container(
        child: _parts[index],
        );
       },
       ));
  }
}
