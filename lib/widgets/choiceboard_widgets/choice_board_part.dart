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
          return Stack(
            children: <Widget>[
              SizedBox.expand(
                child: FittedBox(
                  child: snapshot.data,
                  // Key is used for testing the widget.
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: DeletePictogramFromChoiceboardButton(_pictogramModel),
              ),
            ],
          );
        } else {
          return Container(); // shit
        }
      },
    );
  }
}
