import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section.dart';
import 'package:weekplanner/widgets/settings_widgets/'
    'settings_section_checkboxButton.dart';
import 'package:weekplanner/widgets/settings_widgets/'
    'settings_section_item.dart';

import '../../di.dart';
import '../../routes.dart';

class ChangePasswordUsernameScreen extends StatelessWidget {
  ChangePasswordUsernameScreen(DisplayNameModel user) : _user = user {}

  final DisplayNameModel _user;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
