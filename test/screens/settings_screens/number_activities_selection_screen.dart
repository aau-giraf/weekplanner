import 'package:api_client/api/api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/screens/settings_screens/number_of_activities_selection_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section_checkboxButton.dart';

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
        nrOfActivitiesToDisplay: 2);

    return Stream<SettingsModel>.value(settingsModel);
  }
}

void main() {
  Api api;
  NavigatorObserver mockObserver;
  final SettingsModel settingsModel = SettingsModel(
      orientation: null,
      completeMark: null,
      cancelMark: null,
      defaultTimer: null,
      theme: null,
      nrOfActivitiesToDisplay: 2);
  final DisplayNameModel user = DisplayNameModel(
      displayName: 'Anders And', id: '101', role: Role.Citizen.toString());

  setUp(() {
    di.clearAll();
    api = Api('any');
    api.user = MockUserApi();
    mockObserver = MockUserApi();

    di.registerDependency<AuthBloc>(() => AuthBloc(api));
    di.registerDependency<ToolbarBloc>(() => ToolbarBloc());
    di.registerDependency<SettingsBloc>(() => SettingsBloc(api));
  });

  testWidgets('Screen has GirafAppBar', (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: NumberOfActivitiesScreen(user, null)));
    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is GirafAppBar &&
            widget.title == user.displayName + ': indstillinger'),
        findsOneWidget);
    expect(find.byType(GirafAppBar), findsOneWidget);
  });

  testWidgets(
      'settings screen has 10 options, '
      'SettingsCheckMarkButton', (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: NumberOfActivitiesScreen(user, settingsModel)));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsCheckMarkButton), findsNWidgets(10));
  });

  testWidgets('settings screen has option: "1 aktivitet"',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: NumberOfActivitiesScreen(user, settingsModel)));
    await tester.pumpAndSettle();
    expect(find.text('1 aktivitet'), findsOneWidget);
  });

  testWidgets('settings screen has option: "2 aktiviteter"',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: NumberOfActivitiesScreen(user, settingsModel)));
    await tester.pumpAndSettle();
    expect(find.text('2 aktiviteter'), findsOneWidget);
  });

  testWidgets('settings screen has option: "3 aktiviteter"',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: NumberOfActivitiesScreen(user, settingsModel)));
    await tester.pumpAndSettle();
    expect(find.text('3 aktiviteter'), findsOneWidget);
  });

  testWidgets('settings screen has option: "4 aktiviteter"',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: NumberOfActivitiesScreen(user, settingsModel)));
    await tester.pumpAndSettle();
    expect(find.text('4 aktiviteter'), findsOneWidget);
  });

  testWidgets('settings screen has option: "5 aktiviteter"',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: NumberOfActivitiesScreen(user, settingsModel)));
    await tester.pumpAndSettle();
    expect(find.text('5 aktiviteter'), findsOneWidget);
  });

  testWidgets('settings screen has option: "6 aktiviteter"',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: NumberOfActivitiesScreen(user, settingsModel)));
    await tester.pumpAndSettle();
    expect(find.text('6 aktiviteter'), findsOneWidget);
  });

  testWidgets('settings screen has option: "7 aktiviteter"',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: NumberOfActivitiesScreen(user, settingsModel)));
    await tester.pumpAndSettle();
    expect(find.text('7 aktiviteter'), findsOneWidget);
  });

  testWidgets('settings screen has option: "8 aktiviteter"',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: NumberOfActivitiesScreen(user, settingsModel)));
    await tester.pumpAndSettle();
    expect(find.text('8 aktiviteter'), findsOneWidget);
  });

  testWidgets('settings screen has option: "9 aktiviteter"',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: NumberOfActivitiesScreen(user, settingsModel)));
    await tester.pumpAndSettle();
    expect(find.text('9 aktiviteter'), findsOneWidget);
  });

  testWidgets('settings screen has option: "10 aktiviteter"',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: NumberOfActivitiesScreen(user, settingsModel)));
    await tester.pumpAndSettle();
    expect(find.text('10 aktiviteter'), findsOneWidget);
  });

  testWidgets('settings screen has been popped', (WidgetTester tester) async {
    // Tests couldn't find some buttons, so screen size is increased
    tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    await tester.pumpWidget(MaterialApp(
        home: NumberOfActivitiesScreen(user, settingsModel),
        navigatorObservers: [mockObserver] //ignore: always_specify_types
        ));
    verify(mockObserver.didPush(any, any));

    await tester.pumpAndSettle();
    expect(find.byType(SettingsCheckMarkButton), findsNWidgets(10));

    await tester.pump();
    await tester.tap(find.byType(SettingsCheckMarkButton).last);
    await tester.pump();
    verify(mockObserver.didPop(any, any));
  });
}
