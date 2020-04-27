import 'package:api_client/api/api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/api/week_api.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:async_test/async_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/copy_weekplan_bloc.dart';

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

  @override
  Observable<List<UsernameModel>> getCitizens(String id) {
    final List<UsernameModel> output = <UsernameModel>[];
    output.add(UsernameModel(name: 'test1', role: 'test1', id: id));

    return Observable<List<UsernameModel>>.just(output);
  }
}

Map<String, WeekModel> map = Map();
class MockWeekApi extends Mock implements WeekApi {

  Observable<WeekModel> update(String id, int year, int weekNumber,
    WeekModel week) {
    map[id] = week;
    return Observable<WeekModel>.just(week);
  }

  Observable<WeekModel> get(String id, int year, int weekNumber) {
    // return null so there are no conflicts
    return Observable<WeekModel>.just(null);
  }

}


void main() {
  CopyWeekplanBloc bloc;
  Api api;
  UsernameModel user;
  WeekModel weekplan1;
  setUp(() {
    api = Api('any');
    api.user = MockUserApi();
    api.week = MockWeekApi();
    bloc = CopyWeekplanBloc(api);
    user = UsernameModel(name: 'Hans', role: Role.Citizen.toString(), id: '1');
    weekplan1 = WeekModel(
      thumbnail: null, name: "weekplan1", weekYear: 2020, weekNumber: 32);
  });

  test('toggleMarkedUserModel', async((DoneFn done) {
    bloc.toggleMarkedUserModel(user);

    bloc.markedUserModels.listen((List<UsernameModel> response) {
      expect(response.contains(user), true);
    });
    done();
  }));

  test('Test whether the copyToCitizens method '
    'copies the weekplan to the citizens', async((DoneFn done) {

    for (int i = 0; i < 10; i++) {
      final UsernameModel user = UsernameModel(
        name: 'Hans', role: Role.Citizen.toString(), id: i.toString());
      bloc.toggleMarkedUserModel(user);
      bloc.markedUserModels.listen((List<UsernameModel> markedUsers) {
        expect(markedUsers.contains(user), true);
      });
    }

    bloc.copyWeekplan(weekplan1);

    bloc.markedUserModels.listen((List<UsernameModel> markedUsers) {
      for (UsernameModel user in markedUsers){
        expect(map.containsKey(user.id), true);
        expect(map[user.id], weekplan1);
      }
      done();
    });

  }));
}