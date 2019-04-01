import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/choose_citizen_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/models/giraf_user_model.dart';
import 'package:weekplanner/providers/api/api.dart';
import 'package:weekplanner/providers/api/user_api.dart';
import 'package:weekplanner/providers/environment_provider.dart';
import 'package:weekplanner/screens/choose_citizen_screen.dart';
import 'package:weekplanner/screens/login_screen.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/widgets/giraf_notify_dialog.dart';

class MockAuthBloc extends Mock implements AuthBloc {
  MockAuthBloc(this._api);

  final Api _api;
  Stream<bool> get loggedIn => _loggedIn.stream;
  BehaviorSubject<bool> _loggedIn = BehaviorSubject.seeded(false);

  @override
  void authenticate(String username, String password) {
    if (username == "test" && password == "test") {
      _loggedIn.add(true);
    } else {
      _loggedIn.add(false);
    }
  }
}

class MockUserApi extends Mock implements UserApi {
  @override
  Observable<GirafUserModel> me() {
    return Observable.just(GirafUserModel(id: "1", username: "test"));
  }
}

void main() {
  String debugEnvironments = '''
    {
      "SERVER_HOST": "http://web.giraf.cs.aau.dk:5000",
      "DEBUG": true,
      "USERNAME": "Graatand",
      "PASSWORD": "password"
    }
    ''';
  String prodEnvironments = '''
    {
      "SERVER_HOST": "http://web.giraf.cs.aau.dk:5000",
      "DEBUG": false
    }
    ''';
  MockAuthBloc bloc;
  Api api;
  setUp(() {
    di.clearAll();
    api = Api("any");
    api.user = MockUserApi();
    bloc = MockAuthBloc(api);
    di.registerDependency<AuthBloc>((_) => bloc);
    di.registerDependency<SettingsBloc>((_) => SettingsBloc());
    di.registerDependency<ChooseCitizenBloc>((_) => ChooseCitizenBloc(api));
  });

  testWidgets("Has Auto-Login button in DEBUG mode",
      (WidgetTester tester) async {
    Environment.setContent(debugEnvironments);
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    expect(find.byKey(Key("AutoLoginKey")), findsOneWidget);
  });

  testWidgets("Has NO Auto-Login button in PRODUCTION mode",
      (WidgetTester tester) async {
    await Environment.setContent(prodEnvironments);
    LoginScreen loginScreen = LoginScreen();
    await tester.pumpWidget(MaterialApp(home: loginScreen));
    expect(find.byKey(Key("AutoLoginKey")), findsNothing);
  });

  testWidgets('Renders LoginScreen', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
  });

  testWidgets("Auto-Login fills Username", (WidgetTester tester) async {
    await Environment.setContent(debugEnvironments);
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    await tester.tap(find.byKey(Key("AutoLoginKey")));
    expect(find.text("Graatand"), findsOneWidget);
  });

  testWidgets("Auto-Login fills Password", (WidgetTester tester) async {
    await Environment.setContent(debugEnvironments);
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    await tester.tap(find.byKey(Key("AutoLoginKey")));
    expect(find.text("password"), findsOneWidget);
  });

  testWidgets("Auto-Login does not fill username if not pressed",
      (WidgetTester tester) async {
    await Environment.setContent(debugEnvironments);
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    expect(find.text("Graatand"), findsNothing);
  });

  testWidgets("Auto-Login does not fill password if not pressed",
      (WidgetTester tester) async {
    await Environment.setContent(debugEnvironments);
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    expect(find.text("password"), findsNothing);
  });

  testWidgets(
      "Logging in with correct information works, and should show a ChooseCitizenScreen",
      (WidgetTester tester) async {
    final Completer<bool> done = Completer<bool>();
    Environment.setContent(debugEnvironments);

    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    await tester.enterText(find.byKey(Key("UsernameKey")), "test");
    await tester.enterText(find.byKey(Key("PasswordKey")), "test");
    await tester.tap(find.byKey(Key("LoginBtnKey")));
    // Since there is a timeout on Login of 2 sec, atleast 2 sec has to be waited here
    await tester.pump(Duration(seconds: 2));

    bloc.loggedIn.listen((bool success) async {
      await tester.pump();
      if (success) {
        expect(find.byType(ChooseCitizenScreen), findsOneWidget);
        done.complete(true);
      }
    });
    await done.future;
  });

  testWidgets(
      "Logging in with wrong information should show a GirafNotifyDialog",
      (WidgetTester tester) async {
    final Completer<bool> done = Completer<bool>();
    Environment.setContent(debugEnvironments);

    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    await tester.enterText(find.byKey(Key("UsernameKey")), "SomwWrongLogin");
    await tester.enterText(find.byKey(Key("PasswordKey")), "SomeWrongPassword");
    await tester.tap(find.byKey(Key("LoginBtnKey")));
    // Since there is a timeout on Login of 2 sec, atleast 2 sec has to be waited here
    await tester.pump(Duration(seconds: 2));
    bloc.loggedIn.listen((bool success) async {
      await tester.pump();
      if (!success) {
        expect(find.byType(GirafNotifyDialog), findsOneWidget);
        done.complete(true);
      } else if (success) {
        expect(find.byType(ChooseCitizenScreen), findsNothing);
        done.complete(false);
      }
    });
    await done.future;
  });
}
