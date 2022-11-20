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
import 'package:rxdart/rxdart.dart' as rx_dart;
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
  Stream<bool> get loggedIn => _loggedIn.stream;
  final rx_dart.BehaviorSubject<bool> _loggedIn =
      rx_dart.BehaviorSubject<bool>.seeded(false);

  @override
  String loggedInUsername;

  @override
  Future<void> authenticate(String username, String password) async {
    // Mock the API and allow these 2 users to ?login?
    final bool status = username == 'test' && password == 'test';
    // If there is a successful login, remove the loading spinner,
    // and push the status to the stream
    if (status) {
      loggedInUsername = username;
    }
    _loggedIn.add(status);
  }
}

class MockChangePasswordScreen extends ChangePasswordScreen {
  MockChangePasswordScreen(DisplayNameModel user) : super(user);
  @override
  void ChangePassword(
      DisplayNameModel user, String oldPassword, String newPassword) {
    //currentContext = context;
    authBloc.authenticate("test", currentPasswordCtrl.text);

    authBloc.loggedIn.listen((bool snapshot) {
      loginStatus = snapshot;
      if (snapshot == false) {
        CreateDialog('Forkert adgangskode.', 'The old password is wrong',
            Key("WrongPassword"));
      } else if (snapshot) {
        CreateDialog("Kodeord ændret", "Dit kodeord er blevet ændret",
            Key("PasswordChanged"));
      }
    });
  }
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
    mockObserver = MockUserApi();

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
    final screen = MockChangePasswordScreen(user);
    await tester.pumpWidget(MaterialApp(home: screen));
    await tester.pump();
    await tester.enterText(find.byKey(const Key('OldPasswordKey')), 'test');
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
