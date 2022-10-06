import 'dart:io';

import 'package:api_client/models/giraf_user_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weekplanner/api/errorcode_translater.dart';
import 'package:weekplanner/blocs/new_citizen_bloc.dart';
import 'package:weekplanner/blocs/take_image_with_camera_bloc.dart';
import 'package:weekplanner/blocs/upload_from_gallery_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/style/font_size.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';

/// Screen for creating a new citizen
class NewCitizenScreen extends StatelessWidget {
  /// Constructor for the NewCitizenScreen()
  NewCitizenScreen() : _bloc = di.getDependency<NewCitizenBloc>() {
    _bloc.initialize();
  }
  ///Variable representing the screen height
  dynamic screenHeight;

  ///Variable representing the screen width
  dynamic screenWidth;

  final ApiErrorTranslater _translator = ApiErrorTranslater();
  final NewCitizenBloc _bloc;

  final TakePictureWithCameraBloc _takePictureWithCamera =
    di.getDependency<TakePictureWithCameraBloc>();

  final UploadFromGalleryBloc _uploadFromGallery =
    di.getDependency<UploadFromGalleryBloc>();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: GirafAppBar(
        title: 'Ny borger',
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 16, top: 6, right: 16, bottom: 2.5),
            child: StreamBuilder<bool>(
                stream: _bloc.validDisplayNameStream,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  return TextFormField(
                    key: const Key('displayNameField'),
                    decoration: InputDecoration(
                      border:
                          const OutlineInputBorder(borderSide: BorderSide()),
                      labelText: 'Navn',
                      errorText: (snapshot?.data == true) &&
                              _bloc.displayNameController.value != null
                          ? null
                          : 'Navn skal udfyldes',
                    ),
                    onChanged: _bloc.onDisplayNameChange.add,
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
            child: StreamBuilder<bool>(
                stream: _bloc.validUsernameStream,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  return TextFormField(
                    key: const Key('usernameField'),
                    decoration: InputDecoration(
                      border:
                          const OutlineInputBorder(borderSide: BorderSide()),
                      labelText: 'Brugernavn',
                      errorText: (snapshot?.data == true) &&
                              _bloc.usernameController.value != null
                          ? null
                          // cant make it shorter because of the string
                          // ignore: lines_longer_than_80_chars
                          : 'Brugernavn er tomt eller indeholder et ugyldigt tegn',
                    ),
                    onChanged: _bloc.onUsernameChange.add,
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
            child: StreamBuilder<bool>(
                stream: _bloc.validPasswordStream,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  return TextFormField(
                    key: const Key('passwordField'),
                    decoration: InputDecoration(
                      border:
                          const OutlineInputBorder(borderSide: BorderSide()),
                      labelText: 'Kodeord',
                      errorText: (snapshot?.data == true) &&
                              _bloc.passwordController.value != null
                          ? null
                          // cant make it shorter because of the string
                          // ignore: lines_longer_than_80_chars
                          : 'Kodeord må ikke indeholde mellemrum eller være tom',
                    ),
                    onChanged: _bloc.onPasswordChange.add,
                    obscureText: true,
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
            child: StreamBuilder<bool>(
                stream: _bloc.validPasswordVerificationStream,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  return TextFormField(
                    key: const Key('passwordVerifyField'),
                    decoration: InputDecoration(
                      border:
                          const OutlineInputBorder(borderSide: BorderSide()),
                      labelText: 'Gentag kodeord',
                      errorText: (snapshot?.data == true)
                          ? null
                          : 'Kodeord skal være ens',
                    ),
                    onChanged: _bloc.onPasswordVerifyChange.add,
                    obscureText: true,
                  );
                }),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            //child: Text('Profil billede af borger (valgfri):'),
            child: AutoSizeText(
              'Profil billede af borger (valgfri):',
              style: TextStyle(fontSize: GirafFont.small),
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.all(10.0),
              width: screenWidth / 2,
              height: screenHeight / 2,
              child: const CircleAvatar(
                key: Key('WidgetAvatar'),
                radius: 1,
                foregroundImage: NetworkImage('https://docs.flutter.dev/assets/images/shared/brand/flutter/logo/flutter-lockup.png'),
                backgroundImage: AssetImage('assets/login_screen_background_image.png'),
              ),
            ),
          ),
          Row(
            //mainAxisAlignment:,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: GirafButton(
                  key: const Key('TilføjFraGalleriButton'),
                  icon: const ImageIcon(AssetImage('assets/icons/gallery.png')),
                  text: 'Tilføj fra galleri',
                  onPressed: _uploadFromGallery.chooseImageFromGallery,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: GirafButton(
                  key: const Key('TagBillede'),
                  icon: const ImageIcon(AssetImage('assets/icons/camera.png')),
                  text: 'Tag billede',
                  onPressed: _takePictureWithCamera.takePictureWithCamera,
                  /*child: StreamBuilder<File>(
                      stream: _takePictureWithCamera.file,
                      builder: (BuildContext context,
                              AsyncSnapshot<File> snapshot) =>
                          snapshot.data != null
                              ? _displayImage(snapshot.data)
                              : _displayIfNoImage()),*/
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: GirafButton(
                  key: const Key('saveButton'),
                  icon: const ImageIcon(AssetImage('assets/icons/save.png')),
                  text: 'Gem borger',
                  isEnabled: false,
                  isEnabledStream: _bloc.allInputsAreValidStream,
                  onPressed: () {
                    _bloc.createCitizen().listen((GirafUserModel response) {
                      if (response != null) {
                        Routes.pop<GirafUserModel>(context, response);
                        _bloc.resetBloc();
                      }
                    }).onError((Object error) =>
                        _translator.catchApiError(error, context));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
