import 'package:api_client/models/week_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';

/// Bloc that streams the currently chosen weekplan
class WeekplanBloc extends BlocBase {
  final BehaviorSubject<WeekModel> _week = BehaviorSubject<WeekModel>();
  final BehaviorSubject<bool> _editMode = BehaviorSubject<bool>.seeded(false);

  /// The stream that emits the currently chosen weekplan
  Stream<WeekModel> get week => _week.stream;
  /// The stream that emits whether in edit mode or citizen
  Stream<bool> get editMode => _editMode.stream;

  /// Sink to set the currently chosen week
  void setWeek(WeekModel week) {
      _week.add(week);
  }

  /// Toggles edit mode
  void toggleEditMode() {
    _editMode.add(!_editMode.value);
    print(_editMode.value);
  }

  @override
  void dispose() {
    _week.close();
  }
}
