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
import 'package:weekplanner/blocs/activity_bloc.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/copy_resolve_bloc.dart';
import 'package:weekplanner/blocs/copy_weekplan_bloc.dart';
import 'package:weekplanner/blocs/edit_weekplan_bloc.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/blocs/weekplan_bloc.dart';
import 'package:weekplanner/blocs/weekplan_selector_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/screens/copy_resolve_screen.dart';
import 'package:weekplanner/models/enums/app_bar_icons_enum.dart';
import 'package:weekplanner/screens/weekplan_selector_screen.dart';
import 'package:weekplanner/widgets/giraf_3button_dialog.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_notify_dialog.dart';
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

  final WeekModel weekModel1Copy = WeekModel(
      name: nameWeekModel1,
      thumbnail: pictogramModel,
      days: <WeekdayModel>[
        WeekdayModel(day: Weekday.Monday, activities: <ActivityModel>[]),
      ],
      weekNumber: 3,
      weekYear: 2020);

  final WeekModel mockWeekModel = WeekModel(
      name: 'mockWeekModelName',
      thumbnail: pictogramModel,
      days: <WeekdayModel>[
        WeekdayModel(day: Weekday.Monday, activities: <ActivityModel>[]),
      ],
      weekNumber: 40,
      weekYear: 2022);

  final WeekModel emptyWeekmodel = WeekModel(days: <WeekdayModel>[]);

  final WeekNameModel weekNameModel =
      WeekNameModel(name: 'name', weekNumber: 1, weekYear: 1);
  final WeekNameModel weekNameModel2 =
      WeekNameModel(name: 'name2', weekNumber: 2, weekYear: 2);

  void setupApiCalls() {
    final List<WeekNameModel> weekNameModelList = <WeekNameModel>[];

    weekNameModelList.add(weekNameModel);
    weekNameModelList.add(weekNameModel2);

    when(weekApi.getNames('testId')).thenAnswer(
        (_) => BehaviorSubject<List<WeekNameModel>>.seeded(weekNameModelList));

    when(weekApi.get(
            'testId', weekNameModel.weekYear, weekNameModel.weekNumber))
        .thenAnswer((_) => BehaviorSubject<WeekModel>.seeded(weekModel1));

    when(weekApi.get(
            'testId', weekModel1Copy.weekYear, weekModel1Copy.weekNumber))
        .thenAnswer((_) => BehaviorSubject<WeekModel>.seeded(emptyWeekmodel));
    when(weekApi.get(
            'testId', weekNameModel2.weekYear, weekNameModel2.weekNumber))
        .thenAnswer((_) => BehaviorSubject<WeekModel>.seeded(weekModel2));

    when(weekApi.get('testId', weekModel1.weekYear, weekModel1.weekNumber))
        .thenAnswer((_) => BehaviorSubject<WeekModel>.seeded(weekModel1));

    when(weekApi.get(
            'testId', mockWeekModel.weekYear, mockWeekModel.weekNumber))
        .thenAnswer((_) => BehaviorSubject<WeekModel>.seeded(mockWeekModel));

    when(weekApi.update(
            'testId', weekModel1Copy.weekYear, weekModel1Copy.weekNumber, any))
        .thenAnswer((_) {
      return BehaviorSubject<WeekModel>.seeded(weekModel1Copy);
    });

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
    di.registerDependency<WeekplansBloc>((_) => bloc);
    di.registerDependency<EditWeekplanBloc>((_) => editBloc);
    di.registerDependency<AuthBloc>((_) => AuthBloc(api));
    di.registerDependency<PictogramImageBloc>((_) => PictogramImageBloc(api));
    di.registerDependency<ToolbarBloc>((_) => ToolbarBloc());
    di.registerDependency<CopyResolveBloc>((_) => CopyResolveBloc(api));
    di.registerDependency<CopyWeekplanBloc>((_) => CopyWeekplanBloc(api));
    editBloc = EditWeekplanBloc(api);
    di.registerDependency<WeekplanBloc>((_) => WeekplanBloc(api));
    di.registerDependency<SettingsBloc>((_) => SettingsBloc(api));
    di.registerDependency<ActivityBloc>((_) => ActivityBloc(api));
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

    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is GirafAppBar &&
            widget.title == mockUser.displayName &&
            widget.appBarIcons.keys.contains(AppBarIcon.edit) &&
            widget.appBarIcons.keys.contains(AppBarIcon.logout) &&
            widget.appBarIcons.keys.contains(AppBarIcon.settings)),
        findsOneWidget);
  });

  testWidgets('Should have a "Overståede uger" bar',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));

    expect(find.text('Overståede uger'), findsOneWidget);
  });

  testWidgets('Should have two GridView Widgets', (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));

    expect(
        find.byWidgetPredicate(
            (Widget widget) => widget is GridView || widget is ListView),
        findsNWidgets(2));
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
      (WidgetTester tester) async {
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
      (WidgetTester tester) async {
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
    expect(find.byKey(const Key('ConfirmDialogConfirmButton')), findsNothing);

    expect(find.text('Fortryd'), findsNothing);
    expect(find.byKey(const Key('ConfirmDialogCancelButton')), findsNothing);
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
    expect(find.byKey(const Key('ConfirmDialogConfirmButton')), findsOneWidget);

    expect(find.text('Fortryd'), findsOneWidget);
    expect(find.byKey(const Key('ConfirmDialogCancelButton')), findsOneWidget);
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

  testWidgets('Test edit failure dialog with zero selected',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Rediger'));

    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('EditButtonKey')));
    await tester.pumpAndSettle();

    expect(find.text('Fejl'), findsOneWidget);
    expect(find.text('Markér en uge for at redigere den'), findsOneWidget);
  });

  testWidgets('Test edit failure dialog with multiple selected',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key(weekModel1.name)));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key(weekModel2.name)));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('EditButtonKey')));
    await tester.pumpAndSettle();

    expect(find.text('Fejl'), findsOneWidget);
    expect(find.text('Der kan kun redigeres en uge ad gangen'), findsOneWidget);
  });

  testWidgets('Test edit no error dialog with one selected',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key(weekModel1.name)));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('EditButtonKey')));
    await tester.pumpAndSettle();

    expect(find.text('Fejl'), findsNothing);
  });

  testWidgets('Test delete failure when none selected',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('DeleteActivtiesButton')));
    await tester.pumpAndSettle();

    expect(find.text('Fejl'), findsOneWidget);
    expect(find.text('Der skal markeres mindst én uge for at slette'),
        findsOneWidget);
  });

  testWidgets('Test BottomAppBar buttons exist', (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    expect(find.text('Redigér'), findsOneWidget);
    expect(find.text('Kopiér'), findsOneWidget);
    expect(find.text('Slet'), findsOneWidget);
  });

  testWidgets('Test copy weekplan', (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key(weekModel1.name)));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('CopyWeekplanButton')));
    await tester.pumpAndSettle();

    expect(find.text('Fortryd'), findsOneWidget);
    expect(find.text('Anden borger'), findsOneWidget);
    expect(find.text('Denne borger'), findsOneWidget);
  });

  testWidgets(
      'Test that “Kopier” button shows a dialog '
      'when no weekplans have been marked', (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('CopyWeekplanButton')));
    await tester.pumpAndSettle();

    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is GirafNotifyDialog &&
            widget.title == 'Fejl' &&
            widget.description ==
                'Der skal markeres præcis én uge for at kopiere'),
        findsOneWidget);
  });

  testWidgets(
      'Test that “Kopier” button shows a dialog '
      'when more than one weekplan have been marked',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key(weekModel1.name)));
    await tester.tap(find.byKey(Key(weekModel2.name)));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('CopyWeekplanButton')));
    await tester.pumpAndSettle();

    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is GirafNotifyDialog &&
            widget.title == 'Fejl' &&
            widget.description ==
                'Der skal markeres præcis én uge for at kopiere'),
        findsOneWidget);
  });

  testWidgets(
      'Test if a dialog appears when pressing "kopier" and '
      'test if the dialog has the right buttons aswell',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key(weekModel1.name)));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('CopyWeekplanButton')));
    await tester.pumpAndSettle();

    expect(find.byType(Giraf3ButtonDialog), findsOneWidget);
  });

  testWidgets(
      'Test if when pressing “kopier her” a copy is made '
      'and the CopyResolverScreen comes up', (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key(weekModel1.name)));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('CopyWeekplanButton')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('Option2Button')));
    await tester.pumpAndSettle();

    expect(find.byType(CopyResolveScreen), findsOneWidget);
  });

  testWidgets(
      'Should have the newest weekplans going '
      'from weekplanScreen to weekplanSelectorScreen',
      (WidgetTester tester) async {
    final List<WeekNameModel> mockWeekNameModelList = <WeekNameModel>[];
    mockWeekNameModelList.add(weekNameModel);
    mockWeekNameModelList.add(weekNameModel2);

    when(weekApi.getNames('testId')).thenAnswer((_) =>
        BehaviorSubject<List<WeekNameModel>>.seeded(mockWeekNameModelList));

    await tester
        .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));
    await tester.pumpAndSettle();

    expect(find.byKey(Key(weekModel1.name)), findsOneWidget);
    expect(find.byKey(Key(mockWeekModel.name)), findsNothing);
    expect(find.byKey(Key(weekModel2.name)), findsOneWidget);

    await tester.tap(find.byKey(Key(weekModel1.name)));
    await tester.pumpAndSettle();

    mockWeekNameModelList.add(WeekNameModel(
        name: 'test',
        weekNumber: mockWeekModel.weekNumber,
        weekYear: mockWeekModel.weekYear));

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.byKey(Key(weekModel1.name)), findsOneWidget);
    expect(find.byKey(Key(mockWeekModel.name)), findsOneWidget);
    expect(find.byKey(Key(weekModel2.name)), findsOneWidget);
  });

  testWidgets('Search for weekplan', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: WeekplanSelectorScreen(mockUser),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Søg'));
    await tester.pumpAndSettle();

    // await tester.tap(find.byKey(Key('WeekplanSearchBar')));
    // await tester.pumpAndSettle();

    // await tester.showKeyboard(find.byKey(Key('WeekplanSearchBar')));
    // await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), nameWeekModel2);
    await tester.pumpAndSettle();

    expect(find.text(nameWeekModel2), findsOneWidget);
  });
}
