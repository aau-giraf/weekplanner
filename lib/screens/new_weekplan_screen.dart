import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/week_name_model.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
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
  NewWeekplanScreen(UsernameModel user,
      {@required Stream<List<WeekNameModel>> weekPlans})
      : _bloc = di.getDependency<NewWeekplanBloc>(),
        _weekPlans = weekPlans {
    _bloc.initialize(user);
  }

  final NewWeekplanBloc _bloc;
  final Stream<List<WeekNameModel>> _weekPlans;

  @override
  Widget build(BuildContext context) {
    final GirafButton saveButton = GirafButton(
      icon: const ImageIcon(AssetImage('assets/icons/save.png')),
      key: const Key('NewWeekplanSaveBtnKey'),
      text: 'Gem ugeplan',
      isEnabled: false,
      isEnabledStream: _bloc.allInputsAreValidStream,
      onPressed: () {
        _weekPlans.listen((List<WeekNameModel> weekPlans) {
          _bloc.newWeekPlan.listen((WeekNameModel newWeekPlan) {
            if (newWeekPlan == null) {
              // Show error.
              return;
            }

            for (WeekNameModel exisitingPlan in weekPlans) {
              if (exisitingPlan.weekYear == newWeekPlan.weekYear &&
                  exisitingPlan.weekNumber == newWeekPlan.weekNumber) {
                // Show dialog
                showDialog<Center>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      // A confirmation dialog is shown to stop the timer.
                      return GirafConfirmDialog(
                        key: const Key('OverwriteDialogKey'),
                        title: 'Overskriv',
                        description: 'Vil du gemme?',
                        confirmButtonText: 'Okay',
                        confirmButtonIcon: const ImageIcon(
                            AssetImage('assets/icons/accept.png')),
                        confirmOnPressed: () {
                          _bloc.saveWeekplan().listen((WeekModel response) {
                            if (response != null) {
                              Routes.pop<WeekModel>(context, response);
                            }
                          });
                        },
                      );
                    });
                return;
              }
            }
            
            _bloc.saveWeekplan().listen((WeekModel response) {
              if (response != null) {
                Routes.pop<WeekModel>(context, response);
              }
            });
          });
        });
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
