import 'package:api_client/api/api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:api_client/models/username_model.dart';
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

void main() {
  CopyWeekplanBloc bloc;
  Api api;
  UsernameModel user;
  setUp(() {
    api = Api('any');
    api.user = MockUserApi();
    bloc = CopyWeekplanBloc(api);
    user = UsernameModel(name: 'Hans', role: Role.Citizen.toString(), id: '1');
  });

  test('toggleMarkedUserModel', async((DoneFn done){
    bloc.toggleMarkedUserModel(user);

    bloc.markedUserModels.listen((List<UsernameModel> response) {
      expect(response.contains(user), true);
    });
    done();
  }));


}