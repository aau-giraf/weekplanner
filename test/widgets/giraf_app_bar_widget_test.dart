import 'dart:async';
import 'package:api_client/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';
import 'package:weekplanner/models/enums/weekplan_mode.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:mockito/mockito.dart';
import 'package:weekplanner/widgets/giraf_confirm_dialog.dart';

/// Mocked authbloc by the use of Mockito
class MockAuth extends Mock implements AuthBloc {
  @override
  Observable<bool> get loggedIn => _loggedIn.stream;
  final BehaviorSubject<bool> _loggedIn = BehaviorSubject<bool>.seeded(true);

  @override
  String loggedInUsername = 'Graatand';


  @override
  void logout() {
    _loggedIn.add(false);
  }
}

/// Mockec authbloc without the use of Mockito
class MockAuthBloc extends AuthBloc {
  MockAuthBloc(Api api) : super(api);

  @override
  void authenticateFromPopUp(String username, String password) {
    if (password == 'password') {
      setAttempt(true);
      setMode(WeekplanMode.guardian);
    }
  }
}

class MockScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GirafAppBar(
            title: 'TestTitle',
            appBarIcons: <AppBarIcon, VoidCallback>{
              AppBarIcon.logout: null,
              AppBarIcon.changeToGuardian: () {},
            }));
  }
}


void main() {
  ToolbarBloc bloc;
  MockAuth authBloc;
  final Api api = Api('any');

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

  testWidgets('Wrong credentials should show error dialog',
          (WidgetTester tester) async {

    // we have to use a diffent authbloc, where everything is not overridden.
    di.registerDependency<AuthBloc>((_) => MockAuthBloc(api), override: true);
    di.registerDependency<ToolbarBloc>((_) => ToolbarBloc(), override: true);
    await tester.pumpWidget(makeTestableWidget(child: MockScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('IconChangeToGuardian')));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.byKey(const Key('SwitchToGuardianPassword')), 'abc');
    await tester.tap(find.byKey(const Key('SwitchToGuardianSubmit')));

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('WrongPasswordDialog')),
        findsOneWidget);

  });

  testWidgets('Right credentials should not show error dialog',
          (WidgetTester tester) async {

    di.registerDependency<AuthBloc>((_) => MockAuthBloc(api), override: true);
    di.registerDependency<ToolbarBloc>((_) => ToolbarBloc(), override: true);
    await tester.pumpWidget(makeTestableWidget(child: MockScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('IconChangeToGuardian')));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.byKey(const Key('SwitchToGuardianPassword')), 'password');
    await tester.tap(find.byKey(const Key('SwitchToGuardianSubmit')));

    await tester.pumpAndSettle(const Duration(seconds:2));

    expect(find.byKey(const Key('WrongPasswordDialog')),
        findsNothing);

  });

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
        title: 'Ugeplan', appBarIcons: const <AppBarIcon, VoidCallback>{
      AppBarIcon.accept: null});

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Accepter'), findsOneWidget);
  });

  testWidgets('Add button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon, VoidCallback>{
      AppBarIcon.add: null});

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Tilføj'), findsOneWidget);
  });

  testWidgets('Add timer button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon, VoidCallback>{
      AppBarIcon.addTimer: null});

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Tilføj timer'), findsOneWidget);
  });

  testWidgets('Back button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon, VoidCallback>{
      AppBarIcon.back: null});

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Tilbage'), findsOneWidget);
  });

  testWidgets('Burger menu button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan',
        appBarIcons: const <AppBarIcon, VoidCallback>{
          AppBarIcon.burgerMenu: null});

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Åbn menu'), findsOneWidget);
  });

  testWidgets('Camera button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon, VoidCallback>{
      AppBarIcon.camera: null});

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Åbn kamera'), findsOneWidget);
  });

  testWidgets('Cancel button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon, VoidCallback>{
      AppBarIcon.cancel: null});

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Fortryd'), findsOneWidget);
  });

  testWidgets('Change to citizen button is displayed',
      (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan',
        appBarIcons: const <AppBarIcon, VoidCallback>{
          AppBarIcon.changeToCitizen: null});

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Skift til borger tilstand'), findsOneWidget);
  });

  testWidgets('Change to guardian button is displayed',
      (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan',
        appBarIcons: const <AppBarIcon, VoidCallback>{
          AppBarIcon.changeToGuardian: null});

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Skift til værge tilstand'), findsOneWidget);
  });

  testWidgets('Copy button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon, VoidCallback>{
      AppBarIcon.copy: null});

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Kopier'), findsOneWidget);
  });

  testWidgets('Delete button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon, VoidCallback>{
      AppBarIcon.delete: null});

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Slet'), findsOneWidget);
  });

  testWidgets('Edit button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon, VoidCallback>{
      AppBarIcon.edit: null});

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Rediger'), findsOneWidget);
  });

  testWidgets('Help button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon, VoidCallback>{
      AppBarIcon.help: null});

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Hjælp'), findsOneWidget);
  });

  testWidgets('Home button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon, VoidCallback>{
      AppBarIcon.home: null});

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Gå til startside'), findsOneWidget);
  });

  testWidgets('Log out button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon, VoidCallback>{
      AppBarIcon.logout: null});

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Log ud'), findsOneWidget);
  });

  testWidgets('Profile button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon, VoidCallback>{
      AppBarIcon.profile: null});

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Vis profil'), findsOneWidget);
  });

  testWidgets('Redo button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon, VoidCallback>{
      AppBarIcon.redo: null});

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Gendan'), findsOneWidget);
  });

  testWidgets('Save button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon, VoidCallback>{
      AppBarIcon.save: null});

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Gem'), findsOneWidget);
  });

  testWidgets('Search button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon, VoidCallback>{
      AppBarIcon.search: null});

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Søg'), findsOneWidget);
  });

  testWidgets('Settings button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon, VoidCallback>{
      AppBarIcon.settings: null});

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));
    await tester.pump();

    expect(find.byTooltip('Indstillinger'), findsOneWidget);
  });

  testWidgets('Undo button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan', appBarIcons: const <AppBarIcon, VoidCallback>{
      AppBarIcon.undo: null});

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
    await tester.pumpAndSettle();
    expect(find.byType(GirafConfirmDialog), findsOneWidget);
    expect(find.byKey(const Key('ConfirmDialogConfirmButton')), findsOneWidget);
    await tester.tap(find.byKey(const Key('ConfirmDialogConfirmButton')));
    authBloc.loggedIn.listen((bool statusLogout) async {
      if (statusLogout == false) {
        expect(statusLogout, isFalse);
        done.complete();
      }
    });
    await done.future;
  });
}
