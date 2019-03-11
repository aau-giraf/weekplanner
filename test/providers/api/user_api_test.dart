import 'package:test_api/test_api.dart';
import 'package:weekplanner/models/cancel_mark_enum.dart';
import 'package:weekplanner/models/complete_mark_enum.dart';
import 'package:weekplanner/models/default_timer_enum.dart';
import 'package:weekplanner/models/orientation_enum.dart';
import 'package:weekplanner/models/role_enum.dart';
import 'package:weekplanner/models/theme_enum.dart';
import 'package:weekplanner/models/weekday_color_model.dart';
import 'package:weekplanner/models/weekday_enum.dart';
import 'package:weekplanner/providers/api/user_api.dart';
import 'package:weekplanner/providers/http/http_mock.dart';
import 'package:weekplanner/models/giraf_user_model.dart';
import 'package:weekplanner/models/settings_model.dart';
import 'package:weekplanner/models/username_model.dart';

void main() {
  UserApi userApi;
  HttpMock httpMock;

  GirafUserModel user = GirafUserModel(
      id: "1234",
      department: 3,
      role: Role.Guardian,
      roleName: "Guardian",
      screenName: "Kurt",
      username: "SpaceLord69");

  List<UsernameModel> usernames = [
    UsernameModel(name: "Kurt", role: Role.SuperUser.toString(), id: "1"),
    UsernameModel(name: "Hüttel", role: Role.SuperUser.toString(), id: "2"),
  ];

  SettingsModel settings = SettingsModel(
      orientation: Orientation.Landscape,
      completeMark: CompleteMark.Checkmark,
      cancelMark: CancelMark.Cross,
      defaultTimer: DefaultTimer.AnalogClock,
      theme: Theme.AndroidBlue,
      weekDayColors: [
        WeekdayColorModel(day: Weekday.Monday, hexColor: "#123456")
      ]);

  setUp(() {
    httpMock = HttpMock();
    userApi = UserApi(httpMock);
  });

  test("Should fetch authenticated user", () {
    userApi.me().listen(expectAsync1((GirafUserModel authUser) {
      expect(authUser.toJson(), user.toJson());
    }));

    httpMock.expectOne(url: "/", method: Method.get).flush({
      "data": user.toJson(),
      "success": true,
      "errorProperties": [],
      "errorKey": "NoError",
    });
  });

  test("Should fetch user with ID", () {
    userApi.get(user.id).listen(expectAsync1((GirafUserModel specUser) {
      expect(specUser.toJson(), user.toJson());
    }));

    httpMock.expectOne(url: "/${user.id}", method: Method.get).flush({
      "data": user.toJson(),
      "success": true,
      "errorProperties": [],
      "errorKey": "NoError",
    });
  });

  test("Should update user with ID", () {
    userApi.update(user).listen(expectAsync1((GirafUserModel specUser) {
      expect(specUser.toJson(), user.toJson());
    }));

    httpMock.expectOne(url: "/${user.id}", method: Method.put).flush({
      "data": user.toJson(),
      "success": true,
      "errorProperties": [],
      "errorKey": "NoError",
    });
  });

  test("Should get settings from user with ID", () {
    userApi
        .getSettings(user.id)
        .listen(expectAsync1((SettingsModel specSettings) {
      expect(specSettings.toJson(), settings.toJson());
    }));

    httpMock.expectOne(url: "/${user.id}/settings", method: Method.get).flush({
      "data": settings.toJson(),
      "success": true,
      "errorProperties": [],
      "errorKey": "NoError",
    });
  });

  test("Should update settings from user with ID", () {
    userApi
        .updateSettings(user.id, settings)
        .listen(expectAsync1((SettingsModel specSettings) {
      expect(specSettings.toJson(), settings.toJson());
    }));

    httpMock.expectOne(url: "/${user.id}/settings", method: Method.put).flush({
      "data": settings.toJson(),
      "success": true,
      "errorProperties": [],
      "errorKey": "NoError",
    });
  });

  test("Should get citizens from user with ID", () {
    userApi
        .getCitizens(user.id)
        .listen(expectAsync1((List<UsernameModel> names) {
      expect(names.map((name) => name.toJson()),
          usernames.map((name) => name.toJson()));
    }));

    httpMock.expectOne(url: "/${user.id}/citizens", method: Method.get).flush({
      "data": usernames.map((name) => name.toJson()).toList(),
      "success": true,
      "errorProperties": [],
      "errorKey": "NoError",
    });
  });

  test("Should get citizens from user with ID", () {
    userApi
        .getGuardians(user.id)
        .listen(expectAsync1((List<UsernameModel> names) {
      expect(names.map((name) => name.toJson()),
          usernames.map((name) => name.toJson()));
    }));

    httpMock.expectOne(url: "/${user.id}/guardians", method: Method.get).flush({
      "data": usernames.map((name) => name.toJson()).toList(),
      "success": true,
      "errorProperties": [],
      "errorKey": "NoError",
    });
  });

  test("Should get citizens from user with ID", () {
    const String citizenId = "1234";

    userApi
        .addCitizenToGuardian(user.id, citizenId)
        .listen(expectAsync1((bool success) {
      expect(success, isTrue);
    }));

    httpMock
        .expectOne(url: "/${user.id}/citizens/$citizenId", method: Method.post)
        .flush({
      "success": true,
      "errorProperties": [],
      "errorKey": "NoError",
    });
  });

  tearDown(() {
    httpMock.verify();
  });
}
