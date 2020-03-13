import 'package:api_client/api/api.dart';
import 'package:api_client/api/pictogram_api.dart';
import 'package:api_client/api/week_api.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/enums/weekday_enum.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/week_name_model.dart';
import 'package:api_client/models/weekday_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/blocs/weekplan_selector_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/screens/weekplan_selector_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import '../test_image.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockPictogramApi extends Mock implements PictogramApi {}

class MockWeekApi extends Mock implements WeekApi {}

void main() {
  WeekplansBloc bloc;
  Api api;
  MockWeekApi weekApi;
  MockPictogramApi pictogramApi;
  final UsernameModel mockUser =
      UsernameModel(name: 'test', role: 'test', id: 'test');

  final PictogramModel pictogramModel = PictogramModel(
      id: 1,
      lastEdit: null,
      title: null,
      accessLevel: null,
      imageUrl: 'http://any.tld',
      imageHash: null);

  final WeekModel weekModel1 = WeekModel(
      name: 'weekModel1',
      thumbnail: pictogramModel,
      days: <WeekdayModel>[
        WeekdayModel(day: Weekday.Monday, activities: <ActivityModel>[]),
      ],
      weekNumber: 1,
      weekYear: 2020);

  final WeekModel weekModel2 = WeekModel(
      name: 'weekModel2',
      thumbnail: pictogramModel,
      days: <WeekdayModel>[
        WeekdayModel(day: Weekday.Monday, activities: <ActivityModel>[]),
      ],
      weekNumber: 1,
      weekYear: 2020);

  void setupApiCalls() {
    final List<WeekNameModel> weekNameModelList = <WeekNameModel>[];
    final WeekNameModel weekNameModel =
        WeekNameModel(name: 'name', weekNumber: 1, weekYear: 1);
    final WeekNameModel weekNameModel2 =
        WeekNameModel(name: 'name2', weekNumber: 2, weekYear: 2);

    weekNameModelList.add(weekNameModel);
    weekNameModelList.add(weekNameModel2);

    when(weekApi.getNames('test')).thenAnswer(
        (_) => BehaviorSubject<List<WeekNameModel>>.seeded(weekNameModelList));

    when(weekApi.get('test', weekNameModel.weekYear, weekNameModel.weekNumber))
        .thenAnswer((_) => BehaviorSubject<WeekModel>.seeded(weekModel1));

    when(weekApi.get(
            'test', weekNameModel2.weekYear, weekNameModel2.weekNumber))
        .thenAnswer((_) => BehaviorSubject<WeekModel>.seeded(weekModel2));

    when(weekApi.delete(mockUser.id, any, any))
        .thenAnswer((_) => BehaviorSubject<bool>.seeded(true));

    when(pictogramApi.getImage(any))
        .thenAnswer((_) => BehaviorSubject<Image>.seeded(sampleImage));
  }

  setUp(() {
    api = Api('any');
    weekApi = MockWeekApi();
    api.week = weekApi;
    pictogramApi = MockPictogramApi();
    api.pictogram = pictogramApi;
    bloc = WeekplansBloc(api);

    setupApiCalls();

    di.clearAll();
    di.registerDependency<WeekplansBloc>((_) => bloc);
    di.registerDependency<AuthBloc>((_) => AuthBloc(api));
    di.registerDependency<PictogramImageBloc>((_) => PictogramImageBloc(api));
    di.registerDependency<ToolbarBloc>((_) => ToolbarBloc());
  });

  testWidgets('Renders the screen', (WidgetTester tester) async {
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
    expect(find.text('weekModel1'), findsOneWidget);
    expect(find.text('weekModel2'), findsOneWidget);
  });

  testWidgets('Weekmodels have week/year', (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));
    await tester.pump(Duration.zero);

    expect(find.text('Uge: 1      År: 2020'), findsNWidgets(2));
    expect(find.byKey(const Key('weekYear')), findsNWidgets(2));
  });

  testWidgets('Click on edit icon toggles edit mode',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));
    await tester.pumpAndSettle();
    bool resultValue = false;

    bloc.editMode.listen((bool editMode) {
      resultValue = editMode;
    });

    expect(resultValue, false);

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    expect(resultValue, true);

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    expect(resultValue, false);
  });

  testWidgets('Clicking on an activity marks it', (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));
    await tester.pumpAndSettle();

    expect(find.text('weekModel1'), findsOneWidget);

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key(weekModel1.name)));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('isSelectedKey')), findsOneWidget);
  });

  testWidgets('Marking a activity and deleting removes it',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));
    await tester.pumpAndSettle();

    expect(find.text('weekModel1'), findsOneWidget);

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key(weekModel1.name)));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('DeleteActivtiesButton')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('ConfirmDialogConfirmButton')));
    await tester.pumpAndSettle();

    expect(find.text('weekModel1'), findsNothing);
  });

  testWidgets('Marking activities and leave edit mode unmarks all activities',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));
    await tester.pumpAndSettle();

    expect(find.text('weekModel1'), findsOneWidget);

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key(weekModel1.name)));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('isSelectedKey')), findsOneWidget);

    await tester.tap(find.byKey(Key(weekModel2.name)));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('isSelectedKey')), findsNWidgets(2));

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('isSelectedKey')), findsNothing);
  });
}
