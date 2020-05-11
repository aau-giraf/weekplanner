import 'package:api_client/api/api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/screens/settings_screens/privacy_information_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

SettingsModel mockSettings;

class MockUserApi extends Mock implements UserApi {
  @override
  Observable<GirafUserModel> me() {
    return Observable<GirafUserModel>.just(
        GirafUserModel(id: '1', username: 'test', role: Role.Guardian));
  }

  @override
  Observable<SettingsModel> getSettings(String id) {
    return Observable<SettingsModel>.just(mockSettings);
  }
}

void main() {
  Api api;
  SettingsBloc settingsBloc;

  final DisplayNameModel user = DisplayNameModel(
      displayName: 'Hans Hansen', id: '12', role: Role.Guardian.toString());

  setUp(() {
    api = Api('any');
    api.user = MockUserApi();
    settingsBloc = SettingsBloc(api);

    mockSettings = SettingsModel(
        orientation: null,
        completeMark: null,
        cancelMark: null,
        defaultTimer: null,
        theme: null,
        nrOfDaysToDisplay: 1,
        pictogramText: false,
        lockTimerControl: false);

    when(api.user.updateSettings(any, any)).thenAnswer((_) {
      return Observable<SettingsModel>.just(mockSettings);
    });

    di.clearAll();
    di.registerDependency<AuthBloc>((_) => AuthBloc(api));
    di.registerDependency<ToolbarBloc>((_) => ToolbarBloc());
    di.registerDependency<SettingsBloc>((_) => settingsBloc);
  });

  testWidgets('Renders  PrivacyInformationScreen', (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: PrivacyInformationScreen()));
    expect(find.byType(PrivacyInformationScreen), findsOneWidget);
  });

  testWidgets('Has GirafAppBar', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: PrivacyInformationScreen()));
    expect(
        find.byWidgetPredicate((Widget widget) =>
        widget is GirafAppBar && widget.title == 'Privatlivsinformation'),
        findsOneWidget);
    expect(find.byType(GirafAppBar), findsOneWidget);
  });

  testWidgets('Has ScrollView',
          (WidgetTester tester) async {
            await tester
                .pumpWidget(MaterialApp(home: PrivacyInformationScreen()));
            await tester.pumpAndSettle();
            expect(find.byType(SingleChildScrollView), findsOneWidget);
          });
}