import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weekplanner/blocs/activity_bloc.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/activity_model.dart';
import 'package:weekplanner/models/enums/access_level_enum.dart';
import 'package:weekplanner/models/enums/activity_state_enum.dart';
import 'package:weekplanner/models/enums/weekday_enum.dart';
import 'package:weekplanner/models/pictogram_model.dart';
import 'package:weekplanner/models/username_model.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/models/weekday_model.dart';
import 'package:weekplanner/providers/api/api.dart';
import 'package:weekplanner/screens/show_activity_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

import '../blocs/activity_bloc_test.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  ActivityBloc bloc;
  Api api;
  MockWeekApi weekApi;
  final List<ActivityModel> activities = <ActivityModel>[ActivityModel(
    id: 1381, 
    state: ActivityState.Normal, 
    order: 0,
    isChoiceBoard: false,
    pictogram: PictogramModel(
      id: 25,
      title: 'grå',
      accessLevel: AccessLevel.PUBLIC, 
      imageHash: null, imageUrl: null, lastEdit: null
    ))];
  final List<WeekdayModel> weekdayModels = <WeekdayModel>[WeekdayModel(
    activities: activities,
    day: Weekday.Monday
  )];
  final WeekModel mockWeek = WeekModel(
    weekYear: 2018, 
    weekNumber: 21, 
    name: 'Uge 1', 
    thumbnail: PictogramModel(
      id: 25,
      title: 'grå',
      accessLevel: AccessLevel.PUBLIC, 
      imageHash: null, imageUrl: null, lastEdit: null
    ),
    days: weekdayModels);
  final ActivityModel mockActivity = mockWeek.days[0].activities[0];
  final UsernameModel mockUser = UsernameModel(id: '42', 
  name: null, role: null);

  void setupApiCalls() {}

  setUp(() {
    api = Api('any');
    weekApi = MockWeekApi();
    api.week = weekApi;
    bloc = ActivityBloc(api);

    setupApiCalls();

    di.clearAll();
    di.registerDependency<ActivityBloc>((_) => bloc);
    di.registerDependency<AuthBloc>((_) => AuthBloc(api));
    di.registerDependency<PictogramImageBloc>((_) => PictogramImageBloc(api));
    di.registerDependency<ToolbarBloc>((_) => ToolbarBloc());
  });

  testWidgets('renders', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: ShowActivityScreen(mockWeek, mockActivity, mockUser)));
  });

  testWidgets('Has Giraf App Bar', (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(
          home: ShowActivityScreen(mockWeek, mockActivity, mockUser)));

    expect(find.byWidgetPredicate((Widget widget) => widget is GirafAppBar),
        findsOneWidget);
  });



  testWidgets('Activity and timer card is rendered',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(
          home: ShowActivityScreen(mockWeek, mockActivity, mockUser)));

    expect(find.text('Aktivitet'), findsNWidgets(2));
    expect(find.text('Timer'), findsOneWidget);
    expect(find.byKey(Key(mockActivity.id.toString())), findsOneWidget);
  });

  testWidgets('ButtonBar is rendered',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(
          home: ShowActivityScreen(mockWeek, mockActivity, mockUser)));

    expect(find.byKey(const Key('ButtonBarRender')), findsOneWidget);
  });
}