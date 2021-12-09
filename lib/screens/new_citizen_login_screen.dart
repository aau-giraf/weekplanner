import 'package:api_client/models/giraf_user_model.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weekplanner/api/errorcode_translater.dart';
import 'package:weekplanner/blocs/new_citizen_bloc.dart';
import 'package:weekplanner/blocs/login_pictogram_bloc.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/pictogram_image.dart';

import '../di.dart';
import '../routes.dart';

/// Screen for creating a citizen login
class NewCitizenLoginScreen extends StatelessWidget {

  /// Constructor for NewCitizenLoginScreen()
  NewCitizenLoginScreen(this._citizenBloc){
    _citizenLoginBloc.reset();
  }



  final ApiErrorTranslater _translator = ApiErrorTranslater();
  final LoginPictogramBloc _citizenLoginBloc= di.getDependency<LoginPictogramBloc>();
  final NewCitizenBloc _citizenBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GirafAppBar(
          title: 'Lav borger login',
        ),
        body: ListView (
          children: <Widget>[
            Padding(
                padding:
                const EdgeInsets.only(left: 16, top: 6, right: 16, bottom: 2.5),
                child: Container(
                  height: 200,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Opret pictogram kode til borger',
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
                  stream: _citizenLoginBloc.pictograms,
                  builder: (
                      BuildContext context,
                      AsyncSnapshot<List<PictogramModel>> snapshot) =>
                      buildPictogramSelection(context, snapshot),
                )
            ),
            Padding(
                padding:
                const EdgeInsets.only(left: 16, top: 6, right: 16, bottom: 2.5),
                child: StreamBuilder<List<PictogramModel>>(
                  stream: _citizenLoginBloc.selectedPictograms,
                  initialData: const <PictogramModel> [null, null, null, null],
                  builder: (
                      BuildContext context,
                      AsyncSnapshot<List<PictogramModel>> snapshot) =>
                  snapshot != null ?
                  buildPictogramInput(context, snapshot) :
                  const Center(child: CircularProgressIndicator()),
                )
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
                      isEnabled: true,
                      onPressed: () {
                        _citizenBloc.createTrustee()
                            .listen((GirafUserModel result) {
                          if (result != null) {
                            _citizenBloc.createCitizen(_citizenLoginBloc.loginString)
                                .listen((GirafUserModel response) {
                              Routes.pop<GirafUserModel>(context, response);
                              _citizenBloc.resetBloc();
                            }).onError((Object error) =>
                                _translator.catchApiError(error, context));;
                          }
                        }).onError((Object error) =>
                            _translator.catchApiError(error, context));
                      },
                    ),
                  ),
                ]
            )
          ],
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
              _citizenLoginBloc.loadingPictograms == false ?
              PictogramImage(
                  pictogram: snapshot.data.elementAt(index),
                  onPressed: () =>
                      _citizenLoginBloc.update(snapshot.data.elementAt(index),
                      _citizenLoginBloc.getNextNull())
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
          Container(
            decoration: BoxDecoration(
                color: Colors.black26
            ),
            child:GridView.count(
                crossAxisCount: _citizenLoginBloc.loginSize,
                children: List.generate(_citizenLoginBloc.loginSize, (index) =>
                _citizenLoginBloc.loadingPictograms == false
                    && snapshot.data.elementAt(index) != null  ?
                PictogramImage(
                    pictogram: snapshot.data.elementAt(index),
                    onPressed: () => _citizenLoginBloc.update(null, index)
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
          )
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

