import 'package:api_client/api/api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/cancel_mark_enum.dart';
import 'package:api_client/models/enums/complete_mark_enum.dart';
import 'package:api_client/models/enums/default_timer_enum.dart';
import 'package:api_client/models/enums/giraf_theme_enum.dart';
import 'package:api_client/models/enums/orientation_enum.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:async_test/async_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';

class MockSettingsApi extends Mock implements UserApi {}

class MockUserApi extends Mock implements UserApi {
  @override
  Stream<GirafUserModel> get(String id) {
    return Stream<GirafUserModel>.value(GirafUserModel(
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
  final DisplayNameModel user = DisplayNameModel(
    role: Role.Citizen.toString(),
    displayName: 'Citizen',
    id: '1'
  );
  SettingsModel settings = SettingsModel(
      orientation: Orientation.Portrait,
      completeMark: CompleteMark.Checkmark,
      cancelMark: CancelMark.Cross,
      defaultTimer: DefaultTimer.PieChart,
      timerSeconds: 1,
      activitiesCount: 1,
      theme: GirafTheme.GirafYellow,
      nrOfDaysToDisplay: 1,
      weekDayColors: null,
      pictogramText: false,
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
      pictogramText: true,
  );

  setUp(() {
    api = Api('any');
    api.user = MockUserApi();

    // Mocks the api call to get settings
    when(api.user.getSettings(any)).thenAnswer((Invocation inv) {
      return Stream<SettingsModel>.value(settings);
    });

    // Mocks the api call to update settings
    when(api.user.updateSettings(any, any)).thenAnswer((Invocation inv) {
      settings = updatedSettings;
      return Stream<SettingsModel>.value(updatedSettings);
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
    settingsBloc.settings.listen((SettingsModel loadedSettings) {
      expect(loadedSettings, isNotNull);
      expect(loadedSettings.toJson(), equals(updatedSettings.toJson()));
      done();
    });

    settingsBloc.updateSettings(user.id, settings);
    settingsBloc.loadSettings(user);
  }));

  test('Should dispose stream', async((DoneFn done) {
    settingsBloc.settings.listen((_) {}, onDone: done);
    settingsBloc.dispose();
  }));
}
