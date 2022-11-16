import 'package:api_client/api/api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/enums/weekday_enum.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:api_client/models/weekday_color_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/screens/settings_screens/settings_screen.dart';
import 'package:weekplanner/screens/settings_screens/color_theme_selection_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section_checkboxButton.dart';

SettingsModel mockSettings;

class MockUserApi extends Mock implements UserApi {
  @override
  Stream<GirafUserModel> me() {
    return Stream<GirafUserModel>.value(
        GirafUserModel(id: '1', username: 'test', role: Role.Guardian));
  }

  @override
  Stream<SettingsModel> getSettings(String id) {
    return Stream<SettingsModel>.value(mockSettings);
  }

  @override
  Stream<bool> updateSettings(String id, SettingsModel settings) {
    mockSettings = settings;
    return Stream<bool>.value(true);
  }

  static List<WeekdayColorModel> createWeekDayColors() {
    final List<WeekdayColorModel> weekDayColors = <WeekdayColorModel>[];
    weekDayColors
        .add(WeekdayColorModel(hexColor: '#FF0000', day: Weekday.Monday));
    weekDayColors
        .add(WeekdayColorModel(hexColor: '#FF0000', day: Weekday.Tuesday));
    weekDayColors
        .add(WeekdayColorModel(hexColor: '#FF0000', day: Weekday.Wednesday));
    weekDayColors
        .add(WeekdayColorModel(hexColor: '#FF0000', day: Weekday.Thursday));
    weekDayColors
        .add(WeekdayColorModel(hexColor: '#FF0000', day: Weekday.Friday));
    weekDayColors
        .add(WeekdayColorModel(hexColor: '#FF0000', day: Weekday.Saturday));
    weekDayColors
        .add(WeekdayColorModel(hexColor: '#FF0000', day: Weekday.Sunday));

    return weekDayColors;
  }
}

void main() {
  Api api;
  SettingsBloc settingsBloc;

  final DisplayNameModel user = DisplayNameModel(
      displayName: 'Anders And', id: '101', role: Role.Guardian.toString());

  setUp(() {
    di.clearAll();
    api = Api('any');
    api.user = MockUserApi();

    mockSettings = SettingsModel(
      orientation: null,
      completeMark: null,
      cancelMark: null,
      defaultTimer: null,
      theme: null,
      nrOfDaysToDisplay: 1,
      weekDayColors: MockUserApi.createWeekDayColors(),
      lockTimerControl: false,
      pictogramText: false,
      showPopup: false,
    );

    di.registerDependency<AuthBloc>((_) => AuthBloc(api));
    di.registerDependency<ToolbarBloc>((_) => ToolbarBloc());
    settingsBloc = SettingsBloc(api);
    settingsBloc.loadSettings(user);
    di.registerDependency<SettingsBloc>((_) => settingsBloc);
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
  });

  testWidgets('Settings has Ugeplan section', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SettingsScreen(user)));
    await tester.pumpAndSettle();
    expect(find.text('Ugeplan'), findsOneWidget);
    expect(find.text('Antal dage'), findsOneWidget);
    expect(find.text('En dag'), findsOneWidget);
    expect(find.text('Piktogram tekst er synlig'), findsOneWidget);
  });

  testWidgets('Settings has Brugerindstillinger section',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SettingsScreen(user)));
    expect(find.text('Bruger indstillinger'), findsOneWidget);
    expect(find.text(user.displayName + ' indstillinger'), findsOneWidget);
  });

  testWidgets('Farver på ugeplan button changes screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SettingsScreen(user)));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Farver på ugeplan'));
    await tester.pumpAndSettle();
    expect(find.byType(ColorThemeSelectorScreen), findsOneWidget);
  });

  testWidgets('Piktogram tekst knap opdaterer indstillinger',
          (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SettingsScreen(user)));
    await tester.pumpAndSettle();

    expect(false, mockSettings.pictogramText);

    await tester.tap(find.text('Piktogram tekst er synlig'));
    await tester.pumpAndSettle();

    expect(true, mockSettings.pictogramText);
  });

  testWidgets('Vis popup knap opdaterer indstillinger',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: SettingsScreen(user)));
        await tester.pumpAndSettle();

        expect(false, mockSettings.showPopup);

        await tester.tap(find.text('Vis bekræftelse popups'));
        await tester.pumpAndSettle();

        expect(true, mockSettings.showPopup);
  });

  testWidgets('Settings has TimerControl checkbox without an checkmark',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SettingsScreen(user)));
    await tester.pump();
    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is SettingsCheckMarkButton &&
            widget.current == 2 &&
            widget.text == 'Lås tidsstyring'),
        findsOneWidget);
  });

  testWidgets('Tapping the TimerControl checkbox changes the current value',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SettingsScreen(user)));
    await tester.pump();

    await tester.tap(find.byWidgetPredicate((Widget widget) =>
        widget is SettingsCheckMarkButton &&
        widget.current == 2 &&
        widget.text == 'Lås tidsstyring'));
    await tester.pump();

    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is SettingsCheckMarkButton &&
            widget.current == 1 &&
            widget.text == 'Lås tidsstyring'),
        findsOneWidget);
  });

  testWidgets('Settings has Slet bruger button',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: SettingsScreen(user)));
        expect(find.text('Slet bruger'), findsOneWidget);
      });
}
