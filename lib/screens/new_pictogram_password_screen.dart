import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/new_pictogram_password_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/style/custom_color.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';

/// Screen for the creation of a pictogram password
class NewPictogramPasswordScreen extends StatelessWidget {
  /// Constructor for the new pictogram password screen
  NewPictogramPasswordScreen(String userName, String displayName)
      : _bloc = di.getDependency<NewPictogramPasswordBloc>() {
    _bloc.initialize(userName, displayName);
  }

  final NewPictogramPasswordBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GirafAppBar(title: 'Ny bruger'),
        body: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: StreamBuilder<bool>(builder: (context, snapshot) {
              return Text('Opret piktogram kode til ${_bloc.displayName}',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: GirafColors.grey,
                      fontSize: 28,
                      fontWeight: FontWeight.bold));
            }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: StreamBuilder<bool>(
              builder: (context, snapshot) {
                return GirafButton(
                  key: const Key('saveButton'),
                  icon: const ImageIcon(AssetImage('assets/icons/save.png')),
                  text: 'Gem bruger',
                  isEnabled: false,
                  onPressed: () {},
                );
              },
            ),
          ),
        ]));
  }
}
