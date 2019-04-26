import 'package:api_client/api/api.dart';
import 'package:api_client/api/pictogram_api.dart';
import 'package:api_client/api/week_api.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/enums/weekday_enum.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/weekday_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/activity_bloc.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/pictogram_bloc.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/blocs/weekplan_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:api_client/models/enums/activity_state_enum.dart';
import 'package:api_client/models/username_model.dart';
import 'package:weekplanner/screens/show_activity_screen.dart';
import 'package:weekplanner/screens/weekplan_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_confirm_dialog.dart';
import '../test_image.dart';

class MockWeekApi extends Mock implements WeekApi {}

class MockPictogramApi extends Mock implements PictogramApi {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  WeekplanBloc bloc;
  Api api;
  MockWeekApi weekApi;
  MockPictogramApi pictogramApi;

  final PictogramModel pictogramModel = PictogramModel(
      id: 1,
      lastEdit: null,
      title: null,
      accessLevel: null,
      imageUrl: 'http://any.tld',
      imageHash: null);

  ActivityModel newActivity(int id) {
    return ActivityModel(
        id: id,
        pictogram: pictogramModel,
        isChoiceBoard: true,
        state: null,
        order: 1);
  }

  final WeekModel weekModel = WeekModel(name: 'test', days: <WeekdayModel>[
    WeekdayModel(
        day: Weekday.Monday, activities: <ActivityModel>[newActivity(1)]),
    WeekdayModel(
        day: Weekday.Tuesday, activities: <ActivityModel>[newActivity(2)]),
    WeekdayModel(
        day: Weekday.Wednesday, activities: <ActivityModel>[newActivity(3)]),
    WeekdayModel(
        day: Weekday.Thursday, activities: <ActivityModel>[newActivity(4)]),
    WeekdayModel(
        day: Weekday.Friday, activities: <ActivityModel>[newActivity(5)]),
    WeekdayModel(
        day: Weekday.Saturday, activities: <ActivityModel>[newActivity(6)]),
    WeekdayModel(
        day: Weekday.Sunday, activities: <ActivityModel>[newActivity(7)]),
  ]);

  ActivityModel getActivity(Weekday day) {
    return weekModel.days[day.index].activities.first;
  }

  final UsernameModel user =
      UsernameModel(name: 'test', id: 'test', role: 'test');

  setUp(() {
    api = Api('any');
    weekApi = MockWeekApi();
    pictogramApi = MockPictogramApi();
    api.pictogram = pictogramApi;
    api.week = weekApi;
    bloc = WeekplanBloc(api);

    when(pictogramApi.getImage(pictogramModel.id))
        .thenAnswer((_) => BehaviorSubject<Image>.seeded(sampleImage));

    when(api.week.update(any, any, any, any)).thenAnswer((_) {
      return Observable<WeekModel>.just(weekModel);
    });

    di.clearAll();
    di.registerDependency<PictogramBloc>((_) => PictogramBloc(api));
    di.registerDependency<AuthBloc>((_) => AuthBloc(api));
    di.registerDependency<PictogramImageBloc>((_) => PictogramImageBloc(api));
    di.registerDependency<ToolbarBloc>((_) => ToolbarBloc());
    di.registerDependency<WeekplanBloc>((_) => bloc);
    di.registerDependency<ActivityBloc>((_) => ActivityBloc(api));
  });

  testWidgets('The screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
  });

  testWidgets('The screen has a Giraf App Bar', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));

    expect(find.byWidgetPredicate((Widget widget) => widget is GirafAppBar),
        findsOneWidget);
  });

  testWidgets('Has all days of the week', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pump();

    const List<String> days = <String>[
      'Mandag',
      'Tirsdag',
      'Onsdag',
      'Torsdag',
      'Fredag',
      'Lørdag',
      'Søndag'
    ];

    for (String day in days) {
      expect(find.text(day), findsOneWidget);
    }
  });

  testWidgets('Pictograms are rendered', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('PictogramImage')), findsNWidgets(7));
  });

  testWidgets('Activity has checkmark when done', (WidgetTester tester) async {
    getActivity(Weekday.Monday).state = ActivityState.Completed;
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pump();

    expect(find.byKey(const Key('IconComplete')), findsOneWidget);
  });

  testWidgets('Activity has no checkmark when Normal',
      (WidgetTester tester) async {
    getActivity(Weekday.Monday).state = ActivityState.Normal;
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pump();

    expect(find.byKey(const Key('IconComplete')), findsNothing);
  });

  testWidgets('Every add activitybutton is build', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pump();

    expect(find.byKey(const Key('AddActivityButton')), findsNWidgets(7));
  });

  testWidgets('Every drag target is build', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pump();

    expect(find.byKey(const Key('DragTarget')), findsNWidgets(7));
  });

  testWidgets('Every drag target is build', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pump();

    expect(find.byKey(const Key('GreyDragVisibleKey')), findsNWidgets(7));
  });

  testWidgets('Every drag target placeholder is build',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pump();

    bloc.setActivityPlaceholderVisible(true);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('DragTargetPlaceholder')), findsNWidgets(7));

    bloc.setActivityPlaceholderVisible(false);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('DragTargetPlaceholder')), findsNWidgets(0));
  });

  testWidgets('Click on edit icon toggles edit mode',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pump();
    bool resultValue = false;

    bloc.editMode.listen((bool editMode) {
      resultValue = editMode;
    });

    expect(resultValue, false);

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pump();

    expect(resultValue, true);

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pump();

    expect(resultValue, false);
  });

  testWidgets('Tap on an activity in edit mode marks it',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pump();

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pump();

    await tester.tap(find.byKey(Key(Weekday.Wednesday.index.toString() +
        getActivity(Weekday.Wednesday).id.toString())));
    await tester.pump();

    expect(find.byKey(const Key('isSelectedKey')), findsOneWidget);
  });

  testWidgets('Leaving editmode deselects all activities',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pump();

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pump();

    await tester.tap(find.byKey(Key(Weekday.Wednesday.index.toString() +
        getActivity(Weekday.Wednesday).id.toString())));
    await tester.pump();

    expect(find.byKey(const Key('isSelectedKey')), findsOneWidget);

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pump();

    expect(find.byKey(const Key('isSelectedKey')), findsNothing);
  });

  testWidgets('Deletes activties when click on confirm in dialog',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pump();

    final Key selectedPictogram = Key(Weekday.Monday.index.toString() +
        getActivity(Weekday.Monday).id.toString());

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pump();

    await tester.tap(find.byKey(selectedPictogram));
    await tester.pump();

    await tester.tap(find.byKey(const Key('DeleteActivtiesButton')));
    await tester.pump();

    expect(find.byType(GirafConfirmDialog), findsOneWidget);
    await tester.tap(find.byKey(const Key('ConfirmDialogConfirmButton')));
    await tester.pump();

    expect(find.byKey(selectedPictogram), findsNothing);
  });

  testWidgets('Does not delete activties when click on cancel in dialog',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pump();

    final Key selectedPictogram = Key(Weekday.Tuesday.index.toString() +
        getActivity(Weekday.Tuesday).id.toString());

    await tester.tap(find.byTooltip('Rediger'));
    await tester.pump();

    await tester.tap(find.byKey(selectedPictogram));
    await tester.pump();

    await tester.tap(find.byKey(const Key('DeleteActivtiesButton')));
    await tester.pump();

    expect(find.byType(GirafConfirmDialog), findsOneWidget);
    await tester.tap(find.byKey(const Key('ConfirmDialogCancelButton')));
    await tester.pump();

    expect(find.byKey(selectedPictogram), findsOneWidget);
  });

  testWidgets(
      'Check if ShowActivityScreen is pushed when a pictogram is tapped',
      (WidgetTester tester) async {
    final MockNavigatorObserver mockObserver = MockNavigatorObserver();

    await tester.pumpWidget(MaterialApp(
      home: WeekplanScreen(weekModel, user),
      navigatorObservers: <NavigatorObserver>[mockObserver],
    ));
    await tester.pump();

    await tester.tap(find.byKey(Key(Weekday.Tuesday.index.toString() +
        getActivity(Weekday.Tuesday).id.toString())));
    await tester.pumpAndSettle();

    verify(mockObserver.didPush(any, any));

    expect(find.byType(ShowActivityScreen), findsOneWidget);
  });
}
