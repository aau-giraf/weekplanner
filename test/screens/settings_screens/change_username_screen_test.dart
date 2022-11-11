import 'dart:async';
import 'dart:io';
import 'package:api_client/api/api.dart';
import 'package:api_client/api/api_exception.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/error_key.dart';
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
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/settings_screens/change_username_screen.dart';
import 'package:weekplanner/widgets/giraf_notify_dialog.dart';
import 'package:weekplanner/widgets/giraf_title_header.dart';

import 'package:rxdart/rxdart.dart' as rx_dart;
/*
class MockChangeUsernameScreen extends Mock implements ChangeUsernameScreen {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    super.toString();
  }
}

 */

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
  /*
  @override
  Stream<bool> get loggedIn => _loggedIn.stream;
  final rx_dart.BehaviorSubject<bool> _loggedIn = rx_dart.BehaviorSubject<bool>
      .seeded(false);

  @override
  String loggedInUsername;

  @override
  Future<void> authenticateFromPopUp(String username, String password) async {
    // Mock the API and allow these 2 users to ?login?
    final bool status = (username == 'testUsername' && password == 'testPassword');
    // If there is a successful login, remove the loading spinner,
    // and push the status to the stream
    if (status) {
      loggedInUsername = username;
    }
    _loggedIn.add(status);
  }
  */
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

  testWidgets("Login to confirm user is a guardian, no error", (WidgetTester tester) async {
    final screen = ChangeUsernameScreen(user);
    await tester.pumpWidget(MaterialApp(home: screen));

    when(screen.authBloc.authenticateFromPopUp("someUsername", "somePassword")).thenAnswer((_) => Future.error(ApiException));

    await tester.pump();

    await tester.enterText(find.byKey(const Key('UsernameKey')), 'testUsername');
    await tester.tap(find.byKey(const Key('SaveUsernameKey')));
    await tester.pump();

    await expect(find.byKey(const Key('UsernameConfirmationDialogPasswordForm')), findsOneWidget);
    await expect(find.byKey(const Key('UsernameConfirmationDialogSaveButton')), findsOneWidget);
    await tester.enterText(find.byKey(const Key('UsernameConfirmationDialogPasswordForm')), 'testPassword');
    await tester.tap(find.byKey(const Key('UsernameConfirmationDialogSaveButton')));
    await tester.pump();


    //expect(find.byKey(const Key('')), findsOneWidget);
    //expect(find.byType(GirafNotifyDialog), findsOneWidget);

    //verify(authBloc.authenticateFromPopUp("someUsername", "somePassword"));

    //verify(authBloc.authenticateFromPopUp("someUsername", "somePassword"));
    verify(authBloc);

    //expect(find.text("Forkert adgangskode."), findsOneWidget);
    //expect(find.text("Der er i øjeblikket ikke forbindelse til serveren."), findsOneWidget);
  });


  test("Login to confirm user is a guardian, causing error", () async{
    //final mockLoginScreen = MockChangeUsernameScreen();
      
    

    //mockLoginScreen.usernameConfirmationDialog(user);


    when(authBloc.authenticateFromPopUp("someUsername", "somePassword")).thenAnswer((_) => Future.error(ApiException));



    //expect(authBloc.authenticateFromPopUp("someUsername", "somePassword"), find.byKey(Key(ErrorKey.InvalidCredentials.toString())));



  });





}