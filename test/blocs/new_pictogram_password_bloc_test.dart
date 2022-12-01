import 'package:api_client/api/account_api.dart';
import 'package:api_client/api/api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:async_test/async_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weekplanner/blocs/new_pictogram_password_bloc.dart';

class MockUserApi extends Mock implements UserApi {
  @override
  Stream<GirafUserModel> me() {
    return Stream<GirafUserModel>.value(GirafUserModel(
        id: '1',
        department: 1,
        role: Role.Guardian,
        roleName: 'Guardian',
        displayName: 'Kirsten Birgit',
        username: 'kb7913'));
  }
}

class MockAccountApi extends Mock implements AccountApi {}

void main() {
  NewPictogramPasswordBloc bloc;
  Api api;

  final GirafUserModel user = GirafUserModel(
      id: '1',
      department: 1,
      role: Role.Citizen,
      roleName: 'Citizen',
      displayName: 'Birgit',
      username: 'b1337');

  setUp(() {
    api = Api('any');
    api.user = MockUserApi();
    api.account = MockAccountApi();
    bloc = NewPictogramPasswordBloc(api);
    bloc.initialize('testUser', 'testName', Uint8List(1));

    when(api.account.register(any, any, any, any,
            departmentId: anyNamed('departmentId'), role: anyNamed('role')))
        .thenAnswer((_) {
      return Stream<GirafUserModel>.value(user);
    });
  });

  test('Should save a new citien', async((DoneFn done) {
    bloc.onPictogramPasswordChanged.add('1111');
    bloc.createCitizen();

    verify(bloc.createCitizen());
    done();
  }));

  test('Valid pictogram password', async((DoneFn done) {
    bloc.onPictogramPasswordChanged.add('1111');
    bloc.validPictogramPasswordStream.listen((bool valid) {
      expect(valid, isNotNull);
      expect(valid, true);
    });
    done();
  }));

  test('Invalid pictogram password', async((DoneFn done) {
    bloc.onPictogramPasswordChanged.add(null);
    bloc.validPictogramPasswordStream.listen((bool valid) {
      expect(valid, isNotNull);
      expect(valid, false);
    });
    done();
  }));
}
