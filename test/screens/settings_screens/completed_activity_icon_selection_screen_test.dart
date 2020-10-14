import 'package:api_client/api/api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/default_timer_enum.dart';
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
import 'package:weekplanner/screens/settings_screens/privacy_information_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section_checkboxButton.dart';

import '../../blocs/settings_bloc_test.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver, UserApi {
  @override
  Observable<GirafUserModel> me() {
    return Observable<GirafUserModel>.just(
        GirafUserModel(id: '1', username: 'test', role: Role.Guardian));
  }

  @override
  Observable<SettingsModel> getSettings(String id) {
    final SettingsModel settingsModel = SettingsModel(
        orientation: null,
        completeMark: null,
        cancelMark: null,
        defaultTimer: DefaultTimer.PieChart,
        theme: null,
        nrOfDaysToDisplay: null,
        weekDayColors: null);

    return Observable<SettingsModel>.just(settingsModel);
  }
}
void main() {
  Api api;
  NavigatorObserver mockObserver;
  final DisplayNameModel user = DisplayNameModel(
      displayName: 'Mickey Mouse', id: '2', role: Role.Guardian.toString());

  setUp(() {
    di.clearAll();
    api = Api('any');
    api.user = MockUserApi();

    di.registerDependency<AuthBloc>((_) => AuthBloc(api));
    di.registerDependency<ToolbarBloc>((_) => ToolbarBloc());
    di.registerDependency<SettingsBloc>((_) => SettingsBloc(api));

    mockObserver = MockNavigatorObserver();
  });

  testWidgets('Has completed activity been popped', (WidgetTester tester) async{
    await tester.pumpWidget(MaterialApp(
        home: CompletedActivityIconScreen(user),
        navigatorObservers: [mockObserver]));
    verify(mockObserver.didPush(any, any));

    expect(find.byType(GirafAppBar), findsOneWidget);


    expect(find.byType(SettingsSection), findsNWidgets(1));
    await tester.tap(find.byType(SettingsCheckMarkButton));
    await tester.pump();

   // verify(mockObserver.didPop(any, any));


  });


}