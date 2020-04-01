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
import 'package:weekplanner/blocs/new_weekplan_bloc.dart';
import 'package:weekplanner/blocs/pictogram_bloc.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/blocs/weekplan_selector_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/screens/new_weekplan_screen.dart';
import 'package:weekplanner/screens/pictogram_search_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/giraf_confirm_dialog.dart';
import 'package:weekplanner/widgets/pictogram_image.dart';

import '../test_image.dart';

class MockNewWeekplanBloc extends NewWeekplanBloc {
  MockNewWeekplanBloc(this.api) : super(api);

  bool acceptAllInputs = true;
  Api api;

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
  MockNewWeekplanBloc mockBloc;
  Api api;
  bool savedWeekplan;

  setUp(() {
    api = Api('any');
    api.week = MockWeekApi();
    api.pictogram = MockPictogramApi();
    savedWeekplan = false;

    when(api.pictogram.getImage(mockPictogram.id))
        .thenAnswer((_) => BehaviorSubject<Image>.seeded(sampleImage));

    when(api.week.update(any, any, any, any)).thenAnswer((_) {
      savedWeekplan = true;
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

    mockBloc = MockNewWeekplanBloc(api);
    di.registerDependency<NewWeekplanBloc>((_) => mockBloc);
  });

  testWidgets('Screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: NewWeekplanScreen(mockUser),
      ),
    );
  });

  testWidgets('The screen has a Giraf App Bar', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: NewWeekplanScreen(mockUser),
      ),
    );

    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is GirafAppBar && widget.title == 'Ny ugeplan'),
        findsOneWidget);
  });

  testWidgets('Input fields are rendered', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: NewWeekplanScreen(mockUser),
      ),
    );

    expect(find.byType(TextField), findsNWidgets(3));
  });

  testWidgets('Pictograms are rendered', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: NewWeekplanScreen(mockUser),
      ),
    );
    await tester.pump();

    expect(find.byType(PictogramImage), findsOneWidget);
  });

  testWidgets('Buttons are rendered', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: NewWeekplanScreen(mockUser),
      ),
    );

    expect(find.byType(GirafButton), findsNWidgets(1));
  });

  testWidgets('Error text is shown on invalid title input',
      (WidgetTester tester) async {
    mockBloc.acceptAllInputs = false;
    await tester.pumpWidget(
      MaterialApp(
        home: NewWeekplanScreen(mockUser),
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
        home: NewWeekplanScreen(mockUser),
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
        home: NewWeekplanScreen(mockUser),
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
        home: NewWeekplanScreen(mockUser),
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
        home: NewWeekplanScreen(mockUser),
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
        home: NewWeekplanScreen(mockUser),
      ),
    );
    await tester.pump();

    expect(find.text('Ugenummer skal være mellem 1 og 53'), findsNothing);
  });

  testWidgets('Emojis are blacklisted from title field',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: NewWeekplanScreen(mockUser),
      ),
    );
    await tester.enterText(
        find.byKey(const Key('WeekTitleTextFieldKey')), '☺♥');
    await tester.pump();

    expect(find.text('☺♥'), findsNothing);
  });

  testWidgets('Click on thumbnail redirects to pictogram search screen',
      (WidgetTester tester) async {
    mockBloc.acceptAllInputs = true;
    await tester.pumpWidget(
      MaterialApp(
        home: NewWeekplanScreen(mockUser),
      ),
    );
    await tester.tap(find.byKey(const Key('WeekThumbnailKey')));
    await tester.pumpAndSettle();

    expect(find.byType(PictogramSearch), findsOneWidget);
  });

  testWidgets(
      'Click on save weekplan button saves weekplan and return saved weekplan',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: NewWeekplanScreen(mockUser),
      ),
    );

    await tester.pump();
    await tester.enterText(
        find.byKey(const Key('WeekTitleTextFieldKey')), 'Test');
    await tester.enterText(
        find.byKey(const Key('WeekYearTextFieldKey')), '2020');
    await tester.enterText(
        find.byKey(const Key('WeekNumberTextFieldKey')), '20');
    mockBloc.onThumbnailChanged.add(mockWeek.thumbnail);
    await tester.tap(find.byKey(const Key('NewWeekplanSaveBtnKey')));

    expect(savedWeekplan, true);
  });

  testWidgets('Should show overwrite dialog if trying to overwrite',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: NewWeekplanScreen(mockUser),
      ),
    );

    await tester.pump();
    await tester.enterText(
        find.byKey(const Key('WeekTitleTextFieldKey')), mockWeek.name);
    await tester.enterText(find.byKey(const Key('WeekYearTextFieldKey')),
        mockWeek.weekYear.toString());
    await tester.enterText(find.byKey(const Key('WeekNumberTextFieldKey')),
        mockWeek.weekNumber.toString());
    mockBloc.onThumbnailChanged.add(mockWeek.thumbnail);

    await tester.tap(find.byKey(const Key('NewWeekplanSaveBtnKey')));
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

  testWidgets(
      'Should remove overwrite dialog when tapping the "Fortryd" button',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: NewWeekplanScreen(mockUser),
      ),
    );

    await tester.pump();
    await tester.enterText(
        find.byKey(const Key('WeekTitleTextFieldKey')), mockWeek.name);
    await tester.enterText(find.byKey(const Key('WeekYearTextFieldKey')),
        mockWeek.weekYear.toString());
    await tester.enterText(find.byKey(const Key('WeekNumberTextFieldKey')),
        mockWeek.weekNumber.toString());
    mockBloc.onThumbnailChanged.add(mockWeek.thumbnail);

    await tester.tap(find.byKey(const Key('NewWeekplanSaveBtnKey')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('ConfirmDialogCancelButton')));
    await tester.pumpAndSettle();

    expect(find.byType(GirafConfirmDialog), findsNothing);
    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is GirafAppBar && widget.title == 'Ny ugeplan'),
        findsOneWidget);
    expect(savedWeekplan, false);
  });

  testWidgets(
      'Saves weekplan when tapping the "Okay" button in Overwrite dialog',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: NewWeekplanScreen(mockUser),
      ),
    );

    await tester.pump();
    await tester.enterText(
        find.byKey(const Key('WeekTitleTextFieldKey')), mockWeek.name);
    await tester.enterText(find.byKey(const Key('WeekYearTextFieldKey')),
        mockWeek.weekYear.toString());
    await tester.enterText(find.byKey(const Key('WeekNumberTextFieldKey')),
        mockWeek.weekNumber.toString());
    mockBloc.onThumbnailChanged.add(mockWeek.thumbnail);

    await tester.tap(find.byKey(const Key('NewWeekplanSaveBtnKey')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('ConfirmDialogConfirmButton')));
    await tester.pumpAndSettle();

    expect(find.byType(GirafConfirmDialog), findsNothing);
    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is GirafAppBar && widget.title == 'Ny ugeplan'),
        findsOneWidget);
    expect(savedWeekplan, true);
  });
}
