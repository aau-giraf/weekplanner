import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/edit_weekplan_bloc.dart';
import 'package:weekplanner/blocs/new_weekplan_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/input_fields_weekplan.dart';


class EditWeekPlanScreen extends StatelessWidget {
  /// Screen for editing a weekplan.
  /// Requires a [UsernameModel] to be able to save the new weekplan.
  EditWeekPlanScreen({@required UsernameModel user, @required this.weekModel})
      : _bloc = di.getDependency<EditWeekplanBloc>() {
    _bloc.initializeEditBloc(user, weekModel);
  }

  final WeekModel weekModel;
  final EditWeekplanBloc _bloc;

  @override
  Widget build(BuildContext context) {
    final GirafButton editButton = GirafButton(
      icon: const ImageIcon(AssetImage('assets/icons/edit.png')),
      text: 'Gem ændringer',
      isEnabled: false,
      isEnabledStream: _bloc.allInputsAreValidStream,
      onPressed: () { //TODO: lav så denne knap opdaterer og ikek bare gemmer en ny.
        _bloc.editWeekPlan(weekModel).listen((WeekModel response) {
          if (response != null) {
            Routes.pop<WeekModel>(context, response);
          }
        });
      },
    );

    return Scaffold(
      appBar: GirafAppBar(title: 'Rediger ugeplan'),
      body: InputFieldsWeekPlan(
        bloc: _bloc,
        button: editButton,
        weekModel: weekModel,
      ),
    );
  }
}