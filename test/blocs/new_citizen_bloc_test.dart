import 'package:api_client/api/account_api.dart';
import 'package:api_client/api/api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/new_citizen_bloc.dart';

class MockUserApi extends Mock implements UserApi {
  @override
  Observable<GirafUserModel> me() {
    return Observable<GirafUserModel>.just(GirafUserModel(
        id: '1',
        department: 1,
        role: Role.Guardian,
        roleName: 'Guardian',
        screenName: 'Kirsten Birgit',
        username: 'kb7913'));
  }
}
class MockAccountApi extends Mock implements AccountApi {}

void main() {
  NewCitizenBloc _bloc;
  Api _api;

  setUp(() {
    _api = Api('any');
    _api.user = MockUserApi();
    _api.account = MockAccountApi()
    _bloc = NewCitizenBloc(_api);
    _bloc.initialize();
    final GirafUserModel user = GirafUserModel(id: '1',
        department: 1,
        role: Role.Citizen,
        roleName: 'Citizen',
        screenName: 'Birgit',
        username: 'b1337');

//    when(_api.account.register(
//        any, any, displayName: any, departmentId: any, role:  any)
//        .thenAnswer((_) {
//      return Observable<GirafUserModel>.just(user);
//    }));
  });


}