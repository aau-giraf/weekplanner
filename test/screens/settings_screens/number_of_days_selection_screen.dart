import 'package:api_client/api/api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:api_client/models/username_model.dart';
import 'package:flutter/material.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/screens/settings_screens/number_of_days_selection_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section_checkboxButton.dart';

class MockUserApi extends Mock implements UserApi {
  @override
  Observable<GirafUserModel> me() {
    return Observable<GirafUserModel>.just(
        GirafUserModel(id: '1', username: 'test', role: Role.Guardian));
  }

  @override
  Observable<SettingsModel> getSettings(String id) {
    final SettingsModel settingsModel = SettingsModel(
        orientation: null,
        completeMark: null,
        cancelMark: null,
        defaultTimer: null,
        theme: null,
        nrOfDaysToDisplay: null,
        weekDayColors: null);

    return Observable<SettingsModel>.just(settingsModel);
  }
}

void main() {
  Api api;

  final UsernameModel user = UsernameModel(
      name: 'Anders And', id: '101', role: Role.Citizen.toString());

  setUp(() {
    di.clearAll();
    api = Api('any');
    api.user = MockUserApi();

    di.registerDependency<AuthBloc>((_) => AuthBloc(api));
    di.registerDependency<ToolbarBloc>((_) => ToolbarBloc());
    di.registerDependency<SettingsBloc>((_) => SettingsBloc(api));
  });

  testWidgets('Has GirafAppBar', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: NumberOfDaysScreen(user)));
    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is GirafAppBar &&
            widget.title == user.name + ': indstillinger'),
        findsOneWidget);
    expect(find.byType(GirafAppBar), findsOneWidget);
  });

  testWidgets('Has 3 options, SettingsCheckMarkButton',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: NumberOfDaysScreen(user)));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsCheckMarkButton), findsNWidgets(3));
  });

  testWidgets('Has option, Vis kun i dag', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: NumberOfDaysScreen(user)));
    await tester.pumpAndSettle();
    expect(find.text('Vis kun i dag'), findsOneWidget);
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
}
