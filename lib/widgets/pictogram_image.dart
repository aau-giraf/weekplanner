import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/pictogram_model.dart';

class PictogramImage extends StatelessWidget {
  final PictogramImageBloc _bloc = di.getDependency<PictogramImageBloc>();
  final PictogramModel pictogram;
  final VoidCallback onPressed;
  final _loading = Center(
      child: Container(
          width: 100, height: 100, child: const CircularProgressIndicator()));

  PictogramImage({Key key, @required this.pictogram, @required this.onPressed})
      : super(key: key) {
    _bloc.load(pictogram);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        child: FittedBox(
            fit: BoxFit.contain,
            child: StreamBuilder<Image>(
                stream: _bloc.image,
                builder: (context, snapshot) => snapshot.data ?? _loading)),
      ),
    );
  }
}
