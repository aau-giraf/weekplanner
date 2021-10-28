import 'package:api_client/api/account_api.dart';
import 'package:api_client/api/api.dart';
import 'package:async_test/async_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/models/enums/weekplan_mode.dart';

///A mock of the account api to use in the tests
class MockAccountApi extends Mock implements AccountApi {
  @override Stream<bool> login(String username, String password){
    ///Returns true to mark the the user exists
   return Stream<bool>.value(true);
  }

  @override Stream<String> role(String username){
    ///Returns guardian to check if guardian is actually set
    return Stream<String>.value('guardian');
  }
}

void main() {
  Api _api;
  AuthBloc authBloc;
  setUp((){
    _api = Api('any');
    authBloc = AuthBloc(_api);
  _api.account = MockAccountApi();

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
      })
  );

  test(
      'Test if mode is changed to guardian when setMode is called with guardian'
      ,
      async((DoneFn done) {
        authBloc.mode.skip(1).listen((WeekplanMode mode) {
          expect(mode, WeekplanMode.guardian);
          done();
        });
        authBloc.setMode(WeekplanMode.guardian);
      })
  );

  test(
      'Test if the mode is changed to trustee '
      'when setMode is called with trustee'
      ,
      async((DoneFn done) {
        authBloc.mode.skip(1).listen((WeekplanMode mode) {
          expect(mode, WeekplanMode.trustee);
          done();
        });
        authBloc.setMode(WeekplanMode.trustee);
      })
  );

  String username = 'Graatand';
  String password = 'password';
  test('Should check that authenticate works', async((DoneFn done) {
    authBloc.mode.skip(1).listen((WeekplanMode mode) {

      expect(mode, WeekplanMode.guardian);
      done();
    });
    authBloc.authenticate(username, password);
  }));
}
