import 'package:api_client/api/api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/complete_mark_enum.dart';
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
import 'package:weekplanner/screens/settings_screens/completed_activity_icon_selection_screen.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section_checkboxButton.dart';

class MockUserApi extends Mock implements NavigatorObserver, UserApi {
  @override
  Observable<GirafUserModel> me() {
    return Observable<GirafUserModel>.just(
        GirafUserModel(id: '1', username: 'test', role: Role.Guardian));
  }

  @override
  Observable<SettingsModel> getSettings(String id) {
    final SettingsModel settingsModel = SettingsModel(
        orientation: null,
        completeMark: CompleteMark.Checkmark,
        cancelMark: null,
        defaultTimer: null,
        theme: null,
        nrOfDaysToDisplay: null,
        weekDayColors: null);

    return Observable<SettingsModel>.just(settingsModel);
  }
}

void main() {
  Api api;
  SettingsBloc settingsBloc;
  NavigatorObserver mockObserver;

  final DisplayNameModel user = DisplayNameModel(
      displayName: 'Mickey Mouse', id: '2', role: Role.Citizen.toString());

  setUp(() {
    di.clearAll();
    api = Api('any');
    api.user = MockUserApi();

    settingsBloc = SettingsBloc(api);
    settingsBloc.loadSettings(user);

    di.registerDependency<AuthBloc>((_) => AuthBloc(api));
    di.registerDependency<ToolbarBloc>((_) => ToolbarBloc());
    di.registerDependency<SettingsBloc>((_) => settingsBloc);

    mockObserver = MockUserApi();
  });

  testWidgets('Has completed activity screen been popped',
    (WidgetTester tester) async{
    await tester.pumpWidget(MaterialApp(
        home: CompletedActivityIconScreen(user),
        // ignore: always_specify_types
        navigatorObservers: [mockObserver]
    ));
    verify(mockObserver.didPush(any, any));

    await tester.pumpAndSettle();
    expect(find.byType(SettingsCheckMarkButton), findsNWidgets(3));

    await tester.pump();
    await tester.tap(find.byType(SettingsCheckMarkButton).first);
    await tester.pump();
    verify(mockObserver.didPop(any, any));
  });

}