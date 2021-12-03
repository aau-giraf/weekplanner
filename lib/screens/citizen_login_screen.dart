import 'dart:convert';

import 'package:api_client/models/giraf_user_model.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weekplanner/api/errorcode_translater.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/login_pictogram_bloc.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/loading_spinner_widget.dart';
import 'package:weekplanner/widgets/pictogram_image.dart';
import '../di.dart';
import '../routes.dart';

/// Screen for creating a citizen login
class CitizenLoginScreen extends StatelessWidget {

  /// Constructor for CitizenLoginScreen()
  CitizenLoginScreen(this._authBloc){
    _loginPictogramBloc.reset();
  }

  final ApiErrorTranslater _translator = ApiErrorTranslater();
  final AuthBloc _authBloc;
  final LoginPictogramBloc _loginPictogramBloc = di.getDependency<LoginPictogramBloc>();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool portrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
        appBar: GirafAppBar(
          title: 'Borger login',
        ),
        body: Container(
        width: screenSize.width,
        height: screenSize.height,
        padding: portrait
            ? const EdgeInsets.fromLTRB(50, 0, 50, 0)
            : const EdgeInsets.fromLTRB(200, 0, 200, 8),
        decoration: const BoxDecoration(
          // The background of the login-screen
          image: DecorationImage(
            image: AssetImage('assets/login_screen_background_image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView (
          children: <Widget>[
            Padding(
                padding:
                const EdgeInsets.only(left: 16, top: 6, right: 16, bottom: 2.5),
                child: Container(
                  height: 200,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Skriv pictogram kode',
                      textAlign:TextAlign.center,
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.7),
                          fontSize: 40
                      ),
                    ),
                  ),
                )
            ),
            Padding(
                padding:
                const EdgeInsets.only(left: 16, top: 6, right: 16, bottom: 2.5),
                child: StreamBuilder<List<PictogramModel>>(
                  initialData: const <PictogramModel> [null, null, null, null],
                  stream: _loginPictogramBloc.pictograms,
                  builder: (
                      BuildContext context,
                      AsyncSnapshot<List<PictogramModel>> snapshot) =>
                        snapshot != null ?
                        buildPictogramSelection(context, snapshot) :
                        const Center(child: CircularProgressIndicator()),
                )
            ),
            Padding(
                padding:
                const EdgeInsets.only(left: 16, top: 6, right: 16, bottom: 2.5),
                child: StreamBuilder<List<PictogramModel>>(
                  stream: _loginPictogramBloc.selectedPictograms,
                  initialData: const <PictogramModel> [null, null, null, null],
                  builder: (
                      BuildContext context,
                      AsyncSnapshot<List<PictogramModel>> snapshot) =>
                      snapshot != null ?
                      buildPictogramInput(context, snapshot):
                      const Center(child: CircularProgressIndicator()),
                )
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: GirafButton(
                      key: const Key('loginButton'),
                      icon: const ImageIcon(AssetImage('assets/icons/save.png')),
                      text: 'Login',
                      isEnabled: true,
                      //isEnabledStream: true as Stream<bool>,//TODO should implement stream
                      onPressed: () {
                        if(_loginPictogramBloc.nullInLogin() != true){
                          Routes.pop(context, _loginPictogramBloc.loginString);
                        }
                      },
                    ),
                  ),
                ]
            )
          ],
        )
      )
    );
  }

  ///Builds the selection of pictograms
  ///Return a grid of pictograms
  Column buildPictogramSelection
      (BuildContext context, AsyncSnapshot<List<PictogramModel>> snapshot){
    return Column(
        children: [
          GridView.count(
              crossAxisCount: 8,
              children: List.generate(40, (index) =>
              _loginPictogramBloc.loadingPictograms == false ?
              PictogramImage(
                  pictogram: snapshot.data.elementAt(index),
                  onPressed: () =>
                      _loginPictogramBloc.update(snapshot.data.elementAt(index),
                          _loginPictogramBloc.getNextNull())
              )
                  : Loading()
              ), shrinkWrap: true
          ),
        ]
    );
  }

  ///Builds the the login field
  ///Returns a grid of pictograms or loginFields
  Column buildPictogramInput
      (BuildContext context, AsyncSnapshot<List<PictogramModel>> snapshot) {
    return Column(
        children: [
          GridView.count(
              crossAxisCount: _loginPictogramBloc.loginSize,
              children: List.generate(_loginPictogramBloc.loginSize, (index) =>
              _loginPictogramBloc.loadingPictograms == false
                  && snapshot.data.elementAt(index) != null  ?
              PictogramImage(
                  pictogram: snapshot.data.elementAt(index),
                  onPressed: () => _loginPictogramBloc.update(null, index)
              )
                  : Center(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white70
                    ),
                  ),
                ),
              )
              ), shrinkWrap: true),
        ]
    );
  }
}

///Loading image to display while awaiting pictograms from api
Container Loading(){
  return Container(
      height: 80,
      child: const Center(
          child: CircularProgressIndicator()
      )
  );
}

