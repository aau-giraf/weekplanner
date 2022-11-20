import 'dart:async';

import 'package:api_client/api/api.dart';
import 'package:api_client/api/api_exception.dart';
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
import 'package:weekplanner/screens/settings_screens/change_password_screen.dart';
import 'package:weekplanner/screens/settings_screens/change_username_screen.dart';
import 'package:weekplanner/widgets/giraf_notify_dialog.dart';
import 'package:weekplanner/widgets/giraf_title_header.dart';

import '../../blocs/auth_bloc.test.dart';

class MockUserApi extends Mock implements UserApi, NavigatorObserver {
  @override
  Stream<GirafUserModel> me() {
    return Stream<GirafUserModel>.value(
        GirafUserModel(id: '1', username: 'test', role: Role.Guardian));
  }
}

class MockAuthBloc extends Mock implements AuthBloc {
  @override
  String loggedInUsername = "testUsername";
  String password = "password";
}

void main() {
  Api api;
  MockAuthBloc authBloc;
  NavigatorObserver mockObserver;
  SettingsBloc settingsBloc;

  final DisplayNameModel user = DisplayNameModel(
      displayName: "John", role: Role.Citizen.toString(), id: '1');

  setUp(() {
    di.clearAll();
    api = Api('any');
    api.user = MockUserApi();
    api.account = MockAccountApi();
    authBloc = MockAuthBloc();
    mockObserver = MockUserApi();
    _mockContext = MockBuildContext();

    di.registerDependency<AuthBloc>((_) => MockAuthBloc());
    di.registerDependency<SettingsBloc>((_) => SettingsBloc(api));
    di.registerDependency<ToolbarBloc>((_) => ToolbarBloc());
    di.registerDependency<Api>((_) => api);
  });

  testWidgets("Checks if textfield is present", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ChangePasswordScreen(user)));
    await tester.pumpAndSettle();
    expect(find.byKey(Key("OldPasswordKey")), findsOneWidget);
    expect(find.byKey(Key("NewPasswordKey")), findsOneWidget);
    expect(find.byKey(Key("RepeatedPasswordKey")), findsOneWidget);
  });

  testWidgets("Checks if the button is present", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ChangePasswordScreen(user)));
    await tester.pumpAndSettle();
    expect(find.byType(RaisedButton), findsOneWidget);
  });

  testWidgets("EMPTY new password ERROR", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ChangePasswordScreen(user)));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('OldPasswordKey')), 'password');
    await tester.enterText(find.byKey(const Key('NewPasswordKey')), '');
    await tester.enterText(find.byKey(const Key('RepeatedPasswordKey')), '');
    await tester.tap(find.byKey(const Key('ChangePasswordBtnKey')));
    await tester.pump();

    expect(find.byType(GirafNotifyDialog), findsOneWidget);
    expect(find.byKey(Key("NewPasswordEmpty")), findsOneWidget);
  });

  testWidgets("new password same as old password ERROR",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ChangePasswordScreen(user)));
    await tester.pump();

    await tester.enterText(
        find.byKey(const Key('OldPasswordKey')), 'testPassword');
    await tester.enterText(
        find.byKey(const Key('NewPasswordKey')), 'testPassword');
    await tester.enterText(
        find.byKey(const Key('RepeatedPasswordKey')), 'testPassword');
    await tester.tap(find.byKey(const Key('ChangePasswordBtnKey')));
    await tester.pump();

    expect(find.byType(GirafNotifyDialog), findsOneWidget);
    expect(find.byKey(Key("NewPasswordSameAsOld")), findsOneWidget);
  });

  testWidgets("repeated password same as new password ERROR",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ChangePasswordScreen(user)));
    await tester.pump();

    await tester.enterText(
        find.byKey(const Key('OldPasswordKey')), 'testPassword');
    await tester.enterText(
        find.byKey(const Key('NewPasswordKey')), 'newTestPassword');
    await tester.enterText(
        find.byKey(const Key('RepeatedPasswordKey')), 'newTestPassword1');
    await tester.tap(find.byKey(const Key('ChangePasswordBtnKey')));
    await tester.pump();

    expect(find.byType(GirafNotifyDialog), findsOneWidget);
    expect(find.byKey(Key("NewPasswordNotRepeated")), findsOneWidget);
  });

  testWidgets("test ChangePassword-method", (WidgetTester tester) async {
    final screen = ChangePasswordScreen(user);

    await tester.pumpWidget(MaterialApp(home: screen));
    await tester.enterText(
        find.byKey(const Key('OldPasswordKey')), 'testPassword');
    await tester.enterText(
        find.byKey(const Key('NewPasswordKey')), 'newTestPassword');
    await tester.enterText(
        find.byKey(const Key('RepeatedPasswordKey')), 'newTestPassword');

    await tester.tap(find.byKey(const Key('ChangePasswordBtnKey')));
    await tester.pump();

    expect(find.byType(GirafNotifyDialog), findsOneWidget);
    expect(find.byKey(const Key('PasswordChanged')), findsOneWidget);
  });
}
