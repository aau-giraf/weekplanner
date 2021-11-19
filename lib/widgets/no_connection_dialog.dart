

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'giraf_notify_dialog.dart';

class NoConnectionDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    showDialog<Center>(
        context: context,
        builder: (BuildContext context) {
          return GirafNotifyDialog(
              title: "Mistet forbindelse",
              description: "Ændringer bliver gemt når du får forbindelse igen");
        });
  }
}
