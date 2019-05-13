import 'dart:io';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/upload_from_gallery_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/loading_spinner_widget.dart';

/// Screen for uploading a [PictogramModel] to the server
class UploadImageFromPhone extends StatelessWidget {
  /// Default constructor
  UploadImageFromPhone({Key key}) : super(key: key);

  final UploadFromGalleryBloc _uploadFromGallery =
      di.getDependency<UploadFromGalleryBloc>();

  final BorderRadius _imageBorder = BorderRadius.circular(25);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GirafAppBar(title: 'Tilføj fra galleri'),
      body: StreamBuilder<bool>(
          stream: _uploadFromGallery.isUploading,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            return snapshot.hasData && snapshot.data
                ? const LoadingSpinnerWidget()
                : _buildBody();
          }),
    );
  }

  Padding _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildDefaultText(),
          _buildImageBox(),
          _buildInputField(),
        ],
      ),
    );
  }

  Row _buildInputField() {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            onChanged: _uploadFromGallery.setPictogramName,
            decoration: InputDecoration(
                hintText: 'Piktogram navn',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50))),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 20),
          child: StreamBuilder<String>(
              stream: _uploadFromGallery.accessLevel,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                return DropdownButton<String>(
                  value: snapshot.data,
                  onChanged: (String newValue) {
                    _uploadFromGallery.setAccessLevel(newValue);
                  },
                  items: <String>['Public', 'Private']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                );
              }),
        ),
        GirafButton(
          icon: const ImageIcon(AssetImage('assets/icons/save.png')),
          onPressed: _uploadFromGallery.createPictogram,
          isEnabledStream: _uploadFromGallery.isInputValid,
        ),
      ],
    );
  }

  Widget _buildImageBox() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                width: 4,
                color: Colors.black,
              ),
              color: Colors.black,
              borderRadius: _imageBorder),
          child: _getAndDisplayPicture(),
        ),
      ),
    );
  }

  Widget _getAndDisplayPicture() {
    return Container(
        child: FlatButton(
      onPressed: _uploadFromGallery.chooseImageFromGallery,
      child: StreamBuilder<File>(
        stream: _uploadFromGallery.file,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) =>
            snapshot.data != null
                ? _displayImage(snapshot.data)
                : const Icon(Icons.add_to_photos),
      ),
    ));
  }

  Widget _buildDefaultText() {
    return const Padding(
        padding: EdgeInsets.only(
          bottom: 10,
        ),
        child: Text(
          'Tryk for at vælge et billed fra gallariet',
          style: TextStyle(color: Colors.black, fontSize: 25),
          textAlign: TextAlign.center,
        ));
  }

  Widget _displayImage(File image) {
    return Container(
      child: Image.file(image),
      decoration: BoxDecoration(borderRadius: _imageBorder),
    );
  }
}
