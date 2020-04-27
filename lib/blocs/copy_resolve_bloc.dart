import 'dart:async';
import 'package:flutter/material.dart';
import 'package:api_client/api/api.dart';
import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:weekplanner/blocs/copy_weekplan_bloc.dart';
import 'package:weekplanner/widgets/giraf_confirm_dialog.dart';
import '../routes.dart';
import 'new_weekplan_bloc.dart';

/// This bloc has logic needed for the CopyResolveScreen
class CopyResolveBloc extends NewWeekplanBloc {
  /// Default constructor
  CopyResolveBloc(Api api) : super(api);

  /// This method should always be called before using the bloc, because
  /// it fills out the initial values of the week model object
  void initializeCopyResolverBloc(UsernameModel user, WeekModel weekModel) {
    super.initialize(user);
    // We just take the values out of the week model and put into our sink
    super.onTitleChanged.add(weekModel.name);
    super.onYearChanged.add(weekModel.weekYear.toString());
    super.onWeekNumberChanged.add(weekModel.weekNumber.toString());
    super.onThumbnailChanged.add(weekModel.thumbnail);
  }

  void copyContent(
      BuildContext context,
      WeekModel oldWeekModel,
      CopyWeekplanBloc copyBloc,
      UsernameModel currentUser,
      bool forThisCitizen) async {
    final WeekModel newWeekModel = WeekModel();
    newWeekModel.days = oldWeekModel.days;

    newWeekModel.thumbnail = super.thumbnailController.value;
    newWeekModel.name = super.titleController.value;
    newWeekModel.weekYear = int.parse(super.yearController.value);
    newWeekModel.weekNumber = int.parse(super.weekNoController.value);

    int numberOfConflicts = await copyBloc.numberOfConflictingUsers(
        newWeekModel, currentUser, forThisCitizen);

    if (numberOfConflicts > 0) {
      _displayConflictDialog(context, newWeekModel.weekNumber,
              newWeekModel.weekYear, numberOfConflicts)
          .then((toOverwrite) {
            if (toOverwrite) {
              copyBloc.copyWeekplan(newWeekModel, currentUser, forThisCitizen);
            }
          });
    } else {
      copyBloc.copyWeekplan(newWeekModel, currentUser, forThisCitizen);
      Routes.pop(context);
    }
  }

  Future<bool> _displayConflictDialog(
      BuildContext context, int weekNumber, int year, int numberOfConflicts) {
    final Completer<bool> dialogCompleter = Completer<bool>();
    showDialog<Center>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return GirafConfirmDialog(
            key: const Key('OverwriteCopyDialogKey'),
            title: 'Lav ny ugeplan til at kopiere',
            description: 'Der eksisterer allerede en ugeplan (uge: $weekNumber'
                ', år: $year) hos $numberOfConflicts af borgerne. '
                'Vil du overskrive '
                '${numberOfConflicts == 1 ? "denne ugeplan" : "disse ugeplaner"} ?',
            confirmButtonText: 'Ja',
            confirmButtonIcon:
                const ImageIcon(AssetImage('assets/icons/accept.png')),
            confirmOnPressed: () {
              dialogCompleter.complete(true);
              Routes.pop(context);
              Routes.pop(context);
            },
            cancelOnPressed: () {
              dialogCompleter.complete(false);
            },
          );
        });

    return dialogCompleter.future;
  }
}
