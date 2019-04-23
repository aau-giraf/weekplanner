import 'package:api_client/api/api.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/models/username_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/new_weekplan_bloc.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/screens/new_weekplan_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/pictogram_image.dart';

import '../blocs/pictogram_bloc_test.dart';
import '../blocs/weekplan_bloc_test.dart';
import '../test_image.dart';

final PictogramModel mockPictogram = PictogramModel(
    id: 1,
    lastEdit: null,
    title: null,
    accessLevel: null,
    imageUrl: 'http://any.tld',
    imageHash: null);

class MockNewWeekplanBloc extends NewWeekplanBloc {
  MockNewWeekplanBloc(Api api) : super(api);

  bool acceptAllInputs = true;

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
}

void main() {
  MockNewWeekplanBloc mockBloc;
  Api api;
  MockWeekApi weekApi;
  MockPictogramApi pictogramApi;
  final UsernameModel mockUser =
      UsernameModel(name: 'test', role: 'test', id: 'test');

  setUp(() {
    api = Api('any');
    weekApi = MockWeekApi();
    pictogramApi = MockPictogramApi();
    api.pictogram = pictogramApi;
    api.week = weekApi;
    mockBloc = MockNewWeekplanBloc(api);

    when(pictogramApi.getImage(mockPictogram.id))
        .thenAnswer((_) => BehaviorSubject<Image>.seeded(sampleImage));

    di.clearAll();
    di.registerDependency<AuthBloc>((_) => AuthBloc(api));
    di.registerDependency<PictogramImageBloc>((_) => PictogramImageBloc(api));
    di.registerDependency<ToolbarBloc>((_) => ToolbarBloc());
    di.registerDependency<NewWeekplanBloc>((_) => mockBloc);
  });

  testWidgets('Screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: NewWeekplanScreen(mockUser)));
  });

  testWidgets('The screen has a Giraf App Bar', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: NewWeekplanScreen(mockUser)));

    expect(find.byWidgetPredicate((Widget widget) => widget is GirafAppBar),
        findsOneWidget);
  });

  testWidgets('Input fields are rendered', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: NewWeekplanScreen(mockUser)));

    expect(find.byType(TextField), findsNWidgets(3));
  });

  testWidgets('Pictograms are rendered', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: NewWeekplanScreen(mockUser)));
    await tester.pump();

    expect(find.byType(PictogramImage), findsOneWidget);
  });

  testWidgets('Buttons are rendered', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: NewWeekplanScreen(mockUser)));

    expect(find.byType(RaisedButton), findsNWidgets(2));
  });

  testWidgets('Error text is shown on invalid title input',
      (WidgetTester tester) async {
    mockBloc.acceptAllInputs = false;
    await tester.pumpWidget(MaterialApp(home: NewWeekplanScreen(mockUser)));
    await tester.pump();

    expect(find.text('Titel skal være mellem 1 og 32 tegn'), findsOneWidget);
  });

  testWidgets('No error text is shown on valid title input',
      (WidgetTester tester) async {
    mockBloc.acceptAllInputs = true;
    await tester.pumpWidget(MaterialApp(home: NewWeekplanScreen(mockUser)));
    await tester.pump();

    expect(find.text('Titel skal være mellem 1 og 32 tegn'), findsNothing);
  });

  testWidgets('Error text is shown on invalid year input',
      (WidgetTester tester) async {
    mockBloc.acceptAllInputs = false;
    await tester.pumpWidget(MaterialApp(home: NewWeekplanScreen(mockUser)));
    await tester.pump();

    expect(find.text('År skal angives som fire cifre'), findsOneWidget);
  });

  testWidgets('No error text is shown on valid year input',
      (WidgetTester tester) async {
    mockBloc.acceptAllInputs = true;
    await tester.pumpWidget(MaterialApp(home: NewWeekplanScreen(mockUser)));
    await tester.pump();

    expect(find.text('År skal angives som fire cifre'), findsNothing);
  });

  testWidgets('Error text is shown on invalid week number input',
      (WidgetTester tester) async {
    mockBloc.acceptAllInputs = false;
    await tester.pumpWidget(MaterialApp(home: NewWeekplanScreen(mockUser)));
    await tester.pump();

    expect(find.text('Ugenummer skal være mellem 1 og 53'), findsOneWidget);
  });

  testWidgets('No error text is shown on valid week number input',
      (WidgetTester tester) async {
    mockBloc.acceptAllInputs = true;
    await tester.pumpWidget(MaterialApp(home: NewWeekplanScreen(mockUser)));
    await tester.pump();

    expect(find.text('Ugenummer skal være mellem 1 og 53'), findsNothing);
  });
}
