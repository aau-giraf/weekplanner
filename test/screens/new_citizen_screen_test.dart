import 'package:api_client/api/api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/new_citizen_bloc.dart';
import 'package:weekplanner/screens/new_citizen_screen.dart';
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
  MockNewCitizenBloc mockNewCitizenBloc;
  Api api;

  testWidgets('Screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: NewCitizenScreen()));
  });
}