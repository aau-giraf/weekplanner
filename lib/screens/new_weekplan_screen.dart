import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/week_name_model.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/new_weekplan_bloc.dart';
import 'package:weekplanner/blocs/weekplan_selector_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/giraf_confirm_dialog.dart';
import 'package:weekplanner/widgets/input_fields_weekplan.dart';

/// Screen for creating a new weekplan.
class NewWeekplanScreen extends StatelessWidget {
  /// Screen for creating a new weekplan.
  /// Requires a [UsernameModel] to be able to save the new weekplan.
  NewWeekplanScreen(UsernameModel user)
      : _bloc = di.getDependency<NewWeekplanBloc>() {
    _bloc.initialize(user);
  }

  final NewWeekplanBloc _bloc;

  @override
  Widget build(BuildContext context) {
    final GirafButton saveButton = GirafButton(
      icon: const ImageIcon(AssetImage('assets/icons/save.png')),
      key: const Key('NewWeekplanSaveBtnKey'),
      text: 'Gem ugeplan',
      isEnabled: false,
      isEnabledStream: _bloc.allInputsAreValidStream,
      onPressed: () => _bloc.saveWeekplan(context).then(
        (WeekModel newWeekPlan) {
          if (newWeekPlan != null) {
            Routes.pop<WeekModel>(context, newWeekPlan);
          }
        },
      ),
    );

    return Scaffold(
      appBar: GirafAppBar(title: 'Ny ugeplan'),
      body: InputFieldsWeekPlan(
        bloc: _bloc,
        button: saveButton,
      ),
    );
  }
}
