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
import 'package:weekplanner/widgets/giraf_notify_dialog.dart';

class MockAuth extends Mock implements AuthBloc {
  @override
  Observable<bool> get loggedIn => _loggedIn.stream;
  final BehaviorSubject<bool> _loggedIn = BehaviorSubject<bool>.seeded(true);

  @override
  String loggedInUsername = 'Graatand';

  @override
  void authenticateFromPopUp(String username, String password) {
    // Mock the API and allow these 2 users to ?login?
    final bool status = (username == 'test' && password == 'test') ||
        (username == 'Graatand' && password == 'password');
    // If there is a successful login, remove the loading spinner,
    // and push the status to the stream
    if (status) {
      loggedInUsername = username;
    }
    else {
      //showFailureDialog(context);
    }
    _loggedIn.add(status);
  }

  //Shows the failure dialog when wrong credentials when logging in from popup.
  void showFailureDialog(BuildContext context){
    showDialog<Center>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return const GirafNotifyDialog(
              title: 'Fejl',
              description: 'Forkert adgangskode',
              key: Key('WrongUsernameOrPasswordDialog'));
        });
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
            appBarIcons: <AppBarIcon, VoidCallback>{
              AppBarIcon.logout: null,
              AppBarIcon.changeToGuardian: () {},
            }));
  }
}

/// Used to retrieve the visibility widget wrapping the editbutton
const String keyOfVisibilityForEdit = 'visibilityEditBtn';
const String keyOfWrongUsernameOrPassword = 'WrongUsernameOrPasswordDialog';
const String keyOfChangeToGuardian = 'IconChangeToGuardian';
const String keyOfPasswordField = 'SwitchToGuardianPassword';
const String keyOfConfirmButton = 'SwitchToGuardianSubmit';

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

  testWidgets('Dialog should not be visible', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget(child: MockScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key(keyOfChangeToGuardian)));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key(keyOfPasswordField)),
        'password');
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key(keyOfConfirmButton)));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.byKey(const Key(keyOfWrongUsernameOrPassword)),
        findsNothing);
  });


  testWidgets('Dialog should be visible', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget(child: MockScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key(keyOfChangeToGuardian)));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key(keyOfPasswordField)),
        'wrongpassword');
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key(keyOfConfirmButton)));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.byKey(const Key(keyOfWrongUsernameOrPassword)),
        findsOneWidget);
  });
}
