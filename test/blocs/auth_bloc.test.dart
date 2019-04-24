import 'package:api_client/api/api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/api/week_api.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/weekday_model.dart';
import 'package:async_test/async_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test_api/test_api.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/weekplan_bloc.dart';
import 'package:weekplanner/models/enums/weekplan_mode.dart';
import 'package:weekplanner/models/user_week_model.dart';

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

  test('Test if mode is changed to guardian when setMode is called with guardian',
      async((DoneFn done) {
        authBloc.mode.skip(1).listen((WeekplanMode mode) {
          expect(mode, WeekplanMode.guardian);
          done();
        });
        authBloc.setMode(WeekplanMode.guardian);
      })
  );
}
