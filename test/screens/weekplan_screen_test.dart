import 'package:api_client/api/api.dart';
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
import 'package:weekplanner/screens/weekplan_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import '../blocs/pictogram_bloc_test.dart';
import '../blocs/weekplan_bloc_test.dart';
import '../test_image.dart';

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

  final ActivityModel activity = ActivityModel(
      id: 1,
      pictogram: pictogramModel,
      isChoiceBoard: true,
      state: null,
      order: 1);

  final WeekModel weekModel = WeekModel(name: 'test', days: <WeekdayModel>[
    WeekdayModel(day: Weekday.Monday, activities: <ActivityModel>[activity]),
    WeekdayModel(day: Weekday.Tuesday, activities: <ActivityModel>[activity]),
    WeekdayModel(day: Weekday.Wednesday, activities: <ActivityModel>[activity]),
    WeekdayModel(day: Weekday.Thursday, activities: <ActivityModel>[activity]),
    WeekdayModel(day: Weekday.Friday, activities: <ActivityModel>[activity]),
    WeekdayModel(day: Weekday.Saturday, activities: <ActivityModel>[activity]),
    WeekdayModel(day: Weekday.Sunday, activities: <ActivityModel>[activity]),
  ]);

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
    await tester.pumpWidget(
        MaterialApp(home: WeekplanScreen(weekModel, user)));

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

  testWidgets('pictograms are rendered', (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pump();
    await tester.pump();

    expect(find.byKey(const Key('PictogramImage')), findsNWidgets(7));
  });

  testWidgets('Activity has checkmark when done', (WidgetTester tester) async {
    activity.state = ActivityState.Completed;
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pump();

    expect(find.byKey(const Key('IconComplete')), findsNWidgets(7));
  });

  testWidgets('Activity has no checkmark when Normal',
      (WidgetTester tester) async {
    activity.state = ActivityState.Normal;
    await tester.pumpWidget(MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pump();

    expect(find.byKey(const Key('IconComplete')), findsNothing);
  });

  testWidgets('Every add activitybutton is build', (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: WeekplanScreen(weekModel, user)));
    await tester.pump();

    expect(find.byKey(const Key('AddActivityButton')), findsNWidgets(7));
  });
}
