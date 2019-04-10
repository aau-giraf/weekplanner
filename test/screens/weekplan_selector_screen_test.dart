import 'package:api_client/api/api.dart';
import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/week_name_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/blocs/weekplans_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/screens/weekplan_selector_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

import '../blocs/weekplans_bloc_test.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  WeekplansBloc bloc;
  Api api;
  MockWeekApi weekApi;
  final UsernameModel mockUser =
  UsernameModel(name: 'test', role: 'test', id: 'test');

  void setupApiCalls() {
    final List<WeekNameModel> weekNameModelList = <WeekNameModel>[];
    final WeekNameModel weekNameModel =
    WeekNameModel(name: 'name', weekNumber: 1, weekYear: 1);
    final WeekNameModel weekNameModel2 =
    WeekNameModel(name: 'name2', weekNumber: 2, weekYear: 2);

    weekNameModelList.add(weekNameModel);
    weekNameModelList.add(weekNameModel2);

    final WeekModel weekModel = WeekModel(name: 'weekModel');

    when(weekApi.getNames('test')).thenAnswer(
            (_) => BehaviorSubject<List<WeekNameModel>>.seeded(weekNameModelList));

    when(weekApi.get('test', weekNameModel.weekYear, weekNameModel.weekNumber))
        .thenAnswer((_) => BehaviorSubject<WeekModel>.seeded(weekModel));

    when(weekApi.get(
        'test', weekNameModel2.weekYear, weekNameModel2.weekNumber))
        .thenAnswer((_) => BehaviorSubject<WeekModel>.seeded(weekModel));
  }

  setUp(() {
    api = Api('any');
    weekApi = MockWeekApi();
    api.week = weekApi;
    bloc = WeekplansBloc(api);

    setupApiCalls();

    di.clearAll();
    di.registerDependency<WeekplansBloc>((_) => bloc);
    di.registerDependency<AuthBloc>((_) => AuthBloc(api));
    di.registerDependency<PictogramImageBloc>((_) => PictogramImageBloc(api));
    di.registerDependency<ToolbarBloc>((_) => ToolbarBloc());
  });

  testWidgets('renders', (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));
  });

  testWidgets('Has Giraf App Bar', (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));

    expect(find.byWidgetPredicate((Widget widget) => widget is GirafAppBar),
        findsOneWidget);
  });

  testWidgets('GridView is rendered', (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));

    expect(find.byWidgetPredicate((Widget widget) => widget is GridView),
        findsNWidgets(1));
  });

  testWidgets('Weekmodels exist with the expected names',
          (WidgetTester tester) async {
        await tester
            .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));
        await tester.pump(Duration.zero);

        expect(find.text('Tilføj ugeplan'), findsNWidgets(1));
        expect(find.text('weekModel'), findsNWidgets(2));
      });
}
