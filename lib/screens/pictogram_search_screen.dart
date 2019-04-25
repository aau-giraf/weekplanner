import 'package:flutter/material.dart';
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
                child: StreamBuilder<List<PictogramModel>>(
                    stream: _bloc.pictograms,
                    initialData: const <PictogramModel>[],
                    builder: (BuildContext context,
                        AsyncSnapshot<List<PictogramModel>> snapshot) {

                      if(snapshot.hasData) {
                        return  GridView.count(
                          crossAxisCount: 4,
                          children: snapshot.data
                              .map((PictogramModel pictogram) =>
                              PictogramImage(
                                  pictogram: pictogram,
                                  onPressed: () =>
                                      Routes.pop(context, pictogram)))
                              .toList(),
                        );

                      }
                      else if(snapshot.hasError){
                        return InkWell(
                          key: Key("NoResult"),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text("Søgningen gav ingen resultater. Tjek internetforbindelsen."),
                          ),
                          onTap: () => _bloc.search,
                        );
                      }
                      else {
                        return const Center(
                            child: CircularProgressIndicator());
                      }
                    }),
              ),
            ),
          ],
        ));
  }
}
