import 'package:api_client/models/pictogram_model.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/pictogram_widgets/pictogram_login_widget.dart';

class NewPictogramPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GirafAppBar(title: 'Ny bruger'),
        body: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: StreamBuilder<bool>(builder: (context, snapshot) {
              return const Text('Opret piktogram kode til bruger',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold));
            }),
          ),
          PictogramLogin(const <PictogramModel>[])
        ]));
  }
}
