import 'package:api_client/models/username_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

class WeekplanColorSelectorScreen extends StatelessWidget {
  ///Constructor
  WeekplanColorSelectorScreen({@required UsernameModel user}) : _user = user {
    //_settingsBloc.loadSettings(_user);
  }

  final UsernameModel _user;


@override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GirafAppBar(
          title: _user.name + ': indstillinger',
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
    );
  }

}