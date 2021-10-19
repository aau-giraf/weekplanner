import 'package:flutter/cupertino.dart';

import '../giraf_button_widget.dart';

/// Class that defines a button that will  delete the pictogram
/// with [pictogramId] when pressed
class DeletePictogramFromChoiceBoardButton extends StatelessWidget {

  /// Constructor
  const DeletePictogramFromChoiceBoardButton(this._callback);

  final VoidCallback _callback;

  @override
  Widget build(BuildContext context) {
    return GirafButton(
      key: const Key('ChoiceBoardDeleteButton'),
      height: MediaQuery.of(context).size.width * 0.12,
      text: 'Slet',
      onPressed: () => _callback(),
      fontSize: 30,
      icon: const ImageIcon(AssetImage('assets/icons/delete.png')),
    );
  }
}
