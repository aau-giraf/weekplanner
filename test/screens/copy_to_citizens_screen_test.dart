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
import 'package:weekplanner/blocs/choose_citizen_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/screens/copy_to_citizens_screen.dart';

class MockUserApi extends Mock implements UserApi {
  @override
  Observable<GirafUserModel> me() {
    return Observable<GirafUserModel>.just(
        GirafUserModel(id: '1', username: 'test', role: Role.Guardian));
  }

  @override
  Observable<List<UsernameModel>> getCitizens(String id) {
    final List<UsernameModel> output = <UsernameModel>[];
    output.add(UsernameModel(name: 'test1', role: 'test1', id: id));
    output.add(UsernameModel(name: 'test1', role: 'test1', id: id));
    output.add(UsernameModel(name: 'test1', role: 'test1', id: id));
    output.add(UsernameModel(name: 'test1', role: 'test1', id: id));
    return Observable<List<UsernameModel>>.just(output);
  }
}

void main() {
  ChooseCitizenBloc bloc;
  ToolbarBloc toolbarBloc;
  Api api;
  setUp(() {
    di.clearAll();
    api = Api('any');
    api.user = MockUserApi();
    bloc = ChooseCitizenBloc(api);
    di.registerDependency<AuthBloc>((_) => AuthBloc(api));
    toolbarBloc = ToolbarBloc();
    di.registerDependency<ChooseCitizenBloc>((_) => bloc);
    di.registerDependency<SettingsBloc>((_) => SettingsBloc(api));
    di.registerDependency<ToolbarBloc>((_) => toolbarBloc);
  });

  testWidgets('Renders CopyToCitizenScreen', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: CopyToCitizensScreen()));
    expect(find.byType(CopyToCitizensScreen), findsOneWidget);
  });



}