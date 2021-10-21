import 'dart:io';
import 'package:api_client/models/pictogram_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weekplanner/blocs/take_image_with_camera_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/style/font_size.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/giraf_notify_dialog.dart';
import 'package:weekplanner/widgets/loading_spinner_widget.dart';
import '../style/custom_color.dart' as theme;

/// Screen for uploading a [PictogramModel] to the server
/// Generic type I used for mocks in testing
// ignore: must_be_immutable
class TakePictureWithCamera extends StatelessWidget {
  /// Default constructor
  TakePictureWithCamera({Key key}) : super(key: key);

  final TakePictureWithCameraBloc _takePictureWithCamera =
  di.getDependency<TakePictureWithCameraBloc>();

  final BorderRadius _imageBorder = BorderRadius.circular(25);
  ///height of screen
  dynamic screenHeight;
  ///width of screen
  dynamic screenWidth;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      appBar: GirafAppBar(title: 'Tilføj fra kamera'),
      body: StreamBuilder<bool>(
          stream: _takePictureWithCamera.isUploading,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            return snapshot.hasData && snapshot.data
                ? const LoadingSpinnerWidget()
                : _buildBody(context);
          }),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      children: <Widget>[
        _buildDefaultText(),
        _buildImageBox(),
        _buildInputField(context),
      ],
      //),
    );
  }

  Widget _buildInputField(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                onChanged: _takePictureWithCamera.setPictogramName,
                decoration: InputDecoration(
                    hintText: 'Piktogram navn',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50))),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: StreamBuilder<String>(
                  stream: _takePictureWithCamera.accessLevel,
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    return DropdownButton<String>(
                      value: snapshot.data,
                      onChanged: (String newValue) {
                        _takePictureWithCamera.setAccessLevel(newValue);
                      },
                      items: <String>['Institution', 'Privat']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    );
                  }),
            ),
          ],
        ),
        Container(
          height: 15,
        ),
        Container(
          width: 250,
          height: 50,
          child: GirafButton(
            key: const Key('SavePictogramButtonKey'),
            icon: const ImageIcon(AssetImage('assets/icons/save.png')),
            text: 'Gem',
            onPressed: () {
              _takePictureWithCamera.createPictogram().listen((PictogramModel p)
              {
                Routes.pop(context, p);
              }, onError: (Object error) {
                _showUploadError(context);
              });
            },
            isEnabledStream: _takePictureWithCamera.isInputValid,
          ),
        ),
      ],
    );
  }

  Widget _buildImageBox() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Container(
          child: FlatButton(
            onPressed: _takePictureWithCamera.takePictureWithCamera,
            child: StreamBuilder<File>(
                stream: _takePictureWithCamera.file,
                builder: (BuildContext context, AsyncSnapshot<File> snapshot) =>
                snapshot.data != null
                    ? _displayImage(snapshot.data)
                    : _displayIfNoImage()),

          ),
        )
    );
  }

  void _showUploadError(BuildContext context) {
    showDialog<Center>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const GirafNotifyDialog(
          title: 'Fejl',
          description: 'Upload af pictogram fejlede.',
        );
      },
    );
  }

  Widget _displayIfNoImage() {
    return Container(
      height: screenHeight / 3,
      width: screenWidth * 0.90,
      decoration: BoxDecoration(
          border: Border.all(
            width: 4,
            color: theme.GirafColors.black,
          ),
          color: theme.GirafColors.white70,
          borderRadius: _imageBorder),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/icons/gallery.png',
            color: theme.GirafColors.black,
            scale: .75,
          ),
          const Text(
            'Tryk for at tage billede med kamera',
            style: TextStyle(color: theme.GirafColors.black,
                fontSize: GirafFont.medium),
          )
        ],
      ),
    );
  }

  Widget _buildDefaultText() {
    return const Padding(
        padding: EdgeInsets.only(
          bottom: 10,
        ),
        child: Text(
          'Tag billede med kamera',
          style: TextStyle(color: theme.GirafColors.black,
              fontSize: GirafFont.medium),
          textAlign: TextAlign.center,
        ));
  }

  Widget _displayImage(File image) {
    return Container(
      child: Image.file(image),
      decoration: BoxDecoration(
        borderRadius: _imageBorder,
      ),
    );
  }
}