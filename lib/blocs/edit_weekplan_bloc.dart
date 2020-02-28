import 'package:api_client/api/api.dart';
import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/new_weekplan_bloc.dart';

class EditWeekplanBloc extends NewWeekplanBloc {
  /// This class is an extension of NewWeekplan bloc
  EditWeekplanBloc(Api api) : super(api);

  /// This method should always be called before using the bloc
  void initializeEditBloc(UsernameModel user, WeekModel weekModel) {
      super.initialize(user);
      // We just take the values out of the week model and put into our sink
      super.onTitleChanged.add(weekModel.name);
      super.onYearChanged.add(weekModel.weekYear.toString());
      super.onWeekNumberChanged.add(weekModel.weekNumber.toString());
      super.onThumbnailChanged.add(weekModel.thumbnail);
  }


}