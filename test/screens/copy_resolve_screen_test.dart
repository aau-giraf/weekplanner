import 'package:api_client/models/username_model.dart';
import 'package:api_client/models/week_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/copy_resolve_bloc.dart';
import 'package:weekplanner/blocs/copy_weekplan_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/screens/copy_resolve_screen.dart';
import 'package:api_client/api/api.dart';



void main() {
  Api api;

  setUp(() {
    api = Api('any');
    di.registerDependency<CopyResolveBloc>((_)=> CopyResolveBloc(api));
    di.registerDependency<CopyWeekplanBloc>((_)=> CopyWeekplanBloc(api));
    di.registerDependency<AuthBloc>((_) => AuthBloc(api));
    di.registerDependency<SettingsBloc>((_) => SettingsBloc(api));
    di.registerDependency<ToolbarBloc>((_) => ToolbarBloc());
  });

  testWidgets('Renders CopyResolveScreen', (WidgetTester tester) async {
    final UsernameModel mockUser =
        UsernameModel(name: 'test', role: 'test', id: 'test');
    final WeekModel weekplan1 = WeekModel(
        thumbnail: null, name: 'weekplan1', weekYear: 2020, weekNumber: 32);
    await tester.pumpWidget(MaterialApp(
        home: CopyResolveScreen(currentUser: mockUser, weekModel: weekplan1)));
    expect(find.byType(CopyResolveScreen), findsOneWidget);
  });
}
