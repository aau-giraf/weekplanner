import 'package:api_client/api/api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/default_timer_enum.dart';
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
import 'package:weekplanner/screens/settings_screens/time_representation_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section_checkboxButton.dart';

class MockUserApi extends Mock implements UserApi {
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
        defaultTimer: DefaultTimer.PieChart,
        theme: null,
        nrOfDaysToDisplay: null,
        weekDayColors: null);

    return Stream<SettingsModel>.value(settingsModel);
  }
}

void main() {
  Api api;

  final DisplayNameModel user = DisplayNameModel(
      displayName: 'Mickey Mouse', id: '2', role: Role.Citizen.toString());

  setUp(() {
    di.clearAll();
    api = Api('any');
    api.user = MockUserApi();

    di.registerDependency<AuthBloc>((_) => AuthBloc(api));
    di.registerDependency<ToolbarBloc>((_) => ToolbarBloc());
    di.registerDependency<SettingsBloc>((_) => SettingsBloc(api));
  });

  testWidgets('Has GirafToolBar', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: TimeRepresentationScreen(user)));
    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is GirafAppBar &&
            widget.title == user.displayName + ': indstillinger'),
        findsOneWidget);
    expect(find.byType(GirafAppBar), findsOneWidget);
  });

  testWidgets('Has 3 options', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: TimeRepresentationScreen(user)));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsCheckMarkButton), findsNWidgets(3));
  });

  testWidgets('Has option called Nedtælling', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: TimeRepresentationScreen(user)));
    await tester.pumpAndSettle();
    expect(find.text('Nedtælling'), findsOneWidget);
  });

    testWidgets('Has option called Timeglas', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: TimeRepresentationScreen(user)));
    await tester.pumpAndSettle();
    expect(find.text('Timeglas'), findsOneWidget);
  });

  testWidgets('Has option called Standard', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: TimeRepresentationScreen(user)));
    await tester.pumpAndSettle();
    expect(find.text('Standard'),findsOneWidget);
  });

  testWidgets('Has only one option selected', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: TimeRepresentationScreen(user)));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.check), findsOneWidget);
  });
}
