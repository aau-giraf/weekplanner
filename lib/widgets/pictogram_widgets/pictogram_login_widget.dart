import 'package:api_client/api/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/giraf_confirm_dialog.dart';
import 'package:weekplanner/widgets/giraf_notify_dialog.dart';
import 'package:weekplanner/widgets/pictogram_widgets/pictogram_password_choices.dart';
import '../../routes.dart';

class PictogramLogin extends StatelessWidget {
  ///Widget with the possible pictograms in the code and the currently picked
  /// pictograms in the code.
  PictogramLogin(this.pictogramOptions) : super();

  /// List of the possible pictograms in the passsword
  final List<PictogramModel> pictogramOptions;
  /// List of currently chosen pictograms
  final List<PictogramModel> pickedPictograms =
    List<PictogramModel>.filled(4,null);

  @override
  Widget build(BuildContext context) {
    //return GestureDetector(
    return Column(
          children: <Widget>[
            //Flexible(
              const Text("hej")
    //)
                //child: PictogramChoices()

            ,
            const Text('Hejsa')
          ]
        );
    //);
  }
}