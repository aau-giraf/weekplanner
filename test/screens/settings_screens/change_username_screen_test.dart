import 'package:api_client/api/api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/screens/settings_screens/change_username_screen.dart';

class MockUserApi extends Mock implements UserApi, NavigatorObserver {
  @override
  Stream<GirafUserModel> me() {
    return Stream<GirafUserModel>.value(
        GirafUserModel(id: '1', username: 'test', role: Role.Guardian));
  }

  @override
  Stream<SettingsModel> getSettings(String id) {
    final SettingsModel settingsModel = SettingsModel(
        orientation: null,
        completeMark: null,
        cancelMark: null,
        defaultTimer: null,
        theme: null,
        nrOfDaysToDisplay: 1,
        weekDayColors: null);

    return Stream<SettingsModel>.value(settingsModel);
  }
}

void main() {
  Api api;
  NavigatorObserver mockObserver;

  final DisplayNameModel user = DisplayNameModel(displayName: "John Hitler", role: Role.Citizen.toString(), id: '1');


  setUp(() {
   di.clearAll();
   api = Api('any');
   api.user = MockUserApi();
   mockObserver = MockUserApi();

   di.registerDependency<AuthBloc>((_) => AuthBloc(api));
   di.registerDependency<SettingsBloc>((_) => SettingsBloc(api));
   di.registerDependency<ToolbarBloc>((_) => ToolbarBloc());
   di.registerDependency<Api>((_) => Api('any'));
  });

  testWidgets("Checks if textfield is present", (WidgetTester tester) async {
   await tester.pumpWidget(MaterialApp(home: ChangeUsernameScreen(user)));
   await tester.pumpAndSettle();
   expect(find.text('Nyt brugernavn'), findsOneWidget);
  });

  testWidgets("Checks if the button is present", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ChangeUsernameScreen(user)));
    await tester.pumpAndSettle();
    expect(find.byType(RaisedButton), findsOneWidget);
  });
  
}