import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/pictogram_bloc.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/giraf_confirm_dialog.dart';
import 'package:weekplanner/widgets/giraf_notify_dialog.dart';
import 'package:weekplanner/widgets/pictogram_image.dart';
import '../../routes.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/api/api.dart';

class PictogramChoices extends StatelessWidget {
  ///Widget with the possible pictograms in the code and the currently picked
  /// pictograms in the code.
  PictogramChoices({
    @required this.pictogramOptions,
  });

  final Api _api = di.getDependency<Api>();
  /// List of the possible pictograms in the passsword
  final List<PictogramModel> pictogramOptions;

  /// List of currently chosen pictograms
  final PictogramBloc _bloc = di.getDependency<PictogramBloc>();

  void onPressed(){
    return;
  }
  Widget getGarbageStream() {
    return StreamBuilder<List<PictogramModel>>(
        stream: _bloc.pictograms,
        initialData: const <PictogramModel>[],
        builder: (BuildContext context,
            AsyncSnapshot<List<PictogramModel>> snapshot) {
          if (snapshot.hasData) {
            return Column(
                children: <Widget> [
                  Expanded(
                      child: GridView.count(
                          crossAxisCount: 4,
                          children: snapshot.data
                              .map((PictogramModel pictogram)
                          => PictogramImage(
                              pictogram: pictogram,
                              haveRights: true,
                              onPressed: () =>
                                  Routes.pop(context, pictogram)))
                              .toList(),
                      )
                  ),
                  _bloc.loadingPictograms == true
                      ? Container(
                    height: 80,
                    child: const Center(
                        child: CircularProgressIndicator()
                    ),
                  )
                      : Container()
                ]
            );
          } else if (snapshot.hasError) {
            return InkWell(
              key: const Key('timeoutWidget'),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(snapshot.error.toString()),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Stream<List<PictogramModel>> getStream() async*{
    // int receivedValues = 0;
    // List<PictogramModel> list = [];
    // for (int i = 0; receivedValues < 10; i++) {
    //   PictogramModel nextValue;
    //   _api.pictogram.get(i).listen((PictogramModel value) {
    //     if (value != null) {
    //       nextValue = value;
    //       receivedValues++;
    //     }
    //   });
    //   list.add(nextValue);
    // }
    // yield list;
  }
  @override
   Widget build (BuildContext context) {
    // return Column(
    //     children: <Widget>[
          return Flexible(
            fit: FlexFit.loose,
            child:
                Container(
                  height: 500,
                  width: 500,
                  child:
                    StreamBuilder<List<PictogramModel>>(
                        stream: getStream(),
                        initialData: const <PictogramModel>[],
                        /////////////////////////////////////////////////////////////////////////////
                        builder: (BuildContext context,
                            AsyncSnapshot<List<PictogramModel>> snapshot) {
                          return const Text('Hejsa');
                        }
                    )
                )
          // Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 20),
          //     child:
          );
         // ),
         // ),
    // if (false) {
    // return Column(
    // children: <Widget> [
    // Flexible(
    // child: GridView.count(
    // crossAxisCount: 4,
    // children: snapshot.data
    //     .map((PictogramModel pictogram)
    // => PictogramImage(
    // pictogram: pictogram,
    // haveRights: true,
    // onPressed: () =>
    // Routes.pop(context, pictogram)))
    //     .toList(),
    // )
    // ),
    //
    // Container()
    // ]
    // );
    // } else if (snapshot.hasError) {
    // // return InkWell(
    // // key: const Key('timeoutWidget'),
    // // child: Padding(
    // // padding: const EdgeInsets.symmetric(horizontal: 20),
    // // child: Text(snapshot.error.toString()),
    // // ),
    // // );
    //   return const Text('Hejsa');
    // } else {
    // //return const Center(child: CircularProgressIndicator());
    //   return const Text('Hejsa');
    // }
    // }),
    //         ),
    //         //////////////////////////////////////////////////////////////////////////////
    //         ),
        //),
        //   const Text('Hejsa')
        // ]);
    // );
    //);
  }
}