import 'dart:async';
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
import 'package:weekplanner/widgets/giraf_notify_dialog.dart';
import 'package:weekplanner/widgets/giraf_title_header.dart';
import 'package:rxdart/rxdart.dart' as rx_dart;

SettingsModel mockSettings;

class MockUserApi extends Mock implements UserApi, NavigatorObserver {
  @override
  Stream<GirafUserModel> me() {
    return Stream<GirafUserModel>.value(
        GirafUserModel(id: '1', username: 'usernameTest', role: Role.Guardian));
  }

  @override
  Stream<SettingsModel> getSettings(String id) {
    return Stream<SettingsModel>.value(mockSettings);
  }
}

class MockAuthBloc extends Mock implements AuthBloc {
  @override
  Stream<bool> get loggedIn => _loggedIn.stream;
  final rx_dart.BehaviorSubject<bool> _loggedIn = rx_dart.BehaviorSubject<bool>
      .seeded(false);

  @override String loggedInUsername = 'testUsername';

  @override
  Future<void> authenticateFromPopUp(String username, String password) async {
    // Mock the API and allow these 2 users to ?login?
    final bool status = username == 'testUsername' && password == 'test';
    // If there is a successful login, remove the loading spinner,
    // and push the status to the stream
    _loggedIn.add(status);
  }
}

class MockChangeUsernameScreen extends ChangeUsernameScreen{
  MockChangeUsernameScreen(DisplayNameModel user) : super(user);

    @override
    void confirmUser(Stream<GirafUserModel> girafUser) {
        authBloc.authenticateFromPopUp(
            authBloc.loggedInUsername, confirmUsernameCtrl.text);

        authBloc.loggedIn.listen((bool snapshot) {
          loginStatus = snapshot;
          if(snapshot){
            showDialog<Center>(
                barrierDismissible: false,
                context: currentContext,
                builder: (BuildContext context) {
                  return const GirafNotifyDialog(
                      title: 'Brugernavn er gemt',
                      description: 'Dine ændringer er blevet gemt',
                      key: Key('ChangesCompleted'));
                });
          }else if (snapshot == false) {
            creatingErrorDialog(
                'Forkert adgangskode.', 'WrongPassword');
          }
        });
    }
}


void main() {
  Api api;
  SettingsBloc settingsBloc;

  final DisplayNameModel user = DisplayNameModel(
      displayName: 'John', role: Role.Citizen.toString(), id: '1');

  setUp(() {
   di.clearAll();
   api = Api('any');
   api.user = MockUserApi();

   di.registerDependency<AuthBloc>((_) => MockAuthBloc());
   di.registerDependency<ToolbarBloc>((_) => ToolbarBloc());
   settingsBloc = SettingsBloc(api);
   settingsBloc.loadSettings(user);
   di.registerDependency<SettingsBloc>((_) => settingsBloc);
   di.registerDependency<Api>((_) => api);
  });

  testWidgets('Checks if text is present', (WidgetTester tester) async {
   await tester.pumpWidget(MaterialApp(home: ChangeUsernameScreen(user)));
   await tester.pumpAndSettle();
   expect(find.text('Nyt brugernavn'), findsOneWidget);
  });

  testWidgets('Checks if the textfield is present',
          (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ChangeUsernameScreen(user)));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('Checks if the button is present', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ChangeUsernameScreen(user)));
    await tester.pumpAndSettle();
    expect(find.byType(RaisedButton), findsOneWidget);
  });

  testWidgets('EMPTY new Username, causing error pop-up',
          (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ChangeUsernameScreen(user)));
    await tester.pump();
    await tester.enterText(find.byKey(const Key('UsernameKey')), '');
    await tester.tap(find.byKey(const Key('SaveUsernameKey')));
    await tester.pump();

    expect(find.byType(GirafNotifyDialog), findsOneWidget);
    expect(find.byKey(const Key('NewUsernameEmpty')), findsOneWidget);
  });

  testWidgets('new Username same as old username ERROR',
          (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ChangeUsernameScreen(user)));
    await tester.pump();
    await tester.enterText(find.byKey(
        const Key('UsernameKey')), 'usernameTest');
    await tester.tap(find.byKey(const Key('SaveUsernameKey')));
    await tester.pump();

    expect(find.byType(GirafNotifyDialog), findsOneWidget);
    expect(find.byKey(const Key('NewUsernameEqualOld')), findsOneWidget);
  });

  testWidgets('Opens the UsernameConfirmationDialog',
          (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ChangeUsernameScreen(user)));
    await tester.pump();
    await tester.enterText(find.byKey(const Key('UsernameKey')), 'John');
    await tester.tap(find.byKey(const Key('SaveUsernameKey')));
    await tester.pump();

    expect(find.widgetWithText(
        GirafTitleHeader, 'Verificer bruger'), findsOneWidget);
    expect(find.byKey(
        const Key('UsernameConfirmationDialogPasswordForm')), findsOneWidget);
    expect(find.byKey(
        const Key('UsernameConfirmationDialogSaveButton')), findsOneWidget);
  });
  
  testWidgets('Login to confirm user is a Guardian (wrong password) '
      'should show a GirafNotifyDialog', (WidgetTester tester) async {
      await tester.pumpWidget(
          MaterialApp(home: MockChangeUsernameScreen(user)));
      await tester.pump();
      await tester.enterText(
          find.byKey(const Key('UsernameKey')), 'WrongUsername');
      await tester.tap(find.byKey(const Key('SaveUsernameKey')));
      await tester.pump();

      expect(find.byKey(
          const Key('UsernameConfirmationDialogPasswordForm')), findsOneWidget);
      expect(find.byKey(
          const Key('UsernameConfirmationDialogSaveButton')), findsOneWidget);
      await tester.enterText(find.byKey(const
      Key('UsernameConfirmationDialogPasswordForm')), 'WrongPassword');
      await tester.tap(find.byKey(
          const Key('UsernameConfirmationDialogSaveButton')));
      await tester.pump();

      expect(find.byType(GirafNotifyDialog), findsOneWidget);
      expect(find.byKey(const Key('WrongPassword')), findsOneWidget);
  });

  testWidgets('Login to confirm user is a Guardian and updating username, '
      'should update loggedInUsername', (WidgetTester tester) async {
    final MockChangeUsernameScreen screen = MockChangeUsernameScreen(user);
    await tester.pumpWidget(MaterialApp(home: screen));
    await tester.pump();
    await tester.enterText(find.byKey(const Key('UsernameKey')), 'test');
    await tester.tap(find.byKey(const Key('SaveUsernameKey')));
    await tester.pump();

    expect(find.byKey(const Key(
        'UsernameConfirmationDialogPasswordForm')), findsOneWidget);
    expect(find.byKey(const Key(
        'UsernameConfirmationDialogSaveButton')), findsOneWidget);
    await tester.enterText(find.byKey(const Key(
        'UsernameConfirmationDialogPasswordForm')), 'test');
    await tester.tap(find.byKey(const Key(
        'UsernameConfirmationDialogSaveButton')));
    await tester.pump();

    expect(find.byType(GirafNotifyDialog), findsOneWidget);
    expect(find.byKey(const Key('ChangesCompleted')), findsOneWidget);
  });
}