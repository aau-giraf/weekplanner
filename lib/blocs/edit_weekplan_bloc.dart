import 'package:api_client/api/api.dart';
import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/new_weekplan_bloc.dart';
import 'package:weekplanner/blocs/weekplan_selector_bloc.dart';

///This bloc is used to control the information when editing week plan
class EditWeekplanBloc extends NewWeekplanBloc {
  /// Constructor
  EditWeekplanBloc(Api api) : super(api);

  /// This method should always be called before using the bloc, because
  /// it fills out the initial values of the week model object
  void initializeEditBloc(UsernameModel user, WeekModel weekModel) {
    super.initialize(user);
    // We just take the values out of the week model and put into our sink
    super.onTitleChanged.add(weekModel.name);
    super.onYearChanged.add(weekModel.weekYear.toString());
    super.onWeekNumberChanged.add(weekModel.weekNumber.toString());
    super.onThumbnailChanged.add(weekModel.thumbnail);
  }

  /// This method allows one to save the new information stored in the week
  /// model object and also deletes the old object if necessary
  Observable<WeekModel> editWeekPlan(
      WeekModel oldWeekModel, WeekplansBloc selectorBloc) {
    final WeekModel newWeekModel = WeekModel();

    // We copy the activities from the old week model.
    newWeekModel.days = oldWeekModel.days;

    // Getting the values from the input fields
    newWeekModel.thumbnail = super.thumbnailController.value;
    newWeekModel.name = super.titleController.value;
    newWeekModel.weekYear = int.parse(super.yearController.value);
    newWeekModel.weekNumber = int.parse(super.weekNoController.value);

    // Here we delete the old week plan (we had to do this because of the way
    // the keys work for the put method does not allow us to change week year
    // and week number
    if (oldWeekModel.weekYear != newWeekModel.weekYear ||
        oldWeekModel.weekNumber != newWeekModel.weekNumber) {
      selectorBloc.deleteWeekModel(oldWeekModel);
    }

    return weekApi.week.update(super.weekUser.id, newWeekModel.weekYear,
        newWeekModel.weekNumber, newWeekModel);
  }
}
