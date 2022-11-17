import 'package:api_client/models/giraf_user_model.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/api/errorcode_translater.dart';
import 'package:weekplanner/blocs/new_pictogram_password_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/style/custom_color.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/pictogram_widgets/pictogram_login_widget.dart';
import 'package:weekplanner/widgets/pictogram_widgets/pictogram_password_choices.dart';

/// Screen for the creation of a pictogram password
class NewPictogramPasswordScreen extends StatelessWidget {
  /// Constructor for the new pictogram password screen
  NewPictogramPasswordScreen(String userName, String displayName)
      : _bloc = di.getDependency<NewPictogramPasswordBloc>() {
    _bloc.initialize(userName, displayName);
  }

  final NewPictogramPasswordBloc _bloc;

  final ApiErrorTranslater _translator = ApiErrorTranslater();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GirafAppBar(title: 'Ny bruger'),
        body: ListView(shrinkWrap: true, children: <Widget>[
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
                  isEnabled: true,
                  onPressed: () {
                    _bloc.createCitizen().listen((GirafUserModel response) {
                      if (response != null) {
                        Routes.pop(context, response);
                        Routes.pop(context, response);

                        // Maybe not needed, as the
                        // initialize method already resets
                        _bloc.reset();
                      }
                    }).onError((Object error) =>
                        _translator.catchApiError(error, context));
                  },
                );
              },
            ),
          ),
          Flexible(child: PictogramChoices())
        ]));
  }
}
