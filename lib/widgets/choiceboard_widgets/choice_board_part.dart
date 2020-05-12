import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';

import '../../di.dart';
import 'delete_pictogram_from_choice_board_button.dart';

/// Class that defines a pictogram and a button to delete it
class ChoiceBoardPart extends StatelessWidget {
  /// Constructor for ChoiceBoard-part widget.
  ChoiceBoardPart(this._pictogramModel, this._user) {
    _pictogramImageBloc.load(_pictogramModel);
  }

  final PictogramImageBloc _pictogramImageBloc =
      di.getDependency<PictogramImageBloc>();

  final PictogramModel _pictogramModel;

  final DisplayNameModel _user;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Image>(
      stream: _pictogramImageBloc.image,
      builder: (BuildContext context, AsyncSnapshot<Image> snapshot) {
        if (snapshot.hasData) {
          return Container(
            decoration: BoxDecoration(
                border: Border.all(
              color: Colors.black,
                  width: 2
            )),
            child: FittedBox(
              child: Stack(children: <Widget>[
                snapshot.data,
                Positioned(
                  top: 0,
                  right: 0,
                  child: DeletePictogramFromChoiceboardButton(_pictogramModel),
                ),
              ]),
              // Key is used for testing the widget.
            ),
          );
        } else {
          return Container(); // shit
        }
      },
    );
  }
}
