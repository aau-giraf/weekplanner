import 'dart:async';

import 'package:api_client/models/displayname_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/pictogram_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/take_picture_with_camera_screen.dart';
import 'package:weekplanner/screens/upload_image_from_phone_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/loading_spinner_widget.dart';
import 'package:weekplanner/widgets/pictogram_image.dart';
import '../style/custom_color.dart' as theme;

const int _debounceTime = 250;

/// Screen for searching for pictograms
///
/// This screen will return `null` back is pressed, otherwise it will return the
/// chosen pictogram.
class PictogramSearch extends StatelessWidget {

  /// Constructor
  PictogramSearch({@required this.user});

  final PictogramBloc _bloc = di.getDependency<PictogramBloc>();

  /// The current authenticated user
  final DisplayNameModel user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GirafAppBar(title: 'Piktogram'),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: _bloc.search,
                      decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.search),
                          hintText: 'Søg her...',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50))),
                    ),
                  ),
                ],
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
                      if (snapshot.hasData) {
                        return Column(
                          children: <Widget> [
                            Expanded(
                              child: GridView.count(
                                crossAxisCount: 1,
                                children: snapshot.data
                                    .map((PictogramModel pictogram) => PictogramImage(
                                    pictogram: pictogram,
                                    haveRights: user == null || pictogram.userId
                                        == null ? false :
                                    pictogram.userId == user.id,
                                    onPressed: () =>
                                        Routes.pop(context, pictogram))).toList(),
                                controller: _bloc.sc
                            )
                            ),
                            _bloc.loadingPictograms == true ? Container(
                              height: 80,
                              child: const Center(child: CircularProgressIndicator()),
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
                    }),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: theme.GirafColors.amber,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GirafButton(
                icon: const ImageIcon(AssetImage('assets/icons/gallery.png')),
                text: 'Tilføj fra galleri',
                onPressed: () async {
                  await Routes.push(context, UploadImageFromPhone());
                },
              ),
              GirafButton(
                  icon: const ImageIcon(AssetImage('assets/icons/camera.png')),
                  text: 'Tag billede',
                  onPressed: () async {
                    await Routes.push(context, TakePictureWithCamera());
                  }
              ),
            ],
          ),
        ));
  }
}
