import 'dart:io';

import 'package:api_client/models/giraf_user_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weekplanner/api/errorcode_translater.dart';
import 'package:weekplanner/blocs/new_citizen_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/style/font_size.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';

/* TODO:
* Preview 1 picture instead of 2 ✔
* Build widgets refactored into 1 widget ✔
* Circle avatar for preview ✔
* Crop picture correctly on both vertical and horizontal ✔
* Reset preview picture ✔
* Upload chosen picture to citizen profile when "Gem borger" is pressed
*   Figure out how pictogrammer is uploaded and stored on save
*
* Display chosen citizen picture in Citizen overview
*
*
* */

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

  Widget _displayImage(File image) {
    return Container(
      //margin: const EdgeInsets.all(10.0),
      child: CircleAvatar(
        key: const Key('WidgetAvatar'),
        radius: 200,
        /*foregroundImage: FileImage(image),
        backgroundImage: const AssetImage('assets/login_screen_background_image.png'),*/
        backgroundImage: FileImage(image),
      ),
    );
  }

  Widget _displayIfNoImage() {
    return Container(
      //margin: const EdgeInsets.all(10.0),
      child: const CircleAvatar(
        radius: 200,
        backgroundImage: AssetImage('assets/login_screen_background_image.png'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    body:
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

          /// Profile preview picture
          Center(
            child: StreamBuilder<File>(
                stream: _bloc.file,
                builder: (BuildContext context, AsyncSnapshot<File> snapshot) =>
                    snapshot.data != null
                        ? _displayImage(snapshot.data)
                        : _displayIfNoImage()),
          ),



/*

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GirafButton(
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

              GirafButton(
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

            ],
          ),


*/




          Row(
            //mainAxisAlignment:,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                /// Add from gallery button
                GirafButton(
                  key: const Key('TilføjFraGalleriButton'),
                  icon: const ImageIcon(AssetImage('assets/icons/gallery.png')),
                  text: 'Tilføj fra galleri',
                  onPressed: _bloc.chooseImageFromGallery,
                  child: StreamBuilder<File>(
                      stream: _bloc.file,
                      builder: (BuildContext context,
                              AsyncSnapshot<File> snapshot) =>
                          snapshot.data != null
                              ? _displayImage(snapshot.data)
                              : _displayIfNoImage()),
                ),


                /// Take picture button
                GirafButton(
                  key: const Key('TagBillede'),
                  icon: const ImageIcon(AssetImage('assets/icons/camera.png')),
                  text: 'Tag billede',
                  onPressed: _bloc.takePictureWithCamera,
                  child: StreamBuilder<File>(
                      stream: _bloc.file,
                      builder: (BuildContext context,
                              AsyncSnapshot<File> snapshot) =>
                          snapshot.data != null
                              ? _displayImage(snapshot.data)
                              : _displayIfNoImage()),
                ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
                GirafButton(
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
            ],
          ),

        ],
      ),
    );
  }
}
