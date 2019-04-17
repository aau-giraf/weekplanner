import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:weekplanner/blocs/pictogram_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/pictogram_image.dart';

/// Screen for searching for pictograms
///
/// This screen will return `null` back is pressed, otherwise it will return the
/// chosen pictogram.
class PictogramSearch extends StatelessWidget {
  final PictogramBloc _bloc = di.getDependency<PictogramBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GirafAppBar(title: 'Piktogram'),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: TextField(
                onChanged: _bloc.search,
                decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.search),
                    hintText: 'Søg her...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50))),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: StreamBuilder<Tuple2<List<PictogramModel>, TimeoutException>>(
                    stream: _bloc.pictograms,
                    initialData: Tuple2<List<PictogramModel>, TimeoutException>(null, null),
                    builder: (BuildContext context,
                        AsyncSnapshot<Tuple2<List<PictogramModel>, TimeoutException>> snapshot) {

                      if(snapshot.data != null && snapshot.data.item2 != null){
                        print("hej");
                        return Center(child: Text(snapshot.data.item2.message));
                      }
                      if (snapshot.data == null) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      else if( snapshot.data != null && snapshot.data.item1 != null) {
                        return GridView.count(
                          crossAxisCount: 4,
                          children: snapshot.data.item1
                              .map((PictogramModel pictogram) =>
                              PictogramImage(
                                  pictogram: pictogram,
                                  onPressed: () =>
                                      Routes.pop(context, pictogram)))
                              .toList(),
                        );
                      }
                      else
                        return new Container();
                    }),
              ),
            ),
          ],
        ));
  }
}
