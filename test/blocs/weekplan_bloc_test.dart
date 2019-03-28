import 'package:mockito/mockito.dart';
import 'package:test_api/test_api.dart';
import 'package:weekplanner/blocs/weekplan_bloc.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/providers/api/api.dart';
import 'package:weekplanner/providers/api/week_api.dart';

class MockWeekApi extends Mock implements WeekApi {}

void main() {
  WeekplanBloc weekplanBloc;
  Api api;
  MockWeekApi weekApi;

  setUp(() {
    api = Api('any');
    weekApi = MockWeekApi();
    api.week = weekApi;
    weekplanBloc = WeekplanBloc(api);
  });

  test('Loads a weekplan for the weekplan view', () {
    WeekModel week = WeekModel(name: 'test week');
    weekplanBloc.setWeek(week);

    weekplanBloc.week.listen((WeekModel response) {
      expect(response, isNotNull);
      expect(response, equals(week));
    });
  });
}