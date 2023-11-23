import 'dart:io';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/api/errorcode_translator.dart';
import 'package:weekplanner/blocs/new_citizen_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/new_pictogram_password_screen.dart';
import 'package:weekplanner/style/font_size.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';

/// Role names for Weekplanner
enum Roles {
  /// Guardian role
  guardian,
  /// Trustee  role
  trustee,
  /// Citizen role
  citizen }



/// Screen for creating a new citizen
// ignore: must_be_immutable
class NewCitizenScreen extends StatefulWidget {
  /// Constructor for the NewCitizenScreen()
  NewCitizenScreen() : _bloc = di.get<NewCitizenBloc>() {
    _bloc.initialize();
  }

  ///Variable representing the screen height
  dynamic screenHeight;

  ///Variable representing the screen width
  dynamic screenWidth;

  final NewCitizenBloc _bloc;

  Widget _displayImage(File image) {
    return Container(
      //margin: const EdgeInsets.all(10.0),
      child: CircleAvatar(
        key: const Key('WidgetAvatar'),
        radius: 200,
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
  _NewCitizenScreenState createState() => _NewCitizenScreenState();
}

class _NewCitizenScreenState extends State<NewCitizenScreen> {
  final ApiErrorTranslator _translator = ApiErrorTranslator();
  Roles _role = Roles.citizen;

  void previousRoute(GirafUserModel response) {
    Routes().pop<GirafUserModel>(context, response);
    widget._bloc.resetBloc();
  }

  @override
  Widget build(BuildContext context) {
    widget.screenHeight = MediaQuery.of(context).size.height;
    widget.screenWidth = MediaQuery.of(context).size.width;
    final bool portrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            /// The blue left part of screen
            Expanded(
              flex: 1,
              child: Container(

                child: Stack(children: <Widget>[

                  Image.asset(
                    'assets/icons/giraf_orange_long.png',
                    repeat: ImageRepeat.repeat,
                    height: widget.screenHeight,
                    fit: BoxFit.cover,
                  ),
                  
                ],
                ),
              ),
            ),
            /// The white middle of the screen
            Expanded(
              flex: 7,
              child: Container(
                width: widget.screenWidth,
                height: widget.screenHeight,
                padding: portrait
                    ? const EdgeInsets.fromLTRB(0, 0, 0, 0)
                    : const EdgeInsets.fromLTRB(0, 20, 0,0),
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: widget.screenWidth,
                      height: 90,
                      
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
                        child: Row(
                        children: <Widget>[
                        Container(
                          child: Column(children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                key: Key('BackArrow'),
                                padding: portrait
                                    ? const EdgeInsets.fromLTRB(0, 0, 0, 0)
                                    : const EdgeInsets.fromLTRB(0, 0, 50, 0),
                                color: Colors.black,
                                icon: Icon(Icons.arrow_back, size: 55),
                                onPressed: () {
                                  Navigator.pop(context); // Go back to previous page
                                },
                              ),
                            ),
                          ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                        child: Text(
                          'Opret Bruger',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: GirafFont.headline, fontFamily: 'Quicksand-Bold'),
                          ),
                        ),

                        
                        ],
                      ),
                      ),
                    ),
                    // ! Scrollable parts
                    Container(
                      width: widget.screenWidth,
                      height: widget.screenHeight,
                      padding: EdgeInsets.only(left: 0, top: 100, 
                                                        right: 0, bottom: 0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding:
                                  EdgeInsets.only(left: widget.screenWidth * 0.10, top: 20, 
                                                        right: widget.screenWidth * 0.10, bottom: 2.5),
                              child: StreamBuilder<bool>(
                                  stream: widget._bloc.validDisplayNameStream,
                                  builder: 
                                    (BuildContext context, AsyncSnapshot<bool> snapshot) {
                                    return TextFormField(
                                      key: const Key('displayNameField'),
                                      decoration: InputDecoration(
                                        border:
                                            const OutlineInputBorder(borderSide: BorderSide()),
                                        labelText: 'Navn',
                                        errorText: (snapshot?.data == true) &&
                                                widget._bloc.displayNameController.value != null
                                            ? null
                                            : 'Navn skal udfyldes',
                                      ),
                                      onChanged: widget._bloc.onDisplayNameChange.add,
                                    );
                                  }),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: widget.screenWidth * 0.10, top: 6, 
                                                        right: widget.screenWidth * 0.10, bottom: 2.5),
                              child: StreamBuilder<bool>(
                                  stream: widget._bloc.validUsernameStream,
                                  builder: 
                                    (BuildContext context, AsyncSnapshot<bool> snapshot) {
                                    return TextFormField(
                                      key: const Key('usernameField'),
                                      decoration: InputDecoration(
                                        border:
                                            const OutlineInputBorder(borderSide: BorderSide()),
                                        labelText: 'Brugernavn',
                                        errorText: (snapshot?.data == true) &&
                                                widget._bloc.usernameController.value != null
                                            ? null
                                            // cant make it shorter because of the string
                                            // ignore: lines_longer_than_80_chars
                                            : 'Brugernavn er tomt eller indeholder et ugyldigt tegn',
                                      ),
                                      onChanged: widget._bloc.onUsernameChange.add,
                                    );
                                  }),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text('Brug piktogram kode?', style: TextStyle(fontWeight: FontWeight.bold)
                                ),
                                Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                                    child: StreamBuilder<Object>(
                                        stream: null,
                                        builder: (BuildContext context,
                                            AsyncSnapshot<Object> snapshot) {
                                          return Switch.adaptive(
                                              key: const Key('usePictogramSwitch'),
                                              value: widget
                                                  ._bloc.usePictogramPasswordController.value,
                                              onChanged: _role == Roles.citizen
                                                  ? (bool value) {
                                                      setState(() {
                                                        widget.
                                                        _bloc.onUsePictogramPasswordChange
                                                            .add(value);
                                                      });
                                                    }
                                                  : null);
                                        }))
                              ],
                            ),
                            // ! Passsword
                            Padding(
                              padding: EdgeInsets.only(left: widget.screenWidth * 0.10, top: 6, 
                                                        right: widget.screenWidth * 0.10, bottom: 2.5),
                              child: StreamBuilder<bool>(
                                  stream: widget._bloc.validPasswordStream,
                                  builder: 
                                    (BuildContext context, AsyncSnapshot<bool> snapshot) {
                                    return Visibility(
                                      visible: !widget._bloc.
                                                usePictogramPasswordController.value,
                                      child: TextFormField(
                                        key: const Key('passwordField'),
                                        enabled:
                                            !widget._bloc.usePictogramPasswordController.value,
                                        decoration: InputDecoration(
                                          border:
                                            const OutlineInputBorder(borderSide: BorderSide()),
                                          labelText: 'Kodeord',
                                          errorText: (snapshot?.data == true) &&
                                                  widget._bloc.passwordController.value != null
                                              ? null
                                              // cant make it shorter because of the string
                                              // ignore: lines_longer_than_80_chars
                                              : 'Kodeord må ikke indeholde mellemrum eller være tom',
                                        ),
                                        onChanged: widget._bloc.onPasswordChange.add,
                                        obscureText: true,
                                      ),
                                    );
                                  }),
                            ),
                            // ! Repeat password
                            Padding(
                              padding: EdgeInsets.only(left: widget.screenWidth * 0.10, top: 6, 
                                                        right: widget.screenWidth * 0.10, bottom: 2.5),
                              child: StreamBuilder<bool>(
                                  stream: widget._bloc.validPasswordVerificationStream,
                                  builder: 
                                    (BuildContext context, AsyncSnapshot<bool> snapshot) {
                                    return Visibility(
                                      visible: 
                                        !widget._bloc.usePictogramPasswordController.value,
                                      child: TextFormField(
                                        key: const Key('passwordVerifyField'),
                                        enabled:
                                            !widget._bloc.usePictogramPasswordController.value,
                                        decoration: InputDecoration(
                                          border:
                                              const 
                                              OutlineInputBorder(borderSide: BorderSide()),
                                          labelText: 'Gentag kodeord',
                                          errorText: (snapshot?.data == true)
                                              ? null
                                              : 'Kodeord skal være ens',
                                        ),
                                        onChanged: widget._bloc.onPasswordVerifyChange.add,
                                        obscureText: true,
                                      ),
                                    );
                                  }),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: widget.screenWidth * 0.10, top: 20, 
                                                        right: widget.screenWidth * 0.10, bottom: 2.5),
                              //child: Text('Profil billede af borger (valgfri):'),
                              child: AutoSizeText(
                                'Profil billede af borger (valgfri):',
                                style: TextStyle(fontSize: GirafFont.small, fontWeight: FontWeight.bold),
                              ),
                            ),
                      
                            /// Profile preview picture
                            Padding(
                              padding: EdgeInsets.only(left: widget.screenWidth * 0.10, top: 20, 
                                                        right: widget.screenWidth * 0.10, bottom: 2.5), 
                              child: StreamBuilder<File>(
                                  stream: widget._bloc.file,
                                  builder: 
                                    (BuildContext context, AsyncSnapshot<File> snapshot) =>
                                      snapshot.data != null
                                          ? widget._displayImage(snapshot.data)
                                          : widget._displayIfNoImage()),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: widget.screenWidth * 0.10, top: 20, 
                                                        right: widget.screenWidth * 0.10, bottom: 2.5),
                              child: Row(
                                //mainAxisAlignment:,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        
                                    /// ! Add from gallery button
                                    child: GirafButton(
                                      key: const Key('TilføjFraGalleriButton'),
                                      icon: const ImageIcon(AssetImage('assets/icons/gallery.png')),
                                      text: 'Tilføj fra galleri',
                                      onPressed: widget._bloc.chooseImageFromGallery,
                                      child: StreamBuilder<File>(
                                          stream: widget._bloc.file,
                                          builder: (BuildContext context,
                                                  AsyncSnapshot<File> snapshot) =>
                                              snapshot.data != null
                                                  ? widget._displayImage(snapshot.data)
                                                  : widget._displayIfNoImage()),
                                    ),  
                                  ),
                                ],
                              ),
                            ),
                            // ! Save User Button
                            Padding(
                              padding: EdgeInsets.only(left: widget.screenWidth * 0.10, top: 30, 
                                                        right: widget.screenWidth * 0.10, bottom: 2.5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 10, horizontal: 0), // padding to other row above
                                    child: GirafButton(
                                      key: const Key('saveButton'),
                                      icon: const ImageIcon(AssetImage('assets/icons/save.png')),
                                      text: 'Gem bruger',
                                      isEnabled: false,
                                      isEnabledStream: widget._bloc.allInputsAreValidStream,
                                      onPressed: () {
                                        widget._bloc
                                            .createCitizen()
                                            .listen((GirafUserModel response) {
                                          if (response != null) {
                                            previousRoute(response);
                                          }
                                        }).onError((Object error) =>
                                                _translator.catchApiError(error, context));
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10, // Space between buttons
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    // ! Next Button
                                    child: GirafButton(
                                      key: const Key('nextButton'),
                                      icon: const ImageIcon(AssetImage('assets/icons/accept.png')),
                                      text: 'Videre',
                                      isEnabled: false,
                                      isEnabledStream: widget._bloc.validUsePictogramStream,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          // ignore: always_specify_types
                                          MaterialPageRoute<void>(
                                              builder: (BuildContext context) =>
                                                  NewPictogramPasswordScreen(
                                                      widget._bloc.usernameController.value,
                                                      widget._bloc.displayNameController.value,
                                                      widget._bloc.encodePicture
                                                        (widget._bloc.fileController.value),
                                        )));
                                      },
                                    ),
                                  ),
                                ],
                              ),            
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  
                ),
              ),
            ),
            /// The blue right part of screen
            Expanded(
                flex: 1,
                child: Container(
                  height: widget.screenHeight,
                  child: Image.asset(
                    'assets/icons/giraf_orange_long.png',
                    repeat: ImageRepeat.repeat,
                    fit: BoxFit.cover,
                  ),
                )
            ),
          ]
      ),
    ); // Scaffold ends here
  }
}
