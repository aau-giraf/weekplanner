import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/week_name_model.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/copy_weekplan_bloc.dart';
import 'package:weekplanner/blocs/new_weekplan_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/input_fields_weekplan.dart';

/// Screen for creating a new weekplan.
class CopyResolveScreen extends StatelessWidget {
  /// Screen for creating a new weekplan.
  /// Requires a [UsernameModel] to be able to save the new weekplan.
  CopyResolveScreen({
    @required this.currentUser,
    @required this.weekModel,
    this.copyBloc,
  }) : _bloc = di.getDependency<NewWeekplanBloc>() {
    _bloc.initialize(currentUser);
  }

  final NewWeekplanBloc _bloc;

  /// An instance of the copyWeekplanBloc.
  final CopyWeekplanBloc copyBloc;

  /// The user that is being copied from
  final UsernameModel currentUser;

  /// The weekModel that is being copied
  final WeekModel weekModel;

  @override
  Widget build(BuildContext context) {
    final GirafButton saveButton = GirafButton(
      icon: const ImageIcon(AssetImage('assets/icons/save.png')),
      key: const Key('NewWeekplanSaveBtnKey'),
      text: 'Gem ugeplan',
      isEnabled: false,
      isEnabledStream: _bloc.allInputsAreValidStream,
      onPressed: () async {
        if (copyBloc.numberOfConflictingUsers(weekModel) > 0) {
          copyBloc.copyWeekplan(weekModel);
        }
      },
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
