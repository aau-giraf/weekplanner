import 'package:async_test/async_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test_api/test_api.dart';
import 'package:weekplanner/blocs/choose_citizen_bloc.dart';
import 'package:weekplanner/models/enums/role_enum.dart';
import 'package:weekplanner/models/giraf_user_model.dart';
import 'package:weekplanner/models/username_model.dart';
import 'package:weekplanner/providers/api/api.dart';
import 'package:weekplanner/providers/api/user_api.dart';

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
  ChooseCitizenBloc bloc;
  Api api;
  setUp(() {
    api = Api('any');
    api.user = MockUserApi();
    bloc = ChooseCitizenBloc(api);
  });

  test('Should be able to get UsernameModel from API', async((DoneFn done) {
    int _count = 0;
    bloc.citizen.listen((List<UsernameModel> response) {
      if (_count == 0) {
        expect(response.length, 0);
        _count++;
      } else if (_count == 1) {
        expect(response.length, 1);
        final UsernameModel rsp = response[0];
        expect(rsp.name, 'test1');
        expect(rsp.role, 'test1');
        expect(rsp.id, '1');
      }
    });
    done();
  }));
}
