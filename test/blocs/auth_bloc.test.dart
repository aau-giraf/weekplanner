import 'package:api_client/api/api.dart';
import 'package:async_test/async_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/models/enums/weekplan_mode.dart';

void main() {
  Api api;
  AuthBloc authBloc;
  setUp((){
    api = Api('any');
    authBloc = AuthBloc(api);
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
}
