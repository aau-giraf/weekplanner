import 'package:api_client/api/api.dart';
import 'package:api_client/api/pictogram_api.dart';
import 'package:api_client/api/week_api.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:api_client/models/week_name_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/edit_weekplan_bloc.dart';
import 'package:weekplanner/blocs/pictogram_bloc.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/blocs/weekplan_selector_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/screens/edit_weekplan_screen.dart';
import 'package:weekplanner/screens/pictogram_search_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/giraf_confirm_dialog.dart';
import 'package:weekplanner/widgets/pictogram_image.dart';

import '../test_image.dart';

class MockEditWeekplanBloc extends EditWeekplanBloc {
  MockEditWeekplanBloc(this.api) : super(api);

  bool acceptAllInputs = true;
  Api api;

//  @override
//  Future<WeekModel> saveWeekplan(BuildContext context) {
//    final Completer<WeekModel> completer = Completer<WeekModel>();
//
//    api.week
//        .update('123', mockWeek.weekYear, mockWeek.weekNumber, mockWeek)
//        .listen(completer.complete);
//
//    return completer.future;
//  }

  @override
  Observable<bool> get validTitleStream =>
      Observable<bool>.just(acceptAllInputs);

  @override
  Observable<bool> get validYearStream =>
      Observable<bool>.just(acceptAllInputs);

  @override
  Observable<bool> get validWeekNumberStream =>
      Observable<bool>.just(acceptAllInputs);

  @override
  Observable<PictogramModel> get thumbnailStream =>
      Observable<PictogramModel>.just(mockPictogram);

  @override
  Observable<bool> get allInputsAreValidStream => Observable<bool>.just(true);
}

class MockWeekApi extends Mock implements WeekApi {}

class MockPictogramApi extends Mock implements PictogramApi {}

final PictogramModel mockPictogram = PictogramModel(
    id: 1,
    lastEdit: null,
    title: null,
    accessLevel: null,
    imageUrl: 'http://any.tld',
    imageHash: null);

final WeekModel mockWeek = WeekModel(
    thumbnail: mockPictogram,
    days: null,
    name: 'Week',
    weekNumber: 1,
    weekYear: 2019);

final UsernameModel mockUser =
    UsernameModel(name: 'test', role: 'test', id: 'test');

void main() {
  MockEditWeekplanBloc mockBloc;
  Api api;

  setUp(() {
    api = Api('any');
    api.week = MockWeekApi();
    api.pictogram = MockPictogramApi();

    when(api.pictogram.getImage(mockPictogram.id))
        .thenAnswer((_) => BehaviorSubject<Image>.seeded(sampleImage));

    when(api.week.update(any, any, any, any)).thenAnswer((_) {
      return Observable<WeekModel>.just(mockWeek);
    });

    when(api.week.getNames(any)).thenAnswer(
      (_) {
        return Observable<List<WeekNameModel>>.just(<WeekNameModel>[
          WeekNameModel(
              name: mockWeek.name,
              weekNumber: mockWeek.weekNumber,
              weekYear: mockWeek.weekYear),
        ]);
      },
    );

    when(api.week.get(any, any, any)).thenAnswer(
      (_) {
        return Observable<WeekModel>.just(mockWeek);
      },
    );

    final WeekplansBloc mockWeekplanSelector = WeekplansBloc(api);
    mockWeekplanSelector.load(mockUser);

    di.clearAll();
    di.registerSingleton<WeekplansBloc>((_) => mockWeekplanSelector);
    di.registerDependency<AuthBloc>((_) => AuthBloc(api));
    di.registerDependency<PictogramBloc>((_) => PictogramBloc(api));
    di.registerDependency<PictogramImageBloc>((_) => PictogramImageBloc(api));
    di.registerDependency<ToolbarBloc>((_) => ToolbarBloc());
    mockBloc = MockEditWeekplanBloc(api);
    di.registerDependency<EditWeekplanBloc>((_) => mockBloc);
  });

  group('EditWeekplanScreen rendering', () {
    testWidgets('Edit week plan screen renders', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditWeekPlanScreen(user: mockUser, weekModel: mockWeek),
        ),
      );
    });

    testWidgets('The screen has a GirafAppBar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditWeekPlanScreen(user: mockUser, weekModel: mockWeek),
        ),
      );

      expect(
          find.byWidgetPredicate((Widget widget) =>
              widget is GirafAppBar && widget.title == 'Rediger ugeplan'),
          findsOneWidget);
    });
  });

  group('EditWeekplanScreen input fields', () {
    testWidgets('Input fields are rendered', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditWeekPlanScreen(user: mockUser, weekModel: mockWeek),
        ),
      );

      expect(find.byType(TextField), findsNWidgets(3));
    });

    testWidgets('Pictograms are rendered', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditWeekPlanScreen(user: mockUser, weekModel: mockWeek),
        ),
      );
      await tester.pump();

      expect(find.byType(PictogramImage), findsOneWidget);
    });

    testWidgets('Buttons are rendered', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditWeekPlanScreen(user: mockUser, weekModel: mockWeek),
        ),
      );

      expect(find.byType(GirafButton), findsOneWidget);
    });

    testWidgets('Error text is shown on invalid title input',
        (WidgetTester tester) async {
      mockBloc.acceptAllInputs = false;
      await tester.pumpWidget(
        MaterialApp(
          home: EditWeekPlanScreen(user: mockUser, weekModel: mockWeek),
        ),
      );
      await tester.pump();

      expect(find.text('Titel skal angives'), findsOneWidget);
    });

    testWidgets('No error text is shown on valid title input',
        (WidgetTester tester) async {
      mockBloc.acceptAllInputs = true;
      await tester.pumpWidget(
        MaterialApp(
          home: EditWeekPlanScreen(user: mockUser, weekModel: mockWeek),
        ),
      );
      await tester.pump();

      expect(find.text('Titel skal angives'), findsNothing);
    });

    testWidgets('Error text is shown on invalid year input',
        (WidgetTester tester) async {
      mockBloc.acceptAllInputs = false;
      await tester.pumpWidget(
        MaterialApp(
          home: EditWeekPlanScreen(user: mockUser, weekModel: mockWeek),
        ),
      );
      await tester.pump();

      expect(find.text('År skal angives som fire cifre'), findsOneWidget);
    });

    testWidgets('No error text is shown on valid year input',
        (WidgetTester tester) async {
      mockBloc.acceptAllInputs = true;
      await tester.pumpWidget(
        MaterialApp(
          home: EditWeekPlanScreen(user: mockUser, weekModel: mockWeek),
        ),
      );
      await tester.pump();

      expect(find.text('År skal angives som fire cifre'), findsNothing);
    });

    testWidgets('Error text is shown on invalid week number input',
        (WidgetTester tester) async {
      mockBloc.acceptAllInputs = false;
      await tester.pumpWidget(
        MaterialApp(
          home: EditWeekPlanScreen(user: mockUser, weekModel: mockWeek),
        ),
      );
      await tester.pump();

      expect(find.text('Ugenummer skal være mellem 1 og 53'), findsOneWidget);
    });
    testWidgets('No error text is shown on valid week number input',
        (WidgetTester tester) async {
      mockBloc.acceptAllInputs = true;
      await tester.pumpWidget(
        MaterialApp(
          home: EditWeekPlanScreen(user: mockUser, weekModel: mockWeek),
        ),
      );
      await tester.pump();

      expect(find.text('Ugenummer skal være mellem 1 og 53'), findsNothing);
    });

    testWidgets('Emojis are blacklisted from title field',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditWeekPlanScreen(user: mockUser, weekModel: mockWeek),
        ),
      );
      await tester.enterText(
          find.byKey(const Key('NewWeekplanTitleField')), '☺♥');
      await tester.pump();

      expect(find.text('☺♥'), findsNothing);
    });

    testWidgets('Click on thumbnail redirects to pictogram search screen',
        (WidgetTester tester) async {
      mockBloc.acceptAllInputs = true;
      await tester.pumpWidget(
        MaterialApp(
          home: EditWeekPlanScreen(user: mockUser, weekModel: mockWeek),
        ),
      );
      await tester.tap(find.byKey(const Key('NewWeekplanThumbnailKey')));
      await tester.pumpAndSettle();

      expect(find.byType(PictogramSearch), findsOneWidget);
    });
  });

  group('Edit weekplan overwriting', () {
    testWidgets('Should show expected message when trying to overwrite',
        (WidgetTester tester) async {
      final WeekModel editWeekModel = WeekModel(
          name: mockWeek.name,
          weekNumber: mockWeek.weekNumber + 1,
          weekYear: mockWeek.weekYear,
          days: mockWeek.days,
          thumbnail: mockWeek.thumbnail);

      await tester.pumpWidget(
        MaterialApp(
          home: EditWeekPlanScreen(user: mockUser, weekModel: editWeekModel),
        ),
      );
      await tester.pump();

      await tester.enterText(
          find.byKey(const Key('NewWeekplanTitleField')), mockWeek.name);
      await tester.enterText(find.byKey(const Key('NewWeekplanYearField')),
          mockWeek.weekYear.toString());
      await tester.enterText(find.byKey(const Key('NewWeekplanWeekField')),
          mockWeek.weekNumber.toString());
      
      mockBloc.onThumbnailChanged.add(mockWeek.thumbnail);

      final Finder saveButton = find.byWidgetPredicate((Widget widget) =>
          widget is GirafButton && widget.text == 'Gem ændringer');
      await tester.tap(saveButton);

      await tester.pumpAndSettle();

      expect(find.byType(GirafConfirmDialog), findsOneWidget);
      expect(
          find.text('Ugeplanen (uge: ' +
              mockWeek.weekNumber.toString() +
              ', år: ' +
              mockWeek.weekYear.toString() +
              ') eksisterer '
                  'allerede. Vil du overskrive denne ugeplan?'),
          findsOneWidget);
    });
  });
}
