import 'package:api_client/api/api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/api/week_api.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/access_level_enum.dart';
import 'package:api_client/models/enums/activity_state_enum.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/enums/weekday_enum.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/weekday_model.dart';
import 'package:async_test/async_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/blocs/weekplan_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/user_week_model.dart';
import 'package:weekplanner/screens/weekplan_screen.dart';

class MockWeekApi extends Mock implements WeekApi {}

class MockUserApi extends Mock implements UserApi {
  @override
  Observable<GirafUserModel> me() {
    return Observable<GirafUserModel>.just(GirafUserModel(
      id: '1',
      department: 3,
      role: Role.Guardian,
      roleName: 'Guardian',
      displayName: 'Kurt',
      username: 'SpaceLord69',
    ));
  }
}

void main() {
  WeekplanBloc weekplanBloc;
  Api api;

  WeekModel week;

  final DisplayNameModel user = DisplayNameModel(
    role: Role.Guardian.toString(),
    displayName: 'User',
    id: '1'
  );

  final List<ActivityModel> mockActivities = <ActivityModel>[
    ActivityModel(
        id: 1234,
        state: ActivityState.Normal,
        order: 0,
        isChoiceBoard: false,
        pictogram: PictogramModel(
            id: 25,
            title: 'grå',
            accessLevel: AccessLevel.PUBLIC,
            imageHash: null,
            imageUrl: null,
            lastEdit: null)),
    ActivityModel(
        id: 1381,
        state: ActivityState.Normal,
        order: 0,
        isChoiceBoard: false,
        pictogram: PictogramModel(
            id: 25,
            title: 'grå',
            accessLevel: AccessLevel.PUBLIC,
            imageHash: null,
            imageUrl: null,
            lastEdit: null))
  ];

  setUp(() {
    week = WeekModel(
        thumbnail: PictogramModel(
            imageUrl: null,
            imageHash: null,
            accessLevel: null,
            title: null,
            id: null,
            lastEdit: null),
        days: <WeekdayModel>[
          WeekdayModel(activities: <ActivityModel>[], day: Weekday.Monday),
          WeekdayModel(activities: <ActivityModel>[], day: Weekday.Tuesday)
        ],
        name: 'Week',
        weekNumber: 1,
        weekYear: 2019);

    api = Api('any');

    api.user = MockUserApi();
    api.week = MockWeekApi();
    when(api.week.update(any, any, any, any)).thenAnswer((Invocation inv) {
      return Observable<WeekModel>.just(inv.positionalArguments[3]);
    });

    when(api.week.get(any, any, any)).thenAnswer((Invocation inv) {
      return Observable<WeekModel>.just(week);
    });

    when(api.user.getSettings(user.id)).thenAnswer((_) =>
        BehaviorSubject<SettingsModel>());

    weekplanBloc = WeekplanBloc(api);
    di.clearAll();
    di.registerDependency<WeekplanBloc>((_) => weekplanBloc);
    di.registerDependency<SettingsBloc>((_) => SettingsBloc(api));
    di.registerDependency<AuthBloc>((_) =>  AuthBloc(api));
    di.registerDependency<ToolbarBloc>((_) => ToolbarBloc());
  });

  testWidgets('Marks all and unmarks all activities for a given day',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home:WeekplanScreen(week, user)));
        await tester.pumpAndSettle();

        expect(find.byTooltip('Rediger'), findsOneWidget);
        await tester.tap(find.byTooltip('Rediger'));
        await tester.pump();

        expect(weekplanBloc.getNumberOfMarkedActivities(), 0);
        expect(find.byKey(const Key('SelectAllButton')), findsNWidgets(2));
        expect(find.byKey(const Key('DeselectAllButton')), findsNWidgets(2));

        weekplanBloc.addActivity(mockActivities.first, 0);
        weekplanBloc.addActivity(mockActivities.last, 0);
        await tester.pump();

        ///checking that the select all activities button works
        await tester.tap(find.byKey(const Key('SelectAllButton')).first);
        await tester.pump();
        expect(weekplanBloc.getNumberOfMarkedActivities(), 2);

        ///checking that the Deselect all activities button works
        await tester.tap(find.byKey(const Key('DeselectAllButton')).first);
        await tester.pump();
        expect(weekplanBloc.getNumberOfMarkedActivities(), 0);
      });



  testWidgets('Marks all and unmarks all activities for a given day',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home:WeekplanScreen(week, user)));
        await tester.pumpAndSettle();

        expect(find.byTooltip('Rediger'), findsOneWidget);
        await tester.tap(find.byTooltip('Rediger'));
        await tester.pump();

        expect(weekplanBloc.getNumberOfMarkedActivities(), 0);
        expect(find.byKey(const Key('SelectAllButton')), findsNWidgets(2));
        expect(find.byKey(const Key('DeselectAllButton')), findsNWidgets(2));

        weekplanBloc.addActivity(mockActivities.first, 0);
        weekplanBloc.addActivity(mockActivities.last, 0);
        await tester.pump();

        ///checking that the select all activities button works
        await tester.tap(find.byKey(const Key('SelectAllButton')).first);
        await tester.pump();
        expect(weekplanBloc.getNumberOfMarkedActivities(), 2);

        ///checking that the Deselect all activities button works
        await tester.tap(find.byKey(const Key('DeselectAllButton')).first);
        await tester.pump();
        expect(weekplanBloc.getNumberOfMarkedActivities(), 0);
      });
}
