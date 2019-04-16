import 'package:api_client/models/week_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/bloc_base.dart';

/// Bloc that streams the currently chosen weekplan
class WeekplanBloc extends BlocBase {
  final BehaviorSubject<WeekModel> _week = BehaviorSubject<WeekModel>();

  /// The stream that emits the currently chosen weekplan
  Stream<WeekModel> get week => _week.stream;

  /// Sink to set the currently chosen week
  void setWeek(WeekModel week) {
      _week.add(week);
  }

  @override
  void dispose() {
    _week.close();
  }
}
