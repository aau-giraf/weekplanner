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
    final List<WeekdayColorModel> weekDayColors = createWeekDayColors();

    final SettingsModel settingsModel = SettingsModel(
        orientation: null,
        completeMark: null,
        cancelMark: null,
        defaultTimer: null,
        theme: null,
        weekDayColors: weekDayColors
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
  SettingsBloc settingsBloc;

  final UsernameModel user = UsernameModel(
      name: 'Anders And', id: '101', role: Role.Guardian.toString());

  setUp(() {
    api = Api('any');
    api.user = MockUserApi();
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

  testWidgets('The correct settings are loaded', (WidgetTester tester) async {
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

  // TODO(EsbenNedergaard): få lavet nogle tests.
  // Vi skal gøre så når man trykker på de forskellige temaer så skifter
  // værdierne i response.weekDayColors, så testene skal meget minde om
  // den ovenfor

  testWidgets('Has three SettingsCheckMarkButtons',
          (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ColorThemeSelectorScreen(
        user: user)
    ));
    expect(find.byType(SettingsCheckMarkButton), findsNWidgets(3));
  });
}