import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/choose_citizen_bloc.dart';
import 'package:weekplanner/providers/api/api.dart';
import 'package:weekplanner/providers/environment_provider.dart' as environment;
import 'package:weekplanner/screens/login_screen.dart';
import 'package:weekplanner/di.dart';

class MockAuthBloc extends Mock implements AuthBloc {
  @override
  Stream<bool> get loggedIn => _loggedIn.stream;
  final BehaviorSubject<bool> _loggedIn = BehaviorSubject<bool>.seeded(false);

  @override
  void authenticate(String username, String password) {
    if (username == 'test' && password == 'test') {
      _loggedIn.add(true);
    } else {
      _loggedIn.add(false);
    }
  }
}

void main() {
  const String debugEnvironments = '''
    {
      "SERVER_HOST": "http://web.giraf.cs.aau.dk:5000",
      "DEBUG": true,
      "USERNAME": "Graatand",
      "PASSWORD": "password"
    }
    ''';
  const String prodEnvironments = '''
    {
      "SERVER_HOST": "http://web.giraf.cs.aau.dk:5000",
      "DEBUG": false
    }
    ''';
  MockAuthBloc bloc;
  setUp(() {
    bloc = MockAuthBloc();
    di.clearAll();
    di.registerDependency<AuthBloc>((_) => bloc);
    di.registerDependency<ChooseCitizenBloc>(
        (_) => ChooseCitizenBloc(Api('Any')));
  });

  testWidgets('Has Auto-Login button in DEBUG mode',
      (WidgetTester tester) async {
    environment.setContent(debugEnvironments);
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    expect(find.byKey(const Key('AutoLoginKey')), findsOneWidget);
  });

  testWidgets('Has NO Auto-Login button in PRODUCTION mode',
      (WidgetTester tester) async {
    environment.setContent(prodEnvironments);
    final LoginScreen loginScreen = LoginScreen();
    await tester.pumpWidget(MaterialApp(home: loginScreen));
    expect(find.byKey(const Key('AutoLoginKey')), findsNothing);
  });

  testWidgets('Renders LoginScreen (DEBUG)', (WidgetTester tester) async {
    environment.setContent(debugEnvironments);
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('Renders LoginScreen (PROD)', (WidgetTester tester) async {
    environment.setContent(prodEnvironments);
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('Auto-Login fills Username', (WidgetTester tester) async {
    environment.setContent(debugEnvironments);
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    await tester.tap(find.byKey(const Key('AutoLoginKey')));
    expect(find.text('Graatand'), findsOneWidget);
  });

  testWidgets('Auto-Login fills Password', (WidgetTester tester) async {
    environment.setContent(debugEnvironments);
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    await tester.tap(find.byKey(const Key('AutoLoginKey')));
    expect(find.text('password'), findsOneWidget);
  });

  testWidgets('Auto-Login does not fill username if not pressed',
      (WidgetTester tester) async {
    environment.setContent(debugEnvironments);
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    expect(find.text('Graatand'), findsNothing);
  });

  testWidgets('Auto-Login does not fill password if not pressed',
      (WidgetTester tester) async {
    environment.setContent(debugEnvironments);
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    expect(find.text('password'), findsNothing);
  });

  testWidgets('Logging in works (PROD)', (WidgetTester tester) async {
    environment.setContent(prodEnvironments);

    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    await tester.enterText(find.byKey(const Key('UsernameKey')), 'test');
    await tester.enterText(find.byKey(const Key('PasswordKey')), 'test');
    await tester.tap(find.byKey(const Key('LoginBtnKey')));
    await tester.pump(const Duration(seconds: 5));

    bloc.loggedIn.listen((bool success) async {
      await tester.pump();
      expect(success, equals(true));
    });
  });

  testWidgets('Logging in works (DEBUG)', (WidgetTester tester) async {
    environment.setContent(debugEnvironments);
    final Completer<bool> done = Completer<bool>();

    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    await tester.enterText(find.byKey(const Key('UsernameKey')), 'test');
    await tester.enterText(find.byKey(const Key('PasswordKey')), 'test');
    await tester.tap(find.byKey(const Key('LoginBtnKey')));
    await tester.pump(const Duration(seconds: 5));

    bloc.loggedIn.listen((bool success) async {
      await tester.pump();
      expect(success, equals(true));
    });
    await done.future;
  });

  testWidgets(
      'Logging in with wrong information should show a GirafNotifyDialog',
      (WidgetTester tester) async {
    environment.setContent(debugEnvironments);
    final Completer<bool> done = Completer<bool>();

    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    await tester.enterText(
        find.byKey(const Key('UsernameKey')), 'SomeWrongUsername');
    await tester.enterText(
        find.byKey(const Key('PasswordKey')), 'SomeWrongPassword');
    await tester.tap(find.byKey(const Key('LoginBtnKey')));
    await tester.pump(const Duration(seconds: 5));
    bloc.loggedIn.listen((bool success) async {
      await tester.pump();
      expect(success, equals(false));
    });
    await done.future;
  });
}
