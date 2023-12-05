// ignore_for_file: lines_longer_than_80_chars

import 'package:api_client/api/account_api.dart';
import 'package:api_client/api/api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:async_test/async_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/models/enums/weekplan_mode.dart';
import 'package:api_client/models/giraf_user_model.dart';

///A mock of the account api to use in the tests
class MockAccountApi extends Mock implements AccountApi {
  @override
  Stream<bool> login(String username, String password) {
    ///Returns true to mark the the user exists
    return Stream<bool>.value(true);
  }
}

///A mock of the user api to use in the tests
class MockUserApi extends Mock implements UserApi {
  @override
  Stream<int> role(String username) {
    ///Returns a role to check that authenticate works
    if (username.compareTo('Graatand') == 0) {
      return Stream<int>.value(Role.Guardian.index);
    } else if (username.compareTo('Chris') == 0) {
      return Stream<int>.value(Role.Trustee.index);
    } else if (username.compareTo('Janne') == 0) {
      return Stream<int>.value(Role.Citizen.index);
    }

    throw Exception;
  }

  @override
  ///Mocks the me function, otherwise it will be null
  Stream<GirafUserModel> me() {
    ///Setting up the "me()" stream variables depending on the different users
    Role userRole;
    String userRoleName;
    String displayAndUsername;
    if(user.compareTo('Graatand') == 0) { userRole = Role.Guardian;
                                          displayAndUsername = 'Graatand';
                                          userRoleName = 'Guardian';}
    else if(user.compareTo('Chris') == 0) { userRole = Role.Trustee;
                                            displayAndUsername = 'Chris';
                                            userRoleName = 'Trustee';}
    else if(user.compareTo('Janne') == 0) { userRole = Role.Citizen;
                                            displayAndUsername = 'Janne';
                                            userRoleName = 'Citizen';}

    ///Assigning the stream based on the if-else chain above
    return Stream<GirafUserModel>.value(GirafUserModel(
        id: '1',
        department: 3,
        role: userRole,
        roleName: userRoleName,
        displayName: displayAndUsername,
        username: displayAndUsername),
    );
  }
}
///Making an instance of the MockUserApi class, so that the "user" variable
///can be changed making it possible to change the stream within the "me()" function.
MockUserApi mockUserApi = new MockUserApi();

void main() {
  late Api _api;
  late AuthBloc authBloc;

  setUp(() {
    _api = Api('any');
    authBloc = AuthBloc(_api);
    _api.account = MockAccountApi();
    _api.user = mockUserApi;
  });

  test('Check if the mode defaults to guardian', async((DoneFn done) {
    authBloc.mode.listen((WeekplanMode mode) {
      expect(mode, WeekplanMode.guardian);
      done();
    });
  }));

  test('Test if mode is changed to citizen when setMode is called with citizen',
      async((DoneFn done) {
    authBloc.mode.skip(1).listen((WeekplanMode mode) {
      expect(mode, WeekplanMode.citizen);
      done();
    });
    authBloc.setMode(WeekplanMode.citizen);
  }));

  test(
      'Test if mode is changed to guardian when setMode is called with guardian',
      async((DoneFn done) {
    authBloc.mode.skip(1).listen((WeekplanMode mode) {
      expect(mode, WeekplanMode.guardian);
      done();
    });
    authBloc.setMode(WeekplanMode.guardian);
  }));

  test(
      'Test if the mode is changed to trustee '
      'when setMode is called with trustee', async((DoneFn done) {
    authBloc.mode.skip(1).listen((WeekplanMode mode) {
      expect(mode, WeekplanMode.trustee);
      done();
    });
    authBloc.setMode(WeekplanMode.trustee);
  }));

  test('Should check that authenticate works (Guardian)', async((DoneFn done) {
    //mockUserApi.user = 'Graatand';
    authBloc.mode.skip(1).listen((WeekplanMode mode) {
      expect(mode, WeekplanMode.guardian);
      done();
    });
    authBloc.authenticate(mockUserApi.user, mockUserApi.password);
  }));

  test('Should check that authenticate works (Trustee)', async((DoneFn done) {
    mockUserApi.user = 'Chris';
    authBloc.mode.skip(1).listen((WeekplanMode mode) {
      expect(mode, WeekplanMode.trustee);
      done();
    });
    authBloc.authenticate(mockUserApi.user, mockUserApi.password);
  }));

  test('Should check that authenticate works (Citizen)', async((DoneFn done) {
    mockUserApi.user = 'Janne';
    authBloc.mode.skip(1).listen((WeekplanMode mode) {
      expect(mode, WeekplanMode.citizen);
      done();
    });
    authBloc.authenticate(mockUserApi.user, mockUserApi.password);
  }));
}
