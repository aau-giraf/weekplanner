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
import 'package:weekplanner/screens/settings_screens/change_username_screen.dart';
import 'package:weekplanner/widgets/giraf_notify_dialog.dart';
import 'package:weekplanner/widgets/giraf_title_header.dart';


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
    );

    return Stream<SettingsModel>.value(settingsModel);
  }
}

class MockAuthBloc extends Mock implements AuthBloc {
  @override String loggedInUsername = "testUsername";
}

void main() {
  Api api;
  MockAuthBloc authBloc;
  NavigatorObserver mockObserver;

  final DisplayNameModel user = DisplayNameModel(displayName: "John", role: Role.Citizen.toString(), id: '1');

  setUp(() {
   di.clearAll();
   api = Api('any');
   api.user = MockUserApi();
   authBloc = MockAuthBloc();
   mockObserver = MockUserApi();

   di.registerDependency<AuthBloc>((_) => MockAuthBloc());
   di.registerDependency<SettingsBloc>((_) => SettingsBloc(api));
   di.registerDependency<ToolbarBloc>((_) => ToolbarBloc());
   di.registerDependency<Api>((_) => Api('any'));
  });

  testWidgets("Checks if text is present", (WidgetTester tester) async {
   await tester.pumpWidget(MaterialApp(home: ChangeUsernameScreen(user)));
   await tester.pumpAndSettle();
   expect(find.text('Nyt brugernavn'), findsOneWidget);
  });

  testWidgets("Checks if the textfield is present", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ChangeUsernameScreen(user)));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets("Checks if the button is present", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ChangeUsernameScreen(user)));
    await tester.pumpAndSettle();
    expect(find.byType(RaisedButton), findsOneWidget);
  });

  testWidgets("EMPTY new Username ERROR", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ChangeUsernameScreen(user)));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('UsernameKey')), '');
    await tester.tap(find.byKey(const Key('SaveUsernameKey')));
    await tester.pump();

    expect(find.byType(GirafNotifyDialog), findsOneWidget);
    expect(find.text("Udfyld venligst nyt brugernavn."), findsOneWidget);
  });

  testWidgets("new Username same as old username ERROR", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ChangeUsernameScreen(user)));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('UsernameKey')), 'John');
    await tester.tap(find.byKey(const Key('SaveUsernameKey')));
    await tester.pump();

    expect(find.byType(GirafNotifyDialog), findsOneWidget);
    expect(find.text("Nyt brugernavn må ikke være det samme som det nuværende brugernavn."), findsOneWidget);
  });

  testWidgets("Opens the UsernameConfirmationDialog", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ChangeUsernameScreen(user)));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('UsernameKey')), 'test');
    await tester.tap(find.byKey(const Key('SaveUsernameKey')));
    await tester.pump();

    await expect(find.widgetWithText(GirafTitleHeader, "Verificer bruger"), findsOneWidget);
    await expect(find.byKey(const Key('UsernameConfirmationDialogPasswordForm')), findsOneWidget);
    await expect(find.byKey(const Key('UsernameConfirmationDialogSaveButton')), findsOneWidget);
  });

  testWidgets("Login to confirm user is a Guardian (wrong password), causing ApiException error", (WidgetTester tester) async {
    final screen = ChangeUsernameScreen(user);
    when(screen.authBloc.authenticateFromPopUp("testUsername", "testPassword")).thenAnswer((_) => Future.error(ApiException));
    
    await tester.pumpWidget(MaterialApp(home: screen));
    await tester.pump();
    await tester.enterText(find.byKey(const Key('UsernameKey')), 'testUsername');
    await tester.tap(find.byKey(const Key('SaveUsernameKey')));
    await tester.pump();

    await expect(find.byKey(const Key('UsernameConfirmationDialogPasswordForm')), findsOneWidget);
    await expect(find.byKey(const Key('UsernameConfirmationDialogSaveButton')), findsOneWidget);
    await tester.enterText(find.byKey(const Key('UsernameConfirmationDialogPasswordForm')), 'testPassword');
    await tester.tap(find.byKey(const Key('UsernameConfirmationDialogSaveButton')));
    await tester.pump();

    verify(screen.authBloc.authenticateFromPopUp("testUsername", "testPassword")).called(1);
    expect(find.byType(GirafNotifyDialog), findsOneWidget);
  });


  testWidgets("Login to confirm user is a Guardian, no error", (WidgetTester tester) async {
    final screen = ChangeUsernameScreen(user);
    when(screen.authBloc.authenticateFromPopUp("testUsername", "testPassword")).thenAnswer((_) => Future.value(true));
    when(screen.authBloc.loggedIn).thenAnswer((realInvocation) => Stream.value(true));

    await tester.pumpWidget(MaterialApp(home: screen));
    await tester.pump();
    await tester.enterText(find.byKey(const Key('UsernameKey')), 'testUsername');
    await tester.tap(find.byKey(const Key('SaveUsernameKey')));
    await tester.pump();

    await expect(find.byKey(const Key('UsernameConfirmationDialogPasswordForm')), findsOneWidget);
    await expect(find.byKey(const Key('UsernameConfirmationDialogSaveButton')), findsOneWidget);
    await tester.enterText(find.byKey(const Key('UsernameConfirmationDialogPasswordForm')), 'testPassword');
    await tester.tap(find.byKey(const Key('UsernameConfirmationDialogSaveButton')));
    await tester.pump();

    verify(screen.authBloc.authenticateFromPopUp("testUsername", "testPassword")).called(1);
    verify(screen.authBloc.loggedIn);

    expect(find.byKey(const Key('UsernameKey')), findsOneWidget);
  });


}