import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:mockito/mockito.dart';
import 'package:weekplanner/widgets/giraf_confirm_dialog.dart';

class MockAuth extends Mock implements AuthBloc {
  @override
  Observable<bool> get loggedIn => _loggedIn.stream;
  final BehaviorSubject<bool> _loggedIn = BehaviorSubject<bool>.seeded(true);

  @override
  String loggedInUsername = 'Graatand';

  @override
  void authenticate(String username, String password) {
    // Mock the API and allow these 2 users to ?login?
    final bool status = (username == 'test' && password == 'test') ||
        (username == 'Graatand' && password == 'password');
    // If there is a successful login, remove the loading spinner,
    // and push the status to the stream
    if (status) {
      loggedInUsername = username;
    }
    _loggedIn.add(status);
  }

  @override
  void logout() {
    _loggedIn.add(false);
  }
}

class MockScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GirafAppBar(
            title: 'TestTitle',
            appBarIcons: const <AppBarIcon>[AppBarIcon.logout]));
  }
}

/// Used to retrieve the visibility widget wrapping the editbutton
const String keyOfVisibilityForEdit = 'visibilityEditBtn';

void main() {
  ToolbarBloc bloc;
  MockAuth authBloc;

  setUp(() {
    di.clearAll();
    authBloc = MockAuth();
    di.registerDependency<AuthBloc>((_) => authBloc);
    bloc = ToolbarBloc();
    di.registerDependency<ToolbarBloc>((_) => bloc);
  });

  // Used to wrap a widget into a materialapp, otherwise the widget is not
  // testable
  Widget makeTestableWidget({Widget child}) {
    return MaterialApp(
      home: child,
    );
  }

  testWidgets('Has toolbar with title', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(title: 'Ugeplan');

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));

    expect(find.text('Ugeplan'), findsOneWidget);
  });

  testWidgets('Display default icons when given no icons to display',
      (WidgetTester tester) async {
    final GirafAppBar girafAppBar =
        GirafAppBar(title: 'Ugeplan', appBarIcons: null);

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();
    expect(find.byTooltip('Log ud'), findsOneWidget);
    expect(find.byTooltip('Indstillinger'), findsOneWidget);
  });

  testWidgets('Accept button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon>[AppBarIcon.accept]);

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Accepter'), findsOneWidget);
  });

  testWidgets('Add button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon>[AppBarIcon.add]);

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Tilføj'), findsOneWidget);
  });

  testWidgets('Add timer button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon>[AppBarIcon.addTimer]);

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Tilføj timer'), findsOneWidget);
  });

  testWidgets('Back button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon>[AppBarIcon.back]);

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Tilbage'), findsOneWidget);
  });

  testWidgets('Burger menu button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan',
        appBarIcons: const <AppBarIcon>[AppBarIcon.burgerMenu]);

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Åbn menu'), findsOneWidget);
  });

  testWidgets('Camera button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon>[AppBarIcon.camera]);

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Åbn kamera'), findsOneWidget);
  });

  testWidgets('Cancel button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon>[AppBarIcon.cancel]);

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Fortryd'), findsOneWidget);
  });

  testWidgets('Change to citizen button is displayed',
      (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan',
        appBarIcons: const <AppBarIcon>[AppBarIcon.changeToCitizen]);

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Skift til borger tilstand'), findsOneWidget);
  });

  testWidgets('Change to guardian button is displayed',
      (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan',
        appBarIcons: const <AppBarIcon>[AppBarIcon.changeToGuardian]);

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Skift til værge tilstand'), findsOneWidget);
  });

  testWidgets('Copy button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon>[AppBarIcon.copy]);

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Kopier'), findsOneWidget);
  });

  testWidgets('Delete button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon>[AppBarIcon.delete]);

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Slet'), findsOneWidget);
  });

  testWidgets('Edit button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon>[AppBarIcon.edit]);

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Rediger'), findsOneWidget);
  });

  testWidgets('Help button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon>[AppBarIcon.help]);

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Hjælp'), findsOneWidget);
  });

  testWidgets('Home button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon>[AppBarIcon.home]);

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Gå til startside'), findsOneWidget);
  });

  testWidgets('Log out button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon>[AppBarIcon.logout]);

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Log ud'), findsOneWidget);
  });

  testWidgets('Profile button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon>[AppBarIcon.profile]);

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Vis profil'), findsOneWidget);
  });

  testWidgets('Redo button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon>[AppBarIcon.redo]);

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Gendan'), findsOneWidget);
  });

  testWidgets('Save button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon>[AppBarIcon.save]);

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Gem'), findsOneWidget);
  });

  testWidgets('Search button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon>[AppBarIcon.search]);

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Søg'), findsOneWidget);
  });

  testWidgets('Settings button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon>[AppBarIcon.settings]);

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Indstillinger'), findsOneWidget);
  });

  testWidgets('Undo button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon>[AppBarIcon.cancel]);

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Fortryd'), findsOneWidget);
  });

  testWidgets('GirafConfirmDialog is shown on logout icon press',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: MockScreen()));
        await tester.pump();
        expect(find.byTooltip('Log ud'), findsOneWidget);
        await tester.tap(find.byTooltip('Log ud'));
        await tester.pump();
        expect(find.byType(GirafConfirmDialog), findsOneWidget);
      });

  testWidgets('User is logged out on confirmation in GirafConfirmDialog',
          (WidgetTester tester) async {
        final Completer<bool> done = Completer<bool>();
        await tester.pumpWidget(MaterialApp(home: MockScreen()));
        await tester.pump();
        expect(find.byTooltip('Log ud'), findsOneWidget);
        await tester.tap(find.byTooltip('Log ud'));
        await tester.pump();
        expect(find.byType(GirafConfirmDialog), findsOneWidget);
        expect(find.byKey(const Key('ConfirmDialogConfirmButton')),
            findsOneWidget);
        await tester.tap(find.byKey(const Key('ConfirmDialogConfirmButton')));
        await tester.pumpAndSettle();
        authBloc.loggedIn.listen((bool statusLogout) async {
          if (statusLogout == false) {
            expect(statusLogout, isFalse);
            done.complete();
          }
        });
        await done.future;
      });
}
