import 'package:api_client/api/api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/models/enums/cancel_mark_enum.dart';
import 'package:api_client/models/enums/complete_mark_enum.dart';
import 'package:api_client/models/enums/default_timer_enum.dart';
import 'package:api_client/models/enums/giraf_theme_enum.dart';
import 'package:api_client/models/enums/orientation_enum.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:api_client/models/username_model.dart';
import 'package:async_test/async_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';

class MockSettingsApi extends Mock implements UserApi {}

class MockUserApi extends Mock implements UserApi {
  @override
  Observable<GirafUserModel> get(String id) {
    return Observable<GirafUserModel>.just(GirafUserModel(
        id: '1',
        department: 3,
        role: Role.Guardian,
        roleName: 'Guardian',
        displayName: 'Kurt',
        username: 'SpaceLord69',
    ));
  }

}

void main() {
  SettingsBloc settingsBloc;
  Api api;
  final UsernameModel user = UsernameModel(
    role: Role.Citizen.toString(),
    name: 'Citizen',
    id: '1'
  );
  final SettingsModel settings = SettingsModel(
      orientation: Orientation.Portrait,
      completeMark: CompleteMark.Checkmark,
      cancelMark: CancelMark.Cross,
      defaultTimer: DefaultTimer.AnalogClock,
      timerSeconds: 1,
      activitiesCount: 1,
      theme: GirafTheme.GirafYellow,
      nrOfDaysToDisplay: 1,
      weekDayColors: null
  );

  final SettingsModel updatedSettings = SettingsModel(
      orientation: Orientation.Landscape,
      completeMark: CompleteMark.MovedRight,
      cancelMark: CancelMark.Removed,
      defaultTimer: DefaultTimer.Hourglass,
      timerSeconds: 2,
      activitiesCount: 3,
      theme: GirafTheme.GirafYellow,
      nrOfDaysToDisplay: 2,
      weekDayColors: null,
  );

  setUp(() {
    api = Api('any');

    api.user = MockUserApi();

    when(api.user.getSettings(any)).thenAnswer((Invocation inv) {
      return Observable<SettingsModel>.just(settings);
    });

    when(api.user.updateSettings(any, any)).thenAnswer((Invocation inv) {
      return Observable<SettingsModel>.just(updatedSettings);
    });

    settingsBloc = SettingsBloc(api);
  });

  test('Can load settings from username model', async((DoneFn done) {
    settingsBloc.settings.listen((SettingsModel response) {
      expect(response, isNotNull);
      expect(response.toJson(), equals(settings.toJson()));
      verify(api.user.getSettings(any));
      done();
    });

    settingsBloc.loadSettings(user);
  }));

  test('Can update settings', async((DoneFn done) {
    settings.orientation = Orientation.Landscape;
    settings.completeMark = CompleteMark.MovedRight;
    settings.cancelMark = CancelMark.Removed;
    settings.defaultTimer = DefaultTimer.Hourglass;
    settings.timerSeconds = 2;
    settings.activitiesCount = 3;
    settings.theme = GirafTheme.GirafYellow;
    settings.nrOfDaysToDisplay = 2;
    settings.weekDayColors = null;
    settingsBloc.settings.listen((SettingsModel response) {
      expect(response, isNotNull);
      expect(response.toJson(), equals(settings.toJson()));
      done();
    });

    settingsBloc.updateSettings(user.id, settings);
  }));

  test('Should dispose stream', async((DoneFn done) {
    settingsBloc.settings.listen((_) {}, onDone: done);
    settingsBloc.dispose();
  }));
}
