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
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/screens/settings_screens/color_theme_selection_screen.dart';
import 'package:weekplanner/style/standard_week_colors.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/settings_widgets/settings_section_colorThemeButton.dart';



class MockUserApi extends Mock implements UserApi {
  SettingsModel _settingsModel;

  @override
  Observable<GirafUserModel> me() {
    return Observable<GirafUserModel>.just(
        GirafUserModel(id: '1', username: 'test', role: Role.Guardian));
  }

  @override
  Observable<SettingsModel> updateSettings(String id, SettingsModel settings) {
    _settingsModel = settings;
    return Observable<SettingsModel>.just(settings);
  }

  @override
  Observable<SettingsModel> getSettings(String id) {
    return Observable<SettingsModel>.just(_settingsModel);
  }

  void createInitialSettings() {
    final List<WeekdayColorModel> weekDayColors = createWeekDayColors();

    _settingsModel = SettingsModel(
        orientation: null,
        completeMark: null,
        cancelMark: null,
        defaultTimer: null,
        theme: null,
        weekDayColors: weekDayColors,
    );
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
  SettingsBloc settingsBloc;

  final DisplayNameModel user = DisplayNameModel(
      displayName: 'Anders And', id: '101', role: Role.Guardian.toString());

  setUp(() {
    api = Api('any');
    final MockUserApi temp = MockUserApi();
    temp.createInitialSettings();
    api.user = temp;
    settingsBloc = SettingsBloc(api);


    di.clearAll();
    di.registerDependency<AuthBloc>((_) => AuthBloc(api));
    di.registerDependency<ToolbarBloc>((_) => ToolbarBloc());

    di.registerDependency<SettingsBloc>((_) => settingsBloc);

  });

  testWidgets('Renders  ColorThemeSelectorScreen', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ColorThemeSelectorScreen(
        user: user)
    ));
    expect(find.byType(ColorThemeSelectorScreen), findsOneWidget);
  });

  testWidgets('Has GirafAppBar', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ColorThemeSelectorScreen(
        user: user)
    ));
    expect(find.byType(GirafAppBar), findsOneWidget);
  });

  testWidgets('Has three SettingsColorThemeCheckMarkButton',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: ColorThemeSelectorScreen(
            user: user)
        ));
        await tester.pumpAndSettle();
        expect(find.byType(SettingsColorThemeCheckMarkButton),
            findsNWidgets(3));
      });

  testWidgets('The correct initial settings are loaded',
          (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ColorThemeSelectorScreen(
        user: user)
    ));

    settingsBloc.settings.listen((SettingsModel response) {
      expect(response, isNotNull);

      final List<WeekdayColorModel> expectedList =
        MockUserApi.createWeekDayColors();

      for(int i = 0; i < response.weekDayColors.length; i++) {
        expect(response.weekDayColors[i].hexColor == expectedList[i].hexColor,
            isTrue);
        expect(response.weekDayColors[i].day == expectedList[i].day, isTrue);
      }
    });
  });

  testWidgets('The standard color theme button works',
          (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ColorThemeSelectorScreen(
        user: user)
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Standard'));
    await tester.pumpAndSettle();

    settingsBloc.settings.listen((SettingsModel response) {
      expect(response, isNotNull);

      final List<WeekdayColorModel> expectedList =
          WeekplanColorTheme.standardColorSetting();

      for(int i = 0; i < response.weekDayColors.length; i++) {
        expect(response.weekDayColors[i].hexColor == expectedList[i].hexColor,
            isTrue);
        expect(response.weekDayColors[i].day == expectedList[i].day, isTrue);
      }
    });
  });

  testWidgets('The white blue color theme button works',
          (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ColorThemeSelectorScreen(
        user: user)
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Blå/Hvid'));
    await tester.pumpAndSettle();

    settingsBloc.settings.listen((SettingsModel response) {
      expect(response, isNotNull);

      final List<WeekdayColorModel> expectedList =
          WeekplanColorTheme.blueWhiteColorSetting();

      for(int i = 0; i < response.weekDayColors.length; i++) {
        expect(response.weekDayColors[i].hexColor == expectedList[i].hexColor,
            isTrue);
        expect(response.weekDayColors[i].day == expectedList[i].day, isTrue);
      }
    });
  });

  testWidgets('The grey white color theme button works',
          (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ColorThemeSelectorScreen(
        user: user)
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Grå/Hvid'));
    await tester.pumpAndSettle();

    settingsBloc.settings.listen((SettingsModel response) {
      expect(response, isNotNull);

      final List<WeekdayColorModel> expectedList =
          WeekplanColorTheme.greyWhiteColorSetting();

      for(int i = 0; i < response.weekDayColors.length; i++) {
        expect(response.weekDayColors[i].hexColor == expectedList[i].hexColor,
            isTrue);
        expect(response.weekDayColors[i].day == expectedList[i].day, isTrue);
      }
    });
  });

}
