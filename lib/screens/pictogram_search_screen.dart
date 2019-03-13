import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/pictogram_bloc.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/globals.dart';
import 'package:weekplanner/models/pictogram_model.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

class PictogramSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PictogramBloc bloc = PictogramBloc(Globals.api);
    return Scaffold(
        appBar: GirafAppBar(title: "Pictogram"),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: TextField(
                onChanged: bloc.search,
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search),
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
                        return CircularProgressIndicator();
                      }

                      return GridView.count(
                        crossAxisCount: 4,
                        children: snapshot.data.map((PictogramModel gram) {
                          return _buildIcon(context, gram);
                        }).toList(),
                      );
                    }),
              ),
            ),
          ],
        ));
  }

  Widget _buildIcon(BuildContext context, PictogramModel gram) {
    PictogramImageBloc bloc = PictogramImageBloc(Globals.api);

    bloc.load(gram);

    return StreamBuilder<Image>(
      stream: bloc.image,
      builder: (context, snapshot) {
        return Card(
            child: FittedBox(
                fit: BoxFit.contain, child: snapshot.data));
      }
    );
  }
}
