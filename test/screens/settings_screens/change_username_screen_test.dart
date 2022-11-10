import 'dart:async';
import 'dart:io';

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
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/screens/settings_screens/change_username_screen.dart';
import 'package:weekplanner/providers/environment_provider.dart' as environment;
import 'package:weekplanner/style/font_size.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/giraf_notify_dialog.dart';
import 'package:weekplanner/widgets/giraf_title_header.dart';

import '../../widgets/giraf_app_bar_widget_test.dart';

class MockChangeUsernameScreen extends ChangeUsernameScreen {
  MockChangeUsernameScreen(DisplayNameModel user) : super(user);

  @override
  void usernameConfirmationDialog(Stream<GirafUserModel> girafUser){
    showDialog<Center>(
        barrierDismissible: false,
        context: currentContext,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: const EdgeInsets.all(0.0),
            title: Center(
                child: GirafTitleHeader( title: "Verificer bruger", )),
            content: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Text('For at skifte brugernavn, indtast dit kodeord for \n${authBloc.loggedInUsername}',
                      style: TextStyle(
                        fontSize: GirafFont.small,
                      ),
                    ),
                  ),
                  TextFormField(
                    key: const Key('UsernameConfirmationDialogPasswordForm'),
                    obscureText: true,
                    controller: confirmUsernameCtrl,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'Kodeord',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.fromLTRB(0, 15, 0, 0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GirafButton(
                          key: const Key('UsernameConfirmationDialogCancelButton'),
                          text: "Fortryd",
                          width: 121,
                          icon: const ImageIcon(
                            AssetImage('assets/icons/cancel.png'),
                          ),
                          onPressed: () => Navigator.pop(context)
                      ),
                      GirafButton(
                          key: const Key('UsernameConfirmationDialogSaveButton'),
                          text: "Gem",
                          width: 121,
                          icon: const ImageIcon(
                              AssetImage('assets/icons/accept.png'),
                          ),
                          onPressed: () async {
                            loginStatus = false;

                            /// This authenticates the user with username and password.
                            await authBloc.authenticateFromPopUp(authBloc.loggedInUsername, confirmUsernameCtrl.text)
                                .then((dynamic result) {
                              StreamSubscription<bool> loginListener;
                              loginListener = authBloc.loggedIn.listen((bool snapshot) {
                                loginStatus = snapshot;
                                if (snapshot) {
                                  /// Pop the loading spinner doesnt work because we are in a pop-up

                                  updateUser(girafUser);
                                  Routes.pop(currentContext);
                                }
                                /// Stop listening for future logins
                                loginListener.cancel();
                              });
                            }).catchError((Object error) {
                              if(error is ApiException){
                                creatingErrorDialog("Forkert adgangskode.", error.errorKey.toString());
                              } else if(error is SocketException){
                                authBloc.checkInternetConnection().then((bool hasInternetConnection) {
                                  if (hasInternetConnection) {
                                    /// Checking server connection, if true check username/password
                                    authBloc.getApiConnection().then((bool hasServerConnection) {
                                      if (hasServerConnection) {
                                        unknownErrorDialog(error.message);
                                      }
                                      else{
                                        creatingErrorDialog(
                                            'Der er i øjeblikket ikke forbindelse til serveren.',
                                            'ServerConnectionError');
                                      }
                                    }).catchError((Object error){
                                      unknownErrorDialog(error.toString());
                                    });
                                  } else {
                                    creatingErrorDialog(
                                        'Der er ingen forbindelse til internettet.',
                                        'NoConnectionToInternet');
                                  }
                                });
                              } else {
                                unknownErrorDialog('UnknownError');
                              }
                            });
                          }
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }
    );
  }

  /// Function that creates the notify dialog,
  /// depeninding which login error occured
  void creatingErrorDialog(String description, String key) {
    /// Show the new NotifyDialog
    showDialog<Center>(
        barrierDismissible: false,
        context: currentContext,
        builder: (BuildContext context) {
          return GirafNotifyDialog(
              title: 'Fejl', description: description, key: Key(key));
        });
  }
}

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

void main() {
  Api api;
  MockAuthBloc authBloc;
  NavigatorObserver mockObserver;

  final DisplayNameModel user = DisplayNameModel(displayName: "John", role: Role.Citizen.toString(), id: '1');

  setUp(() {
   di.clearAll();
   api = Api('any');
   api.user = MockUserApi();
   authBloc = MockAuthBloc(api);
   mockObserver = MockUserApi();

   di.registerDependency<AuthBloc>((_) => AuthBloc(api));
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
    await tester.pumpWidget(MaterialApp(home: ChangeUsernameScreen(user)));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('UsernameKey')), 'test');
    await tester.tap(find.byKey(const Key('SaveUsernameKey')));
    await tester.pump();

    await expect(find.byKey(const Key('UsernameConfirmationDialogPasswordForm')), findsOneWidget);
    await expect(find.byKey(const Key('UsernameConfirmationDialogSaveButton')), findsOneWidget);
    await tester.enterText(find.byKey(const Key('UsernameConfirmationDialogPasswordForm')), 'wrongPassword');
    await tester.tap(find.byKey(const Key('UsernameConfirmationDialogSaveButton')));
    await tester.pump();
  });


  test("Login to confirm user is a guardian, causing error", () async{
    final mockLoginScreen = MockChangeUsernameScreen(user);

    when(authBloc.authenticateFromPopUp("someUsername", "somePassword")).thenAnswer((_) => Future.error(ApiException));


    //expect(authBloc.authenticateFromPopUp("someUsername", "somePassword"), find.wid)

  });





}