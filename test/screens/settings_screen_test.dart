import 'package:api_client/api/api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:api_client/models/username_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/screens/settings_screens/settings_screen.dart';
import 'package:weekplanner/screens/settings_screens/color_theme_selection_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section_checkboxButton.dart';

class MockUserApi extends Mock implements UserApi {
  @override
  Observable<GirafUserModel> me() {
    return Observable<GirafUserModel>.just(
        GirafUserModel(id: '1', username: 'test', role: Role.Guardian));
  }
}

void main() {
  Api api;

  final UsernameModel user = UsernameModel(
      name: 'Anders And', id: '101', role: Role.Guardian.toString());

  setUp(() {
    di.clearAll();
    api = Api('any');
    api.user = MockUserApi();

    di.registerDependency<AuthBloc>((_) => AuthBloc(api));
    di.registerDependency<ToolbarBloc>((_) => ToolbarBloc());
  });

  testWidgets('Has GirafAppBar', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SettingsScreen(user)));
    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is GirafAppBar && widget.title == 'Indstillinger'),
        findsOneWidget);
    expect(find.byType(GirafAppBar), findsOneWidget);
  });

  testWidgets('Settings has Tema section', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SettingsScreen(user)));
    expect(find.text('Tema'), findsOneWidget);
    expect(find.text('Farver på ugeplan'), findsOneWidget);
    expect(find.text('Tegn for udførelse'), findsOneWidget);
  });

  testWidgets('Settings has Orientering section', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SettingsScreen(user)));
    expect(find.text('Orientering'), findsOneWidget);
    expect(find.text('Landskab'), findsOneWidget);
    expect(find.byType(SettingsCheckMarkButton), findsOneWidget);
  });

  testWidgets('Settings has Ugeplan section', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SettingsScreen(user)));
    expect(find.text('Ugeplan'), findsOneWidget);
    expect(find.text('Antal dage'), findsOneWidget);
  });

  testWidgets('Settings has Brugerindstillinger section',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SettingsScreen(user)));
    expect(find.text('Bruger indstillinger'), findsOneWidget);
    expect(find.text(user.name + ' indstillinger'), findsOneWidget);
  });

  testWidgets('Farver på ugeplan button changes screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SettingsScreen(user)));
    await tester.tap(find.text('Farver på ugeplan'));
    await tester.pumpAndSettle();
    expect(find.byType(ColorThemeSelectorScreen), findsOneWidget);
  });
}
