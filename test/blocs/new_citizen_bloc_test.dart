import 'package:api_client/api/account_api.dart';
import 'package:api_client/api/api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:async_test/async_test.dart';
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
  NewCitizenBloc bloc;
  Api api;

  final GirafUserModel user = GirafUserModel(id: '1',
      department: 1,
      role: Role.Citizen,
      roleName: 'Citizen',
      screenName: 'Birgit',
      username: 'b1337');

  setUp(() {
    api = Api('any');
    api.user = MockUserApi();
    api.account = MockAccountApi();
    bloc = NewCitizenBloc(api);
    bloc.initialize();


    when(api.account.register(
        any, any, displayName: anyNamed('displayName'),
        departmentId: anyNamed('departmentId'), role:  anyNamed('role')))
        .thenAnswer((_) {
      return Observable<GirafUserModel>.just(user);
    });


  });

  test('Should save a new citizen', async((DoneFn done) {
    bloc.onUsernameChange.add(user.username);
    bloc.onPasswordChange.add('1234');
    bloc.onPasswordVerifyChange.add('1234');
    bloc.onDisplayNameChange.add(user.screenName);
    bloc.createCitizen();

    verify(bloc.createCitizen());
    done();
  }));

  test('Username validation', async((DoneFn done) {
    bloc.onUsernameChange.add(user.username);
    bloc.validUsernameStream.listen((bool isValid) {
      expect(isValid, isNotNull);
      expect(isValid, true);
      done();
    });
  }));
}