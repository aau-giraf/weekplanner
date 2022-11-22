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
import 'package:weekplanner/screens/settings_screens/number_of_days_selection_screen.dart';
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
        nrOfDaysToDisplay: 1,
        weekDayColors: null);

    return Stream<SettingsModel>.value(settingsModel);
  }
}

void main() {
  Api api;
  NavigatorObserver mockObserver;

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

  testWidgets('Has GirafAppBar', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: NumberOfDaysScreen(user)));
    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is GirafAppBar &&
            widget.title == user.displayName + ': indstillinger'),
        findsOneWidget);
    expect(find.byType(GirafAppBar), findsOneWidget);
  });

  testWidgets('Has 3 options, SettingsCheckMarkButton',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: NumberOfDaysScreen(user)));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsCheckMarkButton), findsNWidgets(4));
  });

  testWidgets('Has option, Vis kun i dag', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: NumberOfDaysScreen(user)));
    await tester.pumpAndSettle();
    expect(find.text('Vis kun i dag'), findsOneWidget);
  });

  testWidgets('Has option, Vis to dage', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: NumberOfDaysScreen(user)));
    await tester.pumpAndSettle();
    expect(find.text('Vis to dage'), findsOneWidget);
  });

  testWidgets('Has option, Vis mandag til fredag', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: NumberOfDaysScreen(user)));
    await tester.pumpAndSettle();
    expect(find.text('Vis mandag til fredag'), findsOneWidget);
  });

  testWidgets('Has option, Vis mandag til søndag', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: NumberOfDaysScreen(user)));
    await tester.pumpAndSettle();
    expect(find.text('Vis mandag til søndag'), findsOneWidget);
  });

  testWidgets('Has only one selected option', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: NumberOfDaysScreen(user)));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('Has number of days screen been popped',
          (WidgetTester tester) async{
        await tester.pumpWidget(MaterialApp(
            home: NumberOfDaysScreen(user),
            // ignore: always_specify_types
            navigatorObservers: [mockObserver]
        ));
        verify(mockObserver.didPush(any, any));

        await tester.pumpAndSettle();
        expect(find.byType(SettingsCheckMarkButton), findsNWidgets(4));

        await tester.pump();
        await tester.tap(find.byType(SettingsCheckMarkButton).last);
        await tester.pump();
        verify(mockObserver.didPop(any, any));
      });
}
