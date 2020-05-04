import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/copy_resolve_bloc.dart';
import 'package:weekplanner/blocs/copy_weekplan_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/weekplan_selector_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/input_fields_weekplan.dart';

/// Screen for creating a new weekplan.
// ignore: must_be_immutable
class CopyResolveScreen extends StatelessWidget {
  /// Screen for creating a new weekplan.
  /// Requires a [UsernameModel] to be able to save the new weekplan.
  CopyResolveScreen({
    @required this.currentUser,
    @required this.weekModel,
    @required this.forThisCitizen,
    this.copyBloc,
  }) : _bloc = di.getDependency<CopyResolveBloc>() {
    _bloc.initializeCopyResolverBloc(currentUser, weekModel);
    copyBloc = di.getDependency<CopyWeekplanBloc>();
  }

  final CopyResolveBloc _bloc;

  /// Tell us whether to copy to this citizen or to others
  final bool forThisCitizen;

  /// An instance of the copyWeekplanBloc.
  CopyWeekplanBloc copyBloc = di.getDependency<CopyWeekplanBloc>();

  /// The user that is being copied from
  final DisplayNameModel currentUser;

  /// The weekModel that is being copied
  final WeekModel weekModel;

  @override
  Widget build(BuildContext context) {
    final GirafButton saveButton = GirafButton(
      icon: const ImageIcon(AssetImage('assets/icons/save.png')),
      key: const Key('CopyResolveSaveButton'),
      text: 'Gem ugeplan',
      isEnabled: false,
      isEnabledStream: _bloc.allInputsAreValidStream,
      onPressed: () async {
        _bloc
            .copyContent(
                context, weekModel, copyBloc, currentUser, forThisCitizen)
            .then((bool done) {
          if (done) {
            Routes.goHome(context);
            Routes.push(context,
                WeekplanSelectorScreen(currentUser));
          }
        });
      },
    );

    return Scaffold(
      appBar: GirafAppBar(title: 'Ny ugeplan'),
      body: InputFieldsWeekPlan(
          bloc: _bloc, button: saveButton, weekModel: weekModel),
    );
  }
}
