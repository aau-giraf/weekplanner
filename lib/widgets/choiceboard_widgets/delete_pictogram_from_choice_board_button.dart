import 'package:api_client/models/pictogram_model.dart';
import 'package:flutter/cupertino.dart';

import '../giraf_button_widget.dart';

/// Class that defines a button that will  delete the pictogram
/// with [pictogramId] when pressed
class DeletePictogramFromChoiceboardButton extends StatelessWidget {
  /// Constructor
  const DeletePictogramFromChoiceboardButton(this._pictogramModel);

  final PictogramModel _pictogramModel;

  @override
  Widget build(BuildContext context) {
    return GirafButton(
      text: 'Slet',
      onPressed: () {
        //TODO: Use block to delete the _pictogramModel
      },
    );
  }
}
