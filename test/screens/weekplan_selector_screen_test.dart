import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/blocs/weekplans_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/giraf_user_model.dart';
import 'package:weekplanner/models/pictogram_model.dart';
import 'package:weekplanner/models/week_model.dart';
import 'package:weekplanner/models/week_name_model.dart';
import 'package:weekplanner/providers/api/api.dart';
import 'package:weekplanner/screens/weekplan_selector_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

import '../blocs/weekplans_bloc_test.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  WeekplansBloc bloc;
  Api api;
  MockWeekApi weekApi;

  // PictogramModel pictogramModel = PictogramModel(
  //     id: 1,
  //     lastEdit: null,
  //     title: null,
  //     accessLevel: null,
  //     imageUrl: "http://any.tld",
  //     imageHash: null);

  GirafUserModel mockUser = GirafUserModel(id: "test");

  setUp(() {
    api = Api("any");
    weekApi = MockWeekApi();
    api.week = weekApi;
    bloc = WeekplansBloc(api);

    List<WeekNameModel> weekNameModelList = [];
    WeekNameModel weekNameModel =
        WeekNameModel(name: "name", weekNumber: 1, weekYear: 1);
    weekNameModelList.add(weekNameModel);

    WeekModel weekModel = WeekModel(name: "weekModel");

    when(weekApi.getNames("test"))
        .thenAnswer((_) => BehaviorSubject.seeded(weekNameModelList));

    when(weekApi.get("test", weekNameModel.weekYear, weekNameModel.weekNumber))
        .thenAnswer((_) => BehaviorSubject.seeded(weekModel));

    di.clearAll();
    di.registerDependency<WeekplansBloc>((_) => WeekplansBloc(api));
    di.registerDependency<AuthBloc>((_) => AuthBloc(api));
  });

  // testWidgets('renders', (WidgetTester tester) async {
  //   await tester.pumpWidget(MaterialApp(home: PictogramSearch()));
  // });

  testWidgets("Has Giraf App Bar", (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: WeekplanSelectorScreen(mockUser)));

    expect(find.byWidgetPredicate((widget) => widget is GirafAppBar),
        findsOneWidget);
  });

  // testWidgets("Display spinner on loading", (WidgetTester tester) async {
  //   final Completer<bool> done = Completer<bool>();
  //   const String query = "Kat";

  //   when(pictogramApi.getAll(page: 1, pageSize: 10, query: query))
  //       .thenAnswer((_) => BehaviorSubject.seeded([pictogramModel]));

  //   await tester.pumpWidget(MaterialApp(home: PictogramSearch()));
  //   await tester.enterText(find.byType(TextField), query);

  //   await tester.pump(Duration(milliseconds: 300));

  //   expect(find.byType(CircularProgressIndicator), findsOneWidget);

  //   bloc.pictograms.listen((List<PictogramModel> images) async {
  //     await tester.pump();
  //     expect(find.byType(CircularProgressIndicator), findsNothing);

  //     if (images != null) {
  //       done.complete(true);
  //     }
  //   });

  //   await done.future;
  // });

  // testWidgets("Displays PictogramImage on result", (WidgetTester tester) async {
  //   final Completer<bool> done = Completer<bool>();
  //   const String query = "Kat";

  //   when(pictogramApi.getAll(page: 1, pageSize: 10, query: query))
  //       .thenAnswer((_) => BehaviorSubject.seeded([pictogramModel]));

  //   await tester.pumpWidget(MaterialApp(home: PictogramSearch()));
  //   await tester.enterText(find.byType(TextField), query);

  //   await tester.pump(Duration(milliseconds: 300));

  //   bloc.pictograms.listen((List<PictogramModel> images) async {
  //     await tester.pump();
  //     expect(find.byType(PictogramImage), findsOneWidget);
  //     done.complete(true);
  //   });

  //   await done.future;
  // });

  // testWidgets("Pops on selection", (WidgetTester tester) async {
  //   final mockObserver = MockNavigatorObserver();
  //   final Completer<bool> done = Completer<bool>();
  //   const String query = "Kat";

  //   when(pictogramApi.getAll(page: 1, pageSize: 10, query: query))
  //       .thenAnswer((_) => BehaviorSubject.seeded([pictogramModel]));

  //   await tester.pumpWidget(
  //     MaterialApp(
  //       home: PictogramSearch(),
  //       navigatorObservers: [mockObserver],
  //     ),
  //   );
  //   await tester.enterText(find.byType(TextField), query);
  //   await tester.pump(Duration(milliseconds: 300));

  //   bloc.pictograms.listen((List<PictogramModel> images) async {
  //     await tester.pump();

  //     await tester.tap(find.byType(PictogramImage));

  //     final Route pushedRoute =
  //         verify(mockObserver.didPush(captureAny, any))
  //             .captured
  //             .single;

  //     PictogramModel popResult = await pushedRoute.popped;
  //     expect(await pushedRoute.popped, pictogramModel);
  //     done.complete(true);
  //   });

  //   await done.future;
  // });
}
