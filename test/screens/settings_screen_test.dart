import 'package:api_client/api/api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/models/enums/cancel_mark_enum.dart';
import 'package:api_client/models/enums/complete_mark_enum.dart';
import 'package:api_client/models/enums/default_timer_enum.dart';
import 'package:api_client/models/enums/giraf_theme_enum.dart';
import 'package:api_client/models/enums/orientation_enum.dart' as _orientation;
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:api_client/models/username_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/screens/settings_screens/settings_screen.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

class MockUserApi extends Mock implements UserApi {
  @override
  Observable<GirafUserModel> me() {
    return Observable<GirafUserModel>.just(
        GirafUserModel(id: '1', username: 'test', role: Role.Guardian));
  }

  @override
  Observable<SettingsModel> getSettings(String id) {
    return Observable<SettingsModel>.just(SettingsModel(
      orientation: _orientation.Orientation.Landscape,
      completeMark: CompleteMark.Checkmark,
      cancelMark: CancelMark.Cross,
      theme: GirafTheme.GirafYellow,
      defaultTimer: DefaultTimer.Hourglass,
      nrOfDaysToDisplay: 5,
    ));
  }
}

void main() {
  Api api;

  final UsernameModel user = UsernameModel(
      name: 'Anders And', id: '101', role: Role.Guardian.toString());

  setUp(() {

    di.clearAll();
    api = Api('any');
    api.user = MockUserApi();

    di.registerDependency<AuthBloc>((_) => AuthBloc(api));
    di.registerDependency<SettingsBloc>((_) => SettingsBloc(api));
    di.registerDependency<ToolbarBloc>((_) => ToolbarBloc());
  });

  testWidgets('Has GirafAppBar', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SettingsScreen(user)));
    expect(find.byType(GirafAppBar), findsOneWidget);
  });

  testWidgets('Settings screen has correct title', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SettingsScreen(user)));
    final Finder titleFinder = find.text(user.name + ' indstillinger');
    expect(titleFinder, findsOneWidget);
  });

}
