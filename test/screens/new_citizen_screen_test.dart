import 'package:api_client/api/api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:api_client/models/username_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/new_citizen_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/screens/new_citizen_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import '../test_image.dart';

class MockNewCitizenBloc extends NewCitizenBloc {
  MockNewCitizenBloc(this.api) : super(api);

  bool acceptAllInputs = true;
  Api api;

  @override
  Observable<GirafUserModel> createCitizen() {
    return api.account.register(
        'mockUserName', 'password', departmentId: null, role: null);
  }

  @override
  Observable<bool> get validDisplayNameStream =>
    Observable<bool>.just(acceptAllInputs);

  @override
  Observable<bool> get validUsernameStream =>
      Observable<bool>.just(acceptAllInputs);

  @override
  Observable<bool> get validPasswordStream =>
      Observable<bool>.just(acceptAllInputs);

  @override
  Observable<bool> get validPasswordVerificationStream =>
      Observable<bool>.just(acceptAllInputs);

  @override
  Observable<bool> get allInputsAreValidStream =>
      Observable<bool>.just(true);
}

class MockUserApi extends Mock implements UserApi {
  @override
  Observable<GirafUserModel> me() {
    return Observable<GirafUserModel>.just(GirafUserModel(
        id: '1',
        department: 1,
        role: Role.Guardian,
        roleName: 'Guardian',
        screenName: 'Kirsten Birgit',
        username: 'kb7913'));
  }
}

void main() {
  Api api;
  MockNewCitizenBloc mockNewCitizenBloc;

  setUp(() {
    api = Api('any');
    mockNewCitizenBloc = MockNewCitizenBloc(api);

    di.clearAll();
    di.registerDependency<AuthBloc>((_) => AuthBloc(api));
    di.registerDependency<ToolbarBloc>((_) => ToolbarBloc());
    di.registerDependency<NewCitizenBloc>((_) => mockNewCitizenBloc);
  });

  testWidgets('Screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: NewCitizenScreen()));
  });

  testWidgets('The screen has a Giraf App Bar', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: NewCitizenScreen()));

    expect(find.byWidgetPredicate((Widget widget) => widget is GirafAppBar),
        findsOneWidget);
  });

  testWidgets('Input fields are rendered', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: NewCitizenScreen()));

    expect(find.byType(TextFormField), findsNWidgets(4));
  });

  testWidgets('Buttons are rendered', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: NewCitizenScreen()));

    expect(find.byType(GirafButton), findsNWidgets(2));
  });

  testWidgets('Error text is shown on invalid title input',
          (WidgetTester tester) async {
        mockNewCitizenBloc.acceptAllInputs = false;
        await tester.pumpWidget(MaterialApp(home: NewCitizenScreen()));
        await tester.pump();

        expect(find.text('Titel skal angives'), findsOneWidget);
      });

}