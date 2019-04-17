import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/choose_citizen_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/models/enums/role_enum.dart';
import 'package:weekplanner/providers/api/api.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/giraf_user_model.dart';
import 'package:weekplanner/models/username_model.dart';
import 'package:weekplanner/providers/api/user_api.dart';
import 'package:weekplanner/screens/choose_citizen_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

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

class MockCitizens extends Mock implements UserApi {}

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
    di.registerDependency<SettingsBloc>((_) => SettingsBloc());
    di.registerDependency<ToolbarBloc>((_) => toolbarBloc);
  });

  testWidgets('Renders ChooseCitizenScreen', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ChooseCitizenScreen()));
    expect(find.byType(ChooseCitizenScreen), findsOneWidget);
  });

  testWidgets('Has GirafAppBar', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ChooseCitizenScreen()));
    expect(find.byType(GirafAppBar), findsOneWidget);
  });

  testWidgets('Has Citizens Avatar', (WidgetTester tester) async {
    final Completer<bool> done = Completer<bool>();
    await tester.pumpWidget(MaterialApp(home: ChooseCitizenScreen()));
    await tester.pumpAndSettle();
    bloc.citizen.listen((List<UsernameModel> response) {
      expect(find.byType(CircleAvatar), findsNWidgets(response.length));
      done.complete(true);
    });
    await done.future;
  });

  testWidgets('Has Citizens Text [Name] (4)', (WidgetTester tester) async {
    final Completer<bool> done = Completer<bool>();
    await tester.pumpWidget(MaterialApp(home: ChooseCitizenScreen()));
    await tester.pumpAndSettle();
    bloc.citizen.listen((List<UsernameModel> response) {
      expect(find.byType(AutoSizeText), findsNWidgets(response.length));
      done.complete(true);
    });
    await done.future;
  });
}
