import 'package:api_client/models/username_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

class WeekplanColorSelectorScreen extends StatelessWidget {

  final UsernameModel _user;

  WeekplanColorSelectorScreen(UsernameModel user){
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GirafAppBar(
          title: UsernameModel _user.name + ': indstillinger',
        ),

    );
  }

}