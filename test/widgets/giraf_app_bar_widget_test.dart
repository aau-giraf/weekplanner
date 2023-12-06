import 'dart:async';

import 'package:api_client/api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart' as rx_dart;
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';
import 'package:weekplanner/models/enums/weekplan_mode.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/giraf_confirm_dialog.dart';

/// Mocked authbloc by the use of Mockito
class MockAuth extends Mock implements AuthBloc {
  @override
  Stream<bool> get loggedIn => _loggedIn.stream;
  final rx_dart.BehaviorSubject<bool> _loggedIn =
      rx_dart.BehaviorSubject<bool>.seeded(true);

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
  Future<void> authenticateFromPopUp(String username, String password) async {
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
        AppBarIcon.logout: () {},
        AppBarIcon.changeToGuardian: () {},
      },
      key: UniqueKey(),
    ));
  }
}

class MockScreenForErrorDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ToolbarBloc bloc = di.get<ToolbarBloc>();
    return Scaffold(
        body: GirafButton(
      key: const Key('IconChangeToGuardian'),
      onPressed: () {
        bloc.createPopupDialog(context).show();
      },
    ));
  }
}

void main() {
  late ToolbarBloc bloc;
  late MockAuth authBloc;
  late final Api api = Api('any');

  setUp(() {
    di.clearAll();
    di.registerDependency<Api>(() => api);
    authBloc = MockAuth();
    di.registerDependency<AuthBloc>(() => authBloc);
    bloc = ToolbarBloc();
    di.registerDependency<ToolbarBloc>(() => bloc);
  });

  // Used to wrap a widget into a materialapp,
  // otherwise the widget is not testable

  Widget makeTestableWidget({Widget? child}) {
    return MaterialApp(
      home: child,
    );
  }

  // Used to simulate the widget being built inside the app itself,
  // which is done using tester.pumpWidget. Optionmanlly, the function can
  // simulate a frame change, which is done using tester.pump.
  // This is done through the doUpdate parameter, which is true by default.
  Future<void> simulateTestWidget(
      {WidgetTester? tester, Widget? widget, bool doUpdate = true}) async {
    await tester?.pumpWidget(makeTestableWidget(child: widget));
    if (doUpdate) {
      await tester?.pump();
    }
  }

  // Used to override the authbloc and toolbarbloc, which allows the tests
  // to have a 'clean' authbloc and toolbarbloc for each, individual test.
  void setupAlternativeDependencies() {
    di.registerDependency<AuthBloc>(() => MockAuthBloc(api), override: true);
    di.registerDependency<ToolbarBloc>(() => ToolbarBloc(), override: true);
  }

  testWidgets('Elements on dialog should be visible',
      (WidgetTester tester) async {
    // we have to use a diffent authbloc, where everything is not overridden
    setupAlternativeDependencies();

    // This part creates a MockScreenForErrorDialog, which is then validated
    // using tester.pumpAndSettle. This lets the widget be built and evaluated
    // as if it had been built in the app itself.
    await tester.pumpWidget(MaterialApp(home: MockScreenForErrorDialog()));
    await tester.pumpAndSettle();

    // This part taps the button with the key 'IconChangeToGuardian',
    // which is the button used for chanmging to guardian mode.
    // This is then validated using tester.pumpAndSettle,
    // which lets the test simulate a button press.
    await tester.tap(find.byKey(const Key('IconChangeToGuardian')));
    await tester.pumpAndSettle();

    // These expect statements validate that there exists both a textfield
    // for changing the password and a button for submitting the password.
    // If either of these are not found, the test fails.
    expect(find.byKey(const Key('SwitchToGuardianPassword')), findsOneWidget);
    expect(find.byKey(const Key('SwitchToGuardianSubmit')), findsOneWidget);
  });

  // Test that had no documentation.
  testWidgets('Wrong credentials should show error dialog',
      (WidgetTester tester) async {
    // We have to use a diffent authbloc, where everything is not overridden.

    setupAlternativeDependencies();

    // This part creates a MockScreenForErrorDialog, which is then validated
    // using tester.pumpAndSettle. This lets the widget be built and evaluated
    // as if it had been built in the app itself.
    await tester.pumpWidget(MaterialApp(home: MockScreenForErrorDialog()));
    await tester.pumpAndSettle();

    // This part taps the button with the key 'IconChangeToGuardian',
    // which is the button used for chanmging to guardian mode.
    // This is then validated using tester.pumpAndSettle,
    // which lets the test simulate a button press.
    await tester.tap(find.byKey(const Key('IconChangeToGuardian')));
    await tester.pumpAndSettle();

    // This part enters the text 'abc' into the textfield for changing the
    // password. Afterwards, the button for submitting the password is tapped.
    // This is then validated using tester.pumpAndSettle.
    await tester.enterText(
        find.byKey(const Key('SwitchToGuardianPassword')), 'abc');
    await tester.tap(find.byKey(const Key('SwitchToGuardianSubmit')));
    await tester.pumpAndSettle();

    // This part validates that the dialog for wrong password is shown, and thus
    // the entered password 'abc' is incorrect. If the dialog is not displayed,
    // the test fails. Otherwise, the test passes.

    expect(find.byKey(const Key('WrongPasswordDialog')), findsOneWidget);
  });

  testWidgets('Right credentials should not show error dialog',
      (WidgetTester tester) async {
    setupAlternativeDependencies();

    // This part works the same way as the test above, but instead of just
    // initializing the widget, it is wrapped in a MaterialApp object,
    // which is done through the makeTestableWidget function.

    await tester
        .pumpWidget(makeTestableWidget(child: MockScreenForErrorDialog()));
    await tester.pumpAndSettle();

    // This part taps the button with the key 'IconChangeToGuardian',
    // which is the button used for chanmging to guardian mode.
    // This is then validated using tester.pumpAndSettle,
    // which lets the test simulate a button press.
    await tester.tap(find.byKey(const Key('IconChangeToGuardian')));
    await tester.pumpAndSettle();

    // This part enters the text 'abc' into the textfield for changing the
    // password. Afterwards, the button for submitting the password is tapped.
    // This is then validated using tester.pumpAndSettle.
    await tester.enterText(
        find.byKey(const Key('SwitchToGuardianPassword')), 'password');
    await tester.tap(find.byKey(const Key('SwitchToGuardianSubmit')));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // This part validates that the dialog for wrong password is not shown, and
    // thus the entered password 'password' is correct. If the dialog is not
    // displayed, the test fails. Otherwise, the test passes.
    expect(find.byKey(const Key('WrongPasswordDialog')), findsNothing);
  });

  //////////////////////////////////////////////////////////////////////////////

  // All of the tests until the next comment like above are tests that validate
  // if the various text elements are displayed correctly.

  // To simplify the code, the function 'simulateWidget' is used for
  // building a testable widget, and then simulating a frame change.

  // For reference, all of the tests were not documented.

  testWidgets('Has toolbar with title', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
      title: 'Ugeplan',
      key: UniqueKey(),
    );

    // Simulate the widget being built inside the app itself.
    await simulateTestWidget(
        tester: tester, widget: girafAppBar, doUpdate: false);

    // This part validates that the text 'Ugeplan' is displayed in the appbar.
    expect(find.text('Ugeplan'), findsOneWidget);
  });

  // As the rest of the tests in this section are very similar, and function
  // the same way, only the first test is commented.

  testWidgets('Display default icon when given no icons to display',
      (WidgetTester tester) async {
    // Create the GirafAppBar object, which is the widget being tested.

    final GirafAppBar girafAppBar = GirafAppBar(
      title: 'Ugeplan',
      appBarIcons: null,
      key: UniqueKey(),
    );

    // Simulate the widget being built inside the app itself,
    // but also simulate a frame change.
    await simulateTestWidget(tester: tester, widget: girafAppBar);

    expect(find.byTooltip('Log ud'), findsOneWidget);
  });

  testWidgets('Accept button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
      title: 'Ugeplan',
      appBarIcons: <AppBarIcon, VoidCallback>{AppBarIcon.accept: () {}},
      key: UniqueKey(),
    );

    await simulateTestWidget(tester: tester, widget: girafAppBar);

    expect(find.byTooltip('Accepter').first, findsOneWidget);
  });

  testWidgets('Add button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
      title: 'Ugeplan',
      appBarIcons: <AppBarIcon, VoidCallback>{AppBarIcon.add: () {}},
      key: UniqueKey(),
    );

    await simulateTestWidget(tester: tester, widget: girafAppBar);

    expect(find.byTooltip('Tilføj').first, findsOneWidget);
  });

  testWidgets('Add timer button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
      title: 'Ugeplan',
      appBarIcons: <AppBarIcon, VoidCallback>{AppBarIcon.addTimer: () {}},
      key: UniqueKey(),
    );

    await simulateTestWidget(tester: tester, widget: girafAppBar);

    expect(find.byTooltip('Tilføj timer').first, findsOneWidget);
  });

  testWidgets('Back button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
      title: 'Ugeplan',
      appBarIcons: <AppBarIcon, VoidCallback>{AppBarIcon.back: () {}},
      key: UniqueKey(),
    );

    await simulateTestWidget(tester: tester, widget: girafAppBar);

    expect(find.byTooltip('Tilbage').first, findsOneWidget);
  });

  testWidgets('Burger menu button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
      title: 'Ugeplan',
      appBarIcons: <AppBarIcon, VoidCallback>{AppBarIcon.burgerMenu: () {}},
      key: UniqueKey(),
    );

    await simulateTestWidget(tester: tester, widget: girafAppBar);

    expect(find.byTooltip('Åbn menu').first, findsOneWidget);
  });

  testWidgets('Cancel button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
      title: 'Ugeplan',
      appBarIcons: <AppBarIcon, VoidCallback>{AppBarIcon.cancel: () {}},
      key: UniqueKey(),
    );

    await simulateTestWidget(tester: tester, widget: girafAppBar);

    expect(find.byTooltip('Fortryd').first, findsOneWidget);
  });

  testWidgets('Change to citizen button is displayed',
      (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
      title: 'Ugeplan',
      appBarIcons: <AppBarIcon, VoidCallback>{
        AppBarIcon.changeToCitizen: () {}
      },
      key: UniqueKey(),
    );

    await simulateTestWidget(tester: tester, widget: girafAppBar);

    expect(find.byTooltip('Skift til borger tilstand').first, findsOneWidget);
  });

  testWidgets('Change to guardian button is displayed',
      (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
      title: 'Ugeplan',
      appBarIcons: <AppBarIcon, VoidCallback>{
        AppBarIcon.changeToGuardian: () {}
      },
      key: UniqueKey(),
    );

    await simulateTestWidget(tester: tester, widget: girafAppBar);

    expect(find.byTooltip('Skift til værge tilstand').first, findsOneWidget);
  });

  testWidgets('Copy button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
      title: 'Ugeplan',
      appBarIcons: <AppBarIcon, VoidCallback>{AppBarIcon.copy: () {}},
      key: UniqueKey(),
    );

    await simulateTestWidget(tester: tester, widget: girafAppBar);

    expect(find.byTooltip('Kopier').first, findsOneWidget);
  });

  testWidgets('Delete button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
      title: 'Ugeplan',
      appBarIcons: <AppBarIcon, VoidCallback>{AppBarIcon.delete: () {}},
      key: UniqueKey(),
    );

    await simulateTestWidget(tester: tester, widget: girafAppBar);

    expect(find.byTooltip('Slet').first, findsOneWidget);
  });

  testWidgets('Edit button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
      title: 'Ugeplan',
      appBarIcons: <AppBarIcon, VoidCallback>{AppBarIcon.edit: () {}},
      key: UniqueKey(),
    );

    await simulateTestWidget(tester: tester, widget: girafAppBar);

    expect(find.byTooltip('Rediger').first, findsOneWidget);
  });

  testWidgets('Help button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
      title: 'Ugeplan',
      appBarIcons: <AppBarIcon, VoidCallback>{AppBarIcon.help: () {}},
      key: UniqueKey(),
    );

    await simulateTestWidget(tester: tester, widget: girafAppBar);

    expect(find.byTooltip('Hjælp').first, findsOneWidget);
  });

  testWidgets('Home button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
      title: 'Ugeplan',
      appBarIcons: <AppBarIcon, VoidCallback>{AppBarIcon.home: () {}},
      key: UniqueKey(),
    );

    await simulateTestWidget(tester: tester, widget: girafAppBar);

    expect(find.byTooltip('Gå til startside').first, findsOneWidget);
  });

  testWidgets('Log out button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
      title: 'Ugeplan',
      appBarIcons: <AppBarIcon, VoidCallback>{AppBarIcon.logout: () {}},
      key: UniqueKey(),
    );

    await simulateTestWidget(tester: tester, widget: girafAppBar);

    expect(find.byTooltip('Log ud').first, findsOneWidget);
  });

  testWidgets('Profile button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
      title: 'Ugeplan',
      appBarIcons: <AppBarIcon, VoidCallback>{AppBarIcon.profile: () {}},
      key: UniqueKey(),
    );

    await simulateTestWidget(tester: tester, widget: girafAppBar);

    expect(find.byTooltip('Vis profil').first, findsOneWidget);
  });

  testWidgets('Redo button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan',
        appBarIcons: <AppBarIcon, VoidCallback>{AppBarIcon.redo: () {}},
        key: UniqueKey());

    await simulateTestWidget(tester: tester, widget: girafAppBar);

    expect(find.byTooltip('Gendan').first, findsOneWidget);
  });

  testWidgets('Save button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan',
        appBarIcons: <AppBarIcon, VoidCallback>{AppBarIcon.save: () {}},
        key: UniqueKey());

    await simulateTestWidget(tester: tester, widget: girafAppBar);

    expect(find.byTooltip('Gem').first, findsOneWidget);
  });

  testWidgets('Search button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan',
        appBarIcons: <AppBarIcon, VoidCallback>{AppBarIcon.search: () {}},
        key: UniqueKey());

    await simulateTestWidget(tester: tester, widget: girafAppBar);

    expect(find.byTooltip('Søg').first, findsOneWidget);
  });

  testWidgets('Settings button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
        title: 'Ugeplan',
        appBarIcons: <AppBarIcon, VoidCallback>{AppBarIcon.settings: () {}},
        key: UniqueKey());

    await simulateTestWidget(tester: tester, widget: girafAppBar);

    expect(find.byTooltip('Indstillinger').first, findsOneWidget);
  });

  testWidgets('Undo button is displayed', (WidgetTester tester) async {
    final GirafAppBar girafAppBar = GirafAppBar(
      title: 'Ugeplan',
      appBarIcons: <AppBarIcon, VoidCallback>{AppBarIcon.undo: () {}},
      key: const ValueKey<String>('undoBtnKey'),
    );

    await simulateTestWidget(tester: tester, widget: girafAppBar);

    expect(find.byTooltip('Fortryd').first, findsOneWidget);
  });
  //////////////////////////////////////////////////////////////////////////////

  // Not at all commented
  testWidgets('GirafConfirmDialog is shown on logout icon press',
      (WidgetTester tester) async {
    await simulateTestWidget(tester: tester, widget: MockScreen());

    // Validate that one and only one,
    // button tagged with the tooltip 'Log ud' exists.
    expect(find.byTooltip('Log ud'), findsOneWidget);

    // Look for the button tagged with the tooltip 'Log ud' and tap it.
    // Afterwards, simulate a frame change using tester.pump.
    await tester.tap(find.byTooltip('Log ud'));
    await tester.pump();

    // Validate that the confirmation dialog is shown when logging out.
    expect(find.byType(GirafConfirmDialog), findsOneWidget);
  });

  // Not at all commented.
  testWidgets('User is logged out on confirmation in GirafConfirmDialog',
      (WidgetTester tester) async {
    final Completer<bool> done = Completer<bool>();

    await simulateTestWidget(tester: tester, widget: MockScreen());

    // Validate that one and only one,
    // button tagged with the tooltip 'Log ud' exists.
    expect(find.byTooltip('Log ud'), findsOneWidget);

    // Look for the button tagged with the tooltip 'Log ud' and tap it.
    // Afterwards, simulate a complete rebuild using tester.pumpAndSettle.
    // tester.pumpAndSettle calls tester.pump until there are no more frames.
    await tester.tap(find.byTooltip('Log ud'));
    await tester.pumpAndSettle();

    // Validate that the confirmation dialog is shown when logging out.
    // This is done by validating that exactly one GirafConfirmDialog exists,
    // and that exactly one button tagged with the key
    // 'ConfirmDialogConfirmButton' exists.
    expect(find.byType(GirafConfirmDialog), findsOneWidget);
    expect(find.byKey(const Key('ConfirmDialogConfirmButton')), findsOneWidget);

    // Tap the confirmation button and await the stream to update.
    await tester.tap(find.byKey(const Key('ConfirmDialogConfirmButton')));

    // Listens for an update to the loggedIn stream.
    authBloc.loggedIn.listen((bool statusLogout) async {
      // If there is a discrepancy between the stream and
      // the expected value 'false', the test fails.
      expect(statusLogout, isFalse);
      done.complete(true);
    });

    // Wait for the stream above to update.
    await done.future;
  });
}
