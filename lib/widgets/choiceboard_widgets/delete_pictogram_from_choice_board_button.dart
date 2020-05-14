import 'package:api_client/models/pictogram_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:weekplanner/blocs/activity_bloc.dart';

import '../giraf_button_widget.dart';

/// Class that defines a button that will  delete the pictogram
/// with [pictogramId] when pressed
class DeletePictogramFromChoiceboardButton extends StatelessWidget {
  /// Constructor
  const DeletePictogramFromChoiceboardButton(
      this._pictogramModel, this._callback);

  final PictogramModel _pictogramModel;
  final VoidCallback _callback;

  @override
  Widget build(BuildContext context) {
    return GirafButton(
      height: MediaQuery.of(context).size.width * 0.07,
      text: 'Slet',
      onPressed: () => _callback(),
      fontSize: 30,
      icon: const ImageIcon(AssetImage('assets/icons/delete.png')),
    );
  }
}
