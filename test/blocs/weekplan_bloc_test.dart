import 'package:api_client/api/api.dart';
import 'package:api_client/api/week_api.dart';
import 'package:api_client/models/week_model.dart';
import 'package:mockito/mockito.dart';
import 'package:test_api/test_api.dart';
import 'package:weekplanner/blocs/weekplan_bloc.dart';
class MockWeekApi extends Mock implements WeekApi {}

void main() {
  WeekplanBloc weekplanBloc;
  Api api;
  MockWeekApi weekApi;

  setUp(() {
    api = Api('any');
    weekApi = MockWeekApi();
    api.week = weekApi;
    weekplanBloc = WeekplanBloc();
  });

  test('Loads a weekplan for the weekplan view', () {
    final WeekModel week = WeekModel(name: 'test week');
    weekplanBloc.setWeek(week);

    weekplanBloc.week.listen((WeekModel response) {
      expect(response, isNotNull);
      expect(response, equals(week));
    });
  });
}