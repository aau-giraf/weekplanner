import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/giraf_confirm_dialog.dart';
import '../routes.dart';

/// Widget for rendering pictogram models as images
class PictogramImage extends StatelessWidget {
  /// Renders [pictogram] model as image
  ///
  /// The image url is extracted from the [pictogram] provided, and an
  /// authenticated request is then made to the back-end to load the image.
  ///
  /// The [onPressed] function will be called every time the image is pressed
  PictogramImage({
    Key key,
    @required this.pictogram,
    @required this.onPressed,
    this.haveRights = false
  }) : super(key: key) {
    _bloc.load(pictogram);
  }

  /// Provided Pictogram to load
  final PictogramModel pictogram;
  /// haveRights returns true if the current active user have the rights to the
  /// pictogram.
  final bool haveRights;

  /// The provided callback function which will be called on
  /// every press of the image
  final VoidCallback onPressed;

  final PictogramImageBloc _bloc = di.getDependency<PictogramImageBloc>();
  final Widget _loading = Center(
      child: Container(
          width: 100, height: 100, child: const CircularProgressIndicator()
      )
  );

  Future<Center> _confirmDeleteDialog(
      BuildContext context
      ){
    return showDialog<Center>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return GirafConfirmDialog(
              title: 'Slet piktogram',
              description: 'Vil du slette det markerede piktogram?',
              confirmButtonText: 'Slet',
              confirmButtonIcon: const ImageIcon(AssetImage('assets/icons/delete.png')),
              confirmOnPressed: (){
                _bloc.delete(pictogram);
                Routes.pop(context);
              }
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        child: FittedBox(
            fit: BoxFit.contain,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Stack(
              children: <Widget>[
                StreamBuilder<Image>(
                  stream: _bloc.image,
                  builder:
                      (BuildContext context, AsyncSnapshot<Image> snapshot) =>
                          snapshot.data ?? _loading),
                GirafButton(
                  onPressed: () {_confirmDeleteDialog(context);},
                  icon: const ImageIcon(AssetImage('assets/icons/gallery.png')),
                  text: 'Slet',
                  isEnabled: haveRights,
                ),
              ]
            )
      ),

      )
    )
    );
  }
}
