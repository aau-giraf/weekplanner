import 'package:api_client/api/api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/api/week_api.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test_api/test_api.dart';
import 'package:weekplanner/blocs/weekplan_bloc.dart';
import 'package:weekplanner/models/user_week_model.dart';

class MockWeekApi extends Mock implements WeekApi {}

class MockUserApi extends Mock implements UserApi {
  @override
  Observable<GirafUserModel> me() {
    return Observable<GirafUserModel>.just(GirafUserModel(
        id: '1',
        department: 3,
        role: Role.Guardian,
        roleName: 'Guardian',
        screenName: 'Kurt',
        username: 'SpaceLord69'));
  }
}

void main() {
  WeekplanBloc weekplanBloc;
  Api api;

  setUp(() {
    api = Api('any');

    api.user = MockUserApi();
    api.week = MockWeekApi();

    weekplanBloc = WeekplanBloc(api);
  });

  test('Loads a weekplan for the weekplan view', () {
    final WeekModel week = WeekModel(name: 'test week');
    weekplanBloc.setWeek(week, null);

    weekplanBloc.userWeek.listen((UserWeekModel response) {
      expect(response, isNotNull);
      expect(response.week, equals(week));
    });
  });

  test('Adds an activity to a given weekplan', () {
    final WeekModel week = WeekModel(name: 'test week');
    final UsernameModel user = ;

    weekplanBloc.setWeek(week, user);


  });
}
