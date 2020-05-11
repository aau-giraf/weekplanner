import 'package:api_client/api/account_api.dart';
import 'package:api_client/api/activity_api.dart';
import 'package:api_client/api/api.dart';
import 'package:api_client/api/pictogram_api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/api/week_api.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/access_level_enum.dart';
import 'package:api_client/models/enums/activity_state_enum.dart';
import 'package:api_client/models/enums/cancel_mark_enum.dart';
import 'package:api_client/models/enums/complete_mark_enum.dart';
import 'package:api_client/models/enums/default_timer_enum.dart';
import 'package:api_client/models/enums/giraf_theme_enum.dart';
import 'package:api_client/models/enums/orientation_enum.dart' as orientation;
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/enums/weekday_enum.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:api_client/models/timer_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/weekday_color_model.dart';
import 'package:api_client/models/weekday_model.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

import 'test_image.dart';

/// Mock data that can be used for tests
class MockData {
  /// Constructor
  MockData() {
    mockWeek = _createInitialMockWeek();
    mockSettings = _createInitialMockSettings();
    mockActivities = _createInitialMockActivities();
    mockUser = DisplayNameModel(
        role: Role.Guardian.toString(), displayName: 'User', id: '1');

    mockApi = Api('any');

    mockApi.week = MockWeekApi(mockWeek);
    mockApi.user = MockUserApi(mockSettings);
    mockApi.activity = MockActivityApi(mockActivities);
    mockApi.pictogram = MockPictogramApi();
    mockApi.account = MockAccountApi();
  }

  WeekModel mockWeek;
  SettingsModel mockSettings;
  List<ActivityModel> mockActivities;
  DisplayNameModel mockUser;

  Api mockApi;

  WeekModel _createInitialMockWeek() {
    return WeekModel(
        thumbnail: PictogramModel(
            imageUrl: null,
            imageHash: null,
            accessLevel: null,
            title: null,
            id: null,
            lastEdit: null),
        days: <WeekdayModel>[
          WeekdayModel(activities: <ActivityModel>[], day: Weekday.Monday),
          WeekdayModel(activities: <ActivityModel>[], day: Weekday.Tuesday),
          WeekdayModel(activities: <ActivityModel>[], day: Weekday.Wednesday),
          WeekdayModel(activities: <ActivityModel>[], day: Weekday.Thursday),
          WeekdayModel(activities: <ActivityModel>[], day: Weekday.Friday),
          WeekdayModel(activities: <ActivityModel>[], day: Weekday.Saturday),
          WeekdayModel(activities: <ActivityModel>[], day: Weekday.Sunday),
        ],
        name: 'Week',
        weekNumber: 1,
        weekYear: 2020);
  }

  SettingsModel _createInitialMockSettings() {
    return SettingsModel(
        orientation: orientation.Orientation.Portrait,
        completeMark: CompleteMark.Checkmark,
        cancelMark: CancelMark.Cross,
        defaultTimer: DefaultTimer.PieChart,
        timerSeconds: 1,
        activitiesCount: 1,
        theme: GirafTheme.GirafYellow,
        nrOfDaysToDisplay: 1,
        weekDayColors: _createWeekDayColors(),
        lockTimerControl: false,
        pictogramText: false);
  }

  List<WeekdayColorModel> _createWeekDayColors() {
    return <WeekdayColorModel>[
      WeekdayColorModel(day: Weekday.Monday, hexColor: '0xff999999'),
      WeekdayColorModel(day: Weekday.Tuesday, hexColor: '0xffaaaaaa'),
      WeekdayColorModel(day: Weekday.Wednesday, hexColor: '0xffbbbbbb'),
      WeekdayColorModel(day: Weekday.Thursday, hexColor: '0xffcccccc'),
      WeekdayColorModel(day: Weekday.Friday, hexColor: '0xffdddddd'),
      WeekdayColorModel(day: Weekday.Saturday, hexColor: '0xffeeeeee'),
      WeekdayColorModel(day: Weekday.Sunday, hexColor: '0xffffffff'),
    ];
  }

  List<ActivityModel> _createInitialMockActivities() {
    return <ActivityModel>[
      ActivityModel(
          id: 0,
          state: ActivityState.Normal,
          order: 0,
          isChoiceBoard: false,
          pictogram: PictogramModel(
              id: 25,
              title: 'PictogramTitle1',
              accessLevel: AccessLevel.PUBLIC,
              imageHash: null,
              imageUrl: null,
              lastEdit: null)),
      ActivityModel(
          id: 1,
          state: ActivityState.Normal,
          order: 0,
          isChoiceBoard: false,
          pictogram: PictogramModel(
              id: 25,
              title: 'PictogramTitle2',
              accessLevel: AccessLevel.PUBLIC,
              imageHash: null,
              imageUrl: null,
              lastEdit: null)),
      ActivityModel(
          id: 2,
          state: ActivityState.Normal,
          order: 0,
          isChoiceBoard: false,
          pictogram: PictogramModel(
              id: 25,
              title: 'PictogramTitle3',
              accessLevel: AccessLevel.PUBLIC,
              imageHash: null,
              imageUrl: null,
              lastEdit: null),
          timer: TimerModel(
              startTime: DateTime(2020),
              progress: 0,
              fullLength: 10,
              paused: true))
    ];
  }
}

class MockWeekApi extends Mock implements WeekApi {
  MockWeekApi(this._mockWeek);

  WeekModel _mockWeek;

  @override
  Observable<WeekModel> get(String id, int year, int weekNumber) {
    return Observable<WeekModel>.just(_mockWeek);
  }

  @override
  Observable<WeekModel> update(
      String id, int year, int weekNumber, WeekModel weekInput) {
    _mockWeek = weekInput;
    return Observable<WeekModel>.just(_mockWeek);
  }
}

class MockAccountApi extends Mock implements AccountApi {
  @override
  Observable<bool> login(String username, String password) {
    return Observable<bool>.just(true);
  }
}

class MockUserApi extends Mock implements UserApi {
  MockUserApi(this._mockSettings);

  SettingsModel _mockSettings;

  @override
  Observable<GirafUserModel> me() {
    return Observable<GirafUserModel>.just(GirafUserModel(
      id: '1',
      department: 3,
      role: Role.Guardian,
      roleName: 'Guardian',
      displayName: 'Kurt',
      username: 'SpaceLord69',
    ));
  }

  @override
  Observable<SettingsModel> getSettings(String id) {
    return Observable<SettingsModel>.just(_mockSettings);
  }

  @override
  Observable<SettingsModel> updateSettings(String id, SettingsModel settings) {
    _mockSettings = settings;
    return Observable<SettingsModel>.just(_mockSettings);
  }
}

// TODO(eneder17): få tjekket vi ikke bruger add() nogle steder
//  fordi så skal den også mockes
class MockActivityApi extends Mock implements ActivityApi {
  MockActivityApi(this._mockActivities);

  final List<ActivityModel> _mockActivities;

  // Updates the activity with the same id as the input.
  @override
  Observable<ActivityModel> update(ActivityModel activity, String userId) {
    final int amtActivities = _mockActivities.length;

    //We look for the activity with the same id, and update.
    for (int i = 0; i < amtActivities; i++) {
      if (activity.id == _mockActivities[i].id) {
        _mockActivities[i] = activity;
        return Observable<ActivityModel>.just(_mockActivities[i]);
      }
    }
    // Else we just return the activity put in as input
    return Observable<ActivityModel>.just(activity);
  }
}

class MockPictogramApi extends Mock implements PictogramApi {
  @override
  Observable<Image> getImage(int id) {
    //We take the sample image from the test_image.dart file
    final Image mockImage = sampleImage;
    return Observable<Image>.just(mockImage);
  }
}
