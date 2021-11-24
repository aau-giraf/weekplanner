import 'package:api_client/models/giraf_user_model.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weekplanner/api/errorcode_translater.dart';
import 'package:weekplanner/blocs/new_citizen_bloc.dart';
import 'package:weekplanner/blocs/new_citizen_login_bloc.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/pictogram_image.dart';

import '../di.dart';
import '../routes.dart';

/// Screen for creating a citizen login
class NewCitizenLoginScreen extends StatelessWidget {

  /// Constructor for NewCitizenLoginScreen()
  NewCitizenLoginScreen(this._citizenBloc)
      : _citizenLoginBloc = di.getDependency<LoginPictogramBloc>();



  final ApiErrorTranslater _translator = ApiErrorTranslater();
  final LoginPictogramBloc _citizenLoginBloc;
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
                  initialData: const <PictogramModel> [],
                  builder: (
                      BuildContext context,
                      AsyncSnapshot<List<PictogramModel>> snapshot) =>
                      buildPictogramInput(context, snapshot),
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
                      isEnabled: false,
                      isEnabledStream: _citizenBloc.allInputsAreValidStream,
                      onPressed: () {
                        _citizenBloc.createCitizen()
                            .listen((GirafUserModel response) {
                          if (response != null) {
                            Routes.pop<GirafUserModel>(context, response);
                            _citizenBloc.resetBloc();
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
              crossAxisCount: 6,
              children: List.generate(24, (index) =>
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
          GridView.count(
              crossAxisCount: _citizenLoginBloc.loginSize,
              children: List.generate(_citizenLoginBloc.loginSize, (index) =>
              _citizenLoginBloc.loadingPictograms == false
                  && snapshot.data.elementAt(index) != null  ?
              PictogramImage(
                  pictogram: snapshot.data.elementAt(index),
                  onPressed: () => _citizenLoginBloc.update(null, index)
              )
                  : Center(
                child: Text(
                  'Login field $index',
                  style: Theme.of(context).textTheme.headline5,),
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

