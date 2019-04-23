import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:api_client/models/pictogram_model.dart';

/// Widget for rendering pictogram models as images
class PictogramImage extends StatelessWidget {
  /// Renders [pictogram] model as image
  ///
  /// The image url is extracted from the [pictogram] provided, and an
  /// authenticated request is then made to the back-end to load the image.
  ///
  /// The [onPressed] function will be called every time the image is pressed
  PictogramImage(
      {Key key,
      @required this.pictogram,
      @required this.onPressed,
      this.onLongPressed})
      : super(key: key) {
    _bloc.load(pictogram);
  }

  /// Provided Pictogram to load
  final PictogramModel pictogram;

  /// The provided callback function which will be called on
  /// every press of the image
  final VoidCallback onPressed;
  /// The provided callback function which will be called on
  /// every long press of the activity
  final VoidCallback onLongPressed;

  final PictogramImageBloc _bloc = di.getDependency<PictogramImageBloc>();
  final Widget _loading = Center(
      child: Container(
          width: 100, height: 100, child: const CircularProgressIndicator()));

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPressed,
      onTap: onPressed,
      child: Card(
        child: FittedBox(
            fit: BoxFit.contain,
            child: StreamBuilder<Image>(
                stream: _bloc.image,
                builder:
                    (BuildContext context, AsyncSnapshot<Image> snapshot) =>
                        snapshot.data ?? _loading)),
      ),
    );
  }
}
