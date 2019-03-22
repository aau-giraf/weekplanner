import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/pictogram_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/pictogram_model.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/pictogram_image.dart';

class PictogramSearch extends StatelessWidget {
  final PictogramBloc bloc = di.getDependency<PictogramBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GirafAppBar(title: "Pictogram"),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: TextField(
                onChanged: bloc.search,
                decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.search),
                    hintText: "Søg her...",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50))),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: StreamBuilder<List<PictogramModel>>(
                    stream: bloc.pictograms,
                    initialData: [],
                    builder: (BuildContext context,
                        AsyncSnapshot<List<PictogramModel>> snapshot) {
                      if (snapshot.data == null) {
                        return const Center(
                            child: const CircularProgressIndicator());
                      }

                      return GridView.count(
                        crossAxisCount: 4,
                        children: snapshot.data
                            .map((PictogramModel pictogram) => PictogramImage(
                                pictogram: pictogram,
                                onPressed: () =>
                                    Routes.pop(context, pictogram)))
                            .toList(),
                      );
                    }),
              ),
            ),
          ],
        ));
  }
}
