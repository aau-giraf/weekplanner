import 'package:api_client/api/api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/enums/weekday_enum.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/weekday_color_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
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

  @override
  Observable<SettingsModel> getSettings(String id) {
    final SettingsModel settingsModel = SettingsModel(
        orientation: null,
        completeMark: null,
        cancelMark: null,
        defaultTimer: null,
        theme: null,
        weekDayColors: createWeekDayColors()
    );

    return Observable<SettingsModel>.just(settingsModel);
  }


  static List<WeekdayColorModel>createWeekDayColors() {
    final List<WeekdayColorModel> weekDayColors = <WeekdayColorModel>[];
    weekDayColors.add(WeekdayColorModel(
        hexColor: '#FF0000',
        day: Weekday.Monday
    ));
    weekDayColors.add(WeekdayColorModel(
        hexColor: '#FF0000',
        day: Weekday.Tuesday
    ));
    weekDayColors.add(WeekdayColorModel(
        hexColor: '#FF0000',
        day: Weekday.Wednesday
    ));
    weekDayColors.add(WeekdayColorModel(
        hexColor: '#FF0000',
        day: Weekday.Thursday
    ));
    weekDayColors.add(WeekdayColorModel(
        hexColor: '#FF0000',
        day: Weekday.Friday
    ));
    weekDayColors.add(WeekdayColorModel(
        hexColor: '#FF0000',
        day: Weekday.Saturday
    ));
    weekDayColors.add(WeekdayColorModel(
        hexColor: '#FF0000',
        day: Weekday.Sunday
    ));

    return weekDayColors;
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
    di.registerDependency<SettingsBloc>((_) => SettingsBloc(api));

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
    await tester.pumpAndSettle();
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
    await tester.pumpAndSettle();
    await tester.tap(find.text('Farver på ugeplan'));
    await tester.pumpAndSettle();
    expect(find.byType(ColorThemeSelectorScreen), findsOneWidget);
  });
}