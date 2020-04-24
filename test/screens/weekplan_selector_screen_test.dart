import 'dart:async';

import 'package:api_client/api/api.dart';
import 'package:api_client/api/pictogram_api.dart';
import 'package:api_client/api/week_api.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/weekday_enum.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/week_name_model.dart';
import 'package:api_client/models/weekday_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/edit_weekplan_bloc.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/blocs/weekplan_selector_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';
import 'package:weekplanner/screens/weekplan_selector_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import '../test_image.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockPictogramApi extends Mock implements PictogramApi {}

class MockWeekApi extends Mock implements WeekApi {}

void main() {
  WeekplansBloc bloc;
  EditWeekplanBloc editBloc;
  Api api;
  MockWeekApi weekApi;
  MockPictogramApi pictogramApi;

  const String nameWeekModel1 = 'weekmodel1';
  const String nameWeekModel2 = 'weekmodel2';

  final DisplayNameModel mockUser =
      DisplayNameModel(displayName: 'testName', role: 'testRole', id: 'testId');

  final PictogramModel pictogramModel = PictogramModel(
      id: 1,
      lastEdit: null,
      title: null,
      accessLevel: null,
      imageUrl: 'http://any.tld',
      imageHash: null);

  final WeekModel weekModel1 = WeekModel(
      name: nameWeekModel1,
      thumbnail: pictogramModel,
      days: <WeekdayModel>[
        WeekdayModel(day: Weekday.Monday, activities: <ActivityModel>[]),
      ],
      weekNumber: 1,
      weekYear: 2020);

  final WeekModel weekModel2 = WeekModel(
      name: nameWeekModel2,
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

    when(weekApi.getNames('testId')).thenAnswer(
        (_) => BehaviorSubject<List<WeekNameModel>>.seeded(weekNameModelList));

    when(weekApi.get('testId',
        weekNameModel.weekYear, weekNameModel.weekNumber))
        .thenAnswer((_) => BehaviorSubject<WeekModel>.seeded(weekModel1));

    when(weekApi.get(
            'testId', weekNameModel2.weekYear, weekNameModel2.weekNumber))
        .thenAnswer((_) => BehaviorSubject<WeekModel>.seeded(weekModel2));

    when(weekApi.delete(mockUser.id, any, any))
        .thenAnswer((_) => BehaviorSubject<bool>.seeded(true));

    when(pictogramApi.getImage(any))
        .thenAnswer((_) => BehaviorSubject<Image>.seeded(sampleImage));
  }

  //region setUp()
  setUp(() {
    api = Api('any');
    weekApi = MockWeekApi();
    api.week = weekApi;
    pictogramApi = MockPictogramApi();
    api.pictogram = pictogramApi;
    bloc = WeekplansBloc(api);

    setupApiCalls();

    di.clearAll();
    di.registerSingleton<WeekplansBloc>((_) => bloc);
    di.registerDependency<EditWeekplanBloc>((_) => editBloc);
    di.registerDependency<AuthBloc>((_) => AuthBloc(api));
    di.registerDependency<PictogramImageBloc>((_) => PictogramImageBloc(api));
    di.registerDependency<ToolbarBloc>((_) => ToolbarBloc());
    editBloc = EditWeekplanBloc(api);
  });
  //endregion

  testWidgets('Should render WeekplanSelectorScreen widget',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));
  });

  testWidgets('Should have a Giraf App Bar Widget',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));

    expect(find.byWidgetPredicate((Widget widget) => widget is GirafAppBar &&
        widget.title == mockUser.displayName &&
        widget.appBarIcons.keys.contains(AppBarIcon.edit) &&
        widget.appBarIcons.keys.contains(AppBarIcon.logout) &&
        widget.appBarIcons.keys.contains(AppBarIcon.settings)),
        findsOneWidget);
  });

  testWidgets('Should have a GridView Widget', (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));

    expect(find.byWidgetPredicate((Widget widget) => widget is GridView),
        findsOneWidget);
  });

  testWidgets('Weekmodels exist with the expected names',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));
    await tester.pump(Duration.zero);

    expect(find.text('Tilføj ugeplan'), findsOneWidget);
    expect(find.text(nameWeekModel1), findsOneWidget);
    expect(find.text(nameWeekModel2), findsOneWidget);
  });

  testWidgets('Weekmodels have week/year', (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));
    await tester.pump(Duration.zero);

    expect(find.text('Uge: 1      År: 2020'), findsNWidgets(2));
    expect(find.byKey(const Key('weekYear')), findsNWidgets(2));
  });

  testWidgets('Should not have Redigér and Slet buttons outside edit mode',
          (WidgetTester tester) async{
        await tester
            .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));
        await tester.pumpAndSettle();

        expect(find.text('Redigér'), findsNothing);
        expect(find.byKey(const Key('EditButtonKey')), findsNothing);

        expect(find.text('Slet'), findsNothing);
        expect(find.byKey(const Key('DeleteActivtiesButton')), findsNothing);
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

  testWidgets('Should have Redigér and Slet buttons in edit mode',
          (WidgetTester tester) async{
    await tester
        .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    expect(find.text('Redigér'), findsOneWidget);
    expect(find.byKey(const Key('EditButtonKey')), findsOneWidget);

    expect(find.text('Slet'), findsOneWidget);
    expect(find.byKey(const Key('DeleteActivtiesButton')), findsOneWidget);
  });

  testWidgets('Clicking on a weekmodel marks it', (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));
    await tester.pumpAndSettle();

    expect(find.byKey(Key(weekModel1.name)), findsOneWidget);

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    // Before we mark the week plan weekModel1 we check that it
    // is in fact not marked
    expect(bloc.getMarkedWeekModels().contains(weekModel1), false);

    await tester.tap(find.byKey(Key(weekModel1.name)));
    await tester.pumpAndSettle();

    // After we have marked the week plan weekModel1 we check that it
    // is in fact marked
    expect(bloc.getMarkedWeekModels().contains(weekModel1), true);
  });

  testWidgets('Clicking on multiple weekmodels marks them',
          (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));
    await tester.pumpAndSettle();

    expect(find.byKey(Key(weekModel1.name)), findsOneWidget);
    expect(find.byKey(Key(weekModel2.name)), findsOneWidget);

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    // Before we mark the week plans we check that they are in fact not marked
    expect(bloc.getMarkedWeekModels().contains(weekModel1), false);
    expect(bloc.getMarkedWeekModels().contains(weekModel2), false);

    await tester.tap(find.byKey(Key(weekModel1.name)));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key(weekModel2.name)));
    await tester.pumpAndSettle();

    // After we have marked the week plans we check that they are in fact marked
    expect(bloc.getMarkedWeekModels().contains(weekModel1), true);
    expect(bloc.getMarkedWeekModels().contains(weekModel2), true);
  });

  testWidgets('Should not have a Fortryd and an extra Slet button in edit mode',
          (WidgetTester tester) async {
        await tester
            .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));
        await tester.pumpAndSettle();

        await tester.tap(find.byTooltip('Rediger'));
        await tester.pumpAndSettle();

        // Finds one 'Slet' buttons, because there is a 'Slet' button in edit
        // mode
        expect(find.text('Slet'), findsOneWidget);
        expect(find.byKey(const Key('ConfirmDialogConfirmButton')),
            findsNothing);

        expect(find.text('Fortryd'), findsNothing);
        expect(find.byKey(const Key('ConfirmDialogCancelButton')),
            findsNothing);
      });

  testWidgets('Should have a Fortryd and an extra slet button in delete dialog',
          (WidgetTester tester) async {
        await tester
            .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));
        await tester.pumpAndSettle();

        expect(find.text(nameWeekModel1), findsOneWidget);

        await tester.tap(find.byTooltip('Rediger'));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(Key(weekModel1.name)));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('DeleteActivtiesButton')));
        await tester.pumpAndSettle();

        // Finds two 'Slet' buttons, because there is a 'Slet' button from edit
        // mode
        expect(find.text('Slet'), findsNWidgets(2));
        expect(find.byKey(const Key('ConfirmDialogConfirmButton')),
            findsOneWidget);

        expect(find.text('Fortryd'), findsOneWidget);
        expect(find.byKey(const Key('ConfirmDialogCancelButton')),
            findsOneWidget);
      });

  testWidgets('Marking an weekmodel and deleting removes it',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));
    await tester.pumpAndSettle();

    expect(find.text(nameWeekModel1), findsOneWidget);

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key(weekModel1.name)));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('DeleteActivtiesButton')));
    await tester.pumpAndSettle();
    
    await tester.tap(find.byKey(const Key('ConfirmDialogConfirmButton')));
    await tester.pumpAndSettle();

    expect(find.text(nameWeekModel1), findsNothing);
  });

  testWidgets('Marking weekmodel and leave edit mode unmarks all weekmodels',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));
    await tester.pumpAndSettle();

    expect(find.byKey(Key(weekModel1.name)), findsOneWidget);
    expect(find.byKey(Key(weekModel2.name)), findsOneWidget);

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key(weekModel1.name)));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key(weekModel2.name)));
    await tester.pumpAndSettle();

    // Checks that the two marked week model are in fact marked
    expect(bloc.getMarkedWeekModels().contains(weekModel1), true);
    expect(bloc.getMarkedWeekModels().contains(weekModel2), true);

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    // Checks that after the "Rediger"-button has been pressed, the
    // week plans are not marked any more
    expect(bloc.getMarkedWeekModels().contains(weekModel1), false);
    expect(bloc.getMarkedWeekModels().contains(weekModel2), false);
  });

  testWidgets('Clicking a marked weekplan should unmark it',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));
    await tester.pumpAndSettle();

    expect(find.byKey(Key(weekModel1.name)), findsOneWidget);

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key(weekModel1.name)));
    await tester.pumpAndSettle();

    // Checks that the marked week model is in fact marked
    expect(bloc.getMarkedWeekModels().contains(weekModel1), true);

    await tester.tap(find.byKey(Key(weekModel1.name)));
    await tester.pumpAndSettle();

    // Checks that after marking/tapping the week plan again, the
    // week plan are not marked any more
    expect(bloc.getMarkedWeekModels().contains(weekModel1), false);
  });

  testWidgets('Test editing is valid', (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();
    bool editingIsValid;

    final StreamSubscription<bool> listenForValid1 =
    bloc.editingIsValidStream().listen((bool b) {
      editingIsValid = b;
    });

    await tester.tap(find.byKey(Key(weekModel1.name)));
    await tester.pumpAndSettle();

    expect(editingIsValid, true);

    await tester.tap(find.byKey(Key(weekModel2.name)));
    await tester.pumpAndSettle();

    expect(editingIsValid, false);

    listenForValid1.cancel();
  });
}
