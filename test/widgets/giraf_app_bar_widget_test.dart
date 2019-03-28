import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiver/time.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/blocs/user_info_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/providers/api/api.dart';
import 'package:weekplanner/screens/weekplan_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:mockito/mockito.dart';

class MockAuth extends Mock implements AuthBloc {}

void main() {
  ToolbarBloc toolbarBloc;
  UserInfoBloc userInfoBloc;
  SettingsBloc settingsBloc;
  Api api;
  // The key for the visibility widget, used to retrieve the widget during testing.
  String keyOfVisibilityForEdit = 'visibilityEditBtn';

  setUp(() {
    api = Api('any');
    toolbarBloc = ToolbarBloc();
    userInfoBloc = UserInfoBloc();
    settingsBloc = SettingsBloc();

    di.clearAll();
    di.registerDependency<ToolbarBloc>((_) => toolbarBloc);
    di.registerDependency<UserInfoBloc>((_) => userInfoBloc);
    di.registerDependency<SettingsBloc>((_) => settingsBloc);
    di.registerDependency<AuthBloc>((_) => AuthBloc(api));
  });

  // Used to wrap a widget into a materialapp, otherwise the widget is not
  // testable
  Widget makeTestableWidget ({Widget child})  {
    return MaterialApp(
      home: child,
    );
  }

  testWidgets('Has toolbar with title', (WidgetTester tester) async {
    GirafAppBar girafAppBar = GirafAppBar(title: 'Ugeplan');

    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));

    expect(find.text('Ugeplan'), findsOneWidget);
  });

  testWidgets('Visibility widget should be in widget tree', (WidgetTester tester) async {
    // Instantiates the appbar.
    GirafAppBar girafAppBar = GirafAppBar(title: 'AppBar');

    // Uses the pumpwidget function to build the widget, so it becomes active.
    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));

    // Searches for a widget with a specific key, and we only expect to find one.
    expect(find.byKey(Key(keyOfVisibilityForEdit)), findsOneWidget);

  });

  testWidgets('Visibility widget should not be visible', (WidgetTester tester) async {
    GirafAppBar girafAppBar = GirafAppBar(title: 'AppBar');
    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));

    // Retrieves the visiblity widget.
    final Visibility visibility = tester.widget(find.byKey(Key(keyOfVisibilityForEdit)));

    // Should be false, since that is the initial value.
    expect(visibility.visible, false);

  });

  testWidgets('Visibility widget should be visible', (WidgetTester tester) async {
    GirafAppBar girafAppBar = GirafAppBar(title: 'AppBar');
    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));

    // Tries to change the value of visiblity.visible, by sending "true" though
    // the stream.
    toolbarBloc.setEditVisible(true);

    await tester.pumpAndSettle();
    Visibility visibility = tester.widget(find.byKey(Key(keyOfVisibilityForEdit)));

    expect(visibility.visible, true);
  });

  testWidgets('Visibility widget toggled', (WidgetTester tester) async {
    GirafAppBar girafAppBar = GirafAppBar(title: 'AppBar');
    await tester.pumpWidget(makeTestableWidget(child: girafAppBar));

    toolbarBloc.setEditVisible(true);
    await tester.pumpAndSettle();
    Visibility visibility = tester.widget(find.byKey(Key(keyOfVisibilityForEdit)));
    expect(visibility.visible, true);

    toolbarBloc.setEditVisible(false);
    await tester.pumpAndSettle();
    visibility = tester.widget(find.byKey(Key(keyOfVisibilityForEdit)));
    expect(visibility.visible, false);
  });

  testWidgets('All days should initially be visible',
             (WidgetTester tester) async {
    WeekplanScreen weekplanScreen = WeekplanScreen(title:'WeekplanScreen');
    await tester.pumpWidget(makeTestableWidget(child: weekplanScreen));
    final Visibility visibilityMon =
        tester.widget(find.byKey(const Key('visibilityMon')));
    final Visibility visibilityTue =
        tester.widget(find.byKey(const Key('visibilityTue')));
    final Visibility visibilityWed =
        tester.widget(find.byKey(const Key('visibilityWed')));
    final Visibility visibilityThu =
        tester.widget(find.byKey(const Key('visibilityThu')));
    final Visibility visibilityFri =
        tester.widget(find.byKey(const Key('visibilityFri')));
    final Visibility visibilitySat =
        tester.widget(find.byKey(const Key('visibilitySat')));
    final Visibility visibilitySun =
        tester.widget(find.byKey(const Key('visibilitySun')));

    expect(visibilityMon.visible, true);
    expect(visibilityTue.visible, true);
    expect(visibilityWed.visible, true);
    expect(visibilityThu.visible, true);
    expect(visibilityFri.visible, true);
    expect(visibilitySat.visible, true);
    expect(visibilitySun.visible, true);

  });

  testWidgets('All days should be visible in Guardianmode',
             (WidgetTester tester) async {
    final WeekplanScreen weekplanScreen =
        WeekplanScreen(title:'WeekplanScreen');
    await tester.pumpWidget(makeTestableWidget(child: weekplanScreen));
    userInfoBloc.setUserMode('Guardian');
    await tester.pumpAndSettle();
    final Visibility visibilityMon =
    tester.widget(find.byKey(const Key('visibilityMon')));
    final Visibility visibilityTue =
    tester.widget(find.byKey(const Key('visibilityTue')));
    final Visibility visibilityWed =
    tester.widget(find.byKey(const Key('visibilityWed')));
    final Visibility visibilityThu =
    tester.widget(find.byKey(const Key('visibilityThu')));
    final Visibility visibilityFri =
    tester.widget(find.byKey(const Key('visibilityFri')));
    final Visibility visibilitySat =
    tester.widget(find.byKey(const Key('visibilitySat')));
    final Visibility visibilitySun =
    tester.widget(find.byKey(const Key('visibilitySun')));

    expect(visibilityMon.visible, true);
    expect(visibilityTue.visible, true);
    expect(visibilityWed.visible, true);
    expect(visibilityThu.visible, true);
    expect(visibilityFri.visible, true);
    expect(visibilitySat.visible, true);
    expect(visibilitySun.visible, true);

  });

  testWidgets('All days should be visible after toggle of usermode',
             (WidgetTester tester) async {
    final WeekplanScreen weekplanScreen =
        WeekplanScreen(title:'WeekplanScreen');
    await tester.pumpWidget(makeTestableWidget(child: weekplanScreen));
    userInfoBloc.setUserMode('Citizen');
    await tester.pumpAndSettle();
    userInfoBloc.setUserMode('Guardian');
    await tester.pumpAndSettle();
    final Visibility visibilityMon =
    tester.widget(find.byKey(const Key('visibilityMon')));
    final Visibility visibilityTue =
    tester.widget(find.byKey(const Key('visibilityTue')));
    final Visibility visibilityWed =
    tester.widget(find.byKey(const Key('visibilityWed')));
    final Visibility visibilityThu =
    tester.widget(find.byKey(const Key('visibilityThu')));
    final Visibility visibilityFri =
    tester.widget(find.byKey(const Key('visibilityFri')));
    final Visibility visibilitySat =
    tester.widget(find.byKey(const Key('visibilitySat')));
    final Visibility visibilitySun =
    tester.widget(find.byKey(const Key('visibilitySun')));

    expect(visibilityMon.visible, true);
    expect(visibilityTue.visible, true);
    expect(visibilityWed.visible, true);
    expect(visibilityThu.visible, true);
    expect(visibilityFri.visible, true);
    expect(visibilitySat.visible, true);
    expect(visibilitySun.visible, true);

  });

  testWidgets('Monday should be visible in citizenmode',
             (WidgetTester tester) async {
    final WeekplanScreen weekplanScreen =
        WeekplanScreen(title: 'WeekplanScreen');
    userInfoBloc.clock = Clock.fixed(DateTime(2019, 03,18));
    await tester.pumpWidget(makeTestableWidget(child: weekplanScreen));
    userInfoBloc.setUserMode('Citizen');
    await tester.pumpAndSettle();
    final Visibility visibility =
        tester.widget(find.byKey(const Key('visibilityMon')));
    expect(visibility.visible, true);
  });

  testWidgets('Tuesday should be visible in citizenmode',
             (WidgetTester tester) async {
    final WeekplanScreen weekplanScreen =
        WeekplanScreen(title: 'WeekplanScreen');
    userInfoBloc.clock = Clock.fixed(DateTime(2019, 03,19));
    await tester.pumpWidget(makeTestableWidget(child: weekplanScreen));
    userInfoBloc.setUserMode('Citizen');
    await tester.pumpAndSettle();
    final Visibility visibility =
        tester.widget(find.byKey(const Key('visibilityTue')));
    expect(visibility.visible, true);
  });

  testWidgets('Wednesday should be visible in citizenmode',
             (WidgetTester tester) async {
    final WeekplanScreen weekplanScreen =
        WeekplanScreen(title: 'WeekplanScreen');
    userInfoBloc.clock = Clock.fixed(DateTime(2019, 03,20));
    await tester.pumpWidget(makeTestableWidget(child: weekplanScreen));
    userInfoBloc.setUserMode('Citizen');
    await tester.pumpAndSettle();
    final Visibility visibility =
        tester.widget(find.byKey(const Key('visibilityWed')));
    expect(visibility.visible, true);
  });

  testWidgets('Thursday should be visible in citizenmode',
             (WidgetTester tester) async {
    final WeekplanScreen weekplanScreen =
        WeekplanScreen(title: 'WeekplanScreen');
    userInfoBloc.clock = Clock.fixed(DateTime(2019, 03,21));
    await tester.pumpWidget(makeTestableWidget(child: weekplanScreen));
    userInfoBloc.setUserMode('Citizen');
    await tester.pumpAndSettle();
    final Visibility visibility =
        tester.widget(find.byKey(const Key('visibilityThu')));
    expect(visibility.visible, true);
  });

  testWidgets('Friday should be visible in citizenmode',
             (WidgetTester tester) async {
    final WeekplanScreen weekplanScreen =
        WeekplanScreen(title: 'WeekplanScreen');
    userInfoBloc.clock = Clock.fixed(DateTime(2019, 03,22));
    await tester.pumpWidget(makeTestableWidget(child: weekplanScreen));
    userInfoBloc.setUserMode('Citizen');
    await tester.pumpAndSettle();
    final Visibility visibility =
        tester.widget(find.byKey(const Key('visibilityFri')));
    expect(visibility.visible, true);
  });

  testWidgets('Saturday should be visible in citizenmode',
             (WidgetTester tester) async {
    final WeekplanScreen weekplanScreen =
        WeekplanScreen(title: 'WeekplanScreen');
    userInfoBloc.clock = Clock.fixed(DateTime(2019, 03,23));
    await tester.pumpWidget(makeTestableWidget(child: weekplanScreen));
    userInfoBloc.setUserMode('Citizen');
    await tester.pumpAndSettle();
    final Visibility visibility =
        tester.widget(find.byKey(Key('visibilitySat')));
    expect(visibility.visible, true);
  });

  testWidgets('Sunday should be visible in citizenmode',
             (WidgetTester tester) async {
    final WeekplanScreen weekplanScreen =
        WeekplanScreen(title: 'WeekplanScreen');
    userInfoBloc.clock = Clock.fixed(DateTime(2019, 03,24));
    await tester.pumpWidget(makeTestableWidget(child: weekplanScreen));
    userInfoBloc.setUserMode('Citizen');
    await tester.pumpAndSettle();
    final Visibility visibility =
        tester.widget(find.byKey(Key('visibilitySun')));
    expect(visibility.visible, true);
  });
}