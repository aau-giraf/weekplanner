import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/week_name_model.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/edit_weekplan_bloc.dart';
import 'package:weekplanner/blocs/weekplan_selector_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/giraf_confirm_dialog.dart';
import 'package:weekplanner/widgets/input_fields_weekplan.dart';

///This screen is called when you edit a week plan
class EditWeekPlanScreen extends StatelessWidget {
  /// Screen for editing a weekplan.
  /// Requires a [UsernameModel] to be able to save the new weekplan.
  EditWeekPlanScreen({
    @required UsernameModel user,
    @required this.weekModel,
    @required this.selectorBloc,
  }) : _bloc = di.getDependency<EditWeekplanBloc>(), _weekPlans = selectorBloc.weekNameModels  {
    _bloc.initializeEditBloc(user, weekModel);
  }

  /// The current week model that should be edited
  final WeekModel weekModel;

  /// This bloc is the bloc from the week plan selector screen it is needed in
  /// in order to delete the week plan
  final WeekplansBloc selectorBloc;
  final Stream<List<WeekNameModel>> _weekPlans;

  final EditWeekplanBloc _bloc;

  @override
  Widget build(BuildContext context) {
    final GirafButton editButton = GirafButton(
      icon: const ImageIcon(AssetImage('assets/icons/edit.png')),
      text: 'Gem ændringer',
      isEnabled: false,
      isEnabledStream: _bloc.allInputsAreValidStream,
      onPressed: ()
      {
        {
          _weekPlans.take(1).listen((List<WeekNameModel> weekPlans) {
            _bloc.newWeekPlan.take(1).listen((WeekNameModel newWeekPlan) {
              if (newWeekPlan == null) {
                return;
              }

              for (WeekNameModel existingPlan in weekPlans) {
                if (existingPlan.weekYear == newWeekPlan.weekYear &&
                    existingPlan.weekNumber == newWeekPlan.weekNumber) {
                  // Show dialog
                  showDialog<Center>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext dialogContext) {
                        // A confirmation dialog is shown to stop the timer.
                        return GirafConfirmDialog(
                          key: const Key('OverwriteDialogKey'),
                          title: 'Overskriv ugeplan',
                          description: 'Ugeplanen (uge: ${newWeekPlan.weekNumber}'
                              ', år: ${newWeekPlan.weekYear}) eksisterer '
                              'allerede. Vil du overskrive denne ugeplan?',
                          confirmButtonText: 'Okay',
                          confirmButtonIcon: const ImageIcon(
                              AssetImage('assets/icons/accept.png')),
                          confirmOnPressed: () {
                            _bloc
                                .editWeekPlan(weekModel, selectorBloc)
                                .listen((WeekModel response) {
                              if (response != null) {
                                Routes.pop(dialogContext);
                                Routes.pop<WeekModel>(context, response);
                              }
                            });
                          },
                        );
                      });
                  return;
                }
              }
              _bloc
                  .editWeekPlan(weekModel, selectorBloc)
                  .listen((WeekModel response) {
                if (response != null) {
                  Routes.pop<WeekModel>(context, response);
                }
              });
            });
          });
        }
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
