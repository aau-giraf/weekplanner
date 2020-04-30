import 'dart:async';

import 'package:api_client/api/user_api.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/api/api.dart';
import 'package:weekplanner/widgets/pictogram_image.dart';
import 'package:weekplanner/widgets/pictogram_text.dart';

import '../blocs/pictogram_bloc_test.dart';
import '../screens/settings_screens/settings_screen_test.dart';
import '../test_image.dart';

SettingsModel mockSettings;

class MockUserApi extends Mock implements UserApi {
  @override
  Observable<GirafUserModel> me() {
    return Observable<GirafUserModel>.just(
        GirafUserModel(id: '1', username: 'test', role: Role.Guardian));
  }

  @override
  Observable<SettingsModel> getSettings(String id) {
    return Observable<SettingsModel>.just(mockSettings);
  }
}

void main() {
  Api api;
  SettingsBloc settingsBloc;

  final DisplayNameModel user = DisplayNameModel(
      displayName: 'Anders And', id: '101', role: Role.Guardian.toString());

  final PictogramModel pictogramModel = PictogramModel(
      id: 1,
      lastEdit: null,
      title: 'SomeTitle',
      accessLevel: null,
      imageUrl: 'http://any.tld',
      imageHash: null);

  setUp(() {
    di.clearAll();
    api = Api('any');

    mockSettings = SettingsModel(
      orientation: null,
      completeMark: null,
      cancelMark: null,
      defaultTimer: null,
      theme: null,
      nrOfDaysToDisplay: 1,
      weekDayColors: null,
      lockTimerControl: false,
      pictogramText: false,
    );

    api.user = MockUserApi();
    settingsBloc = SettingsBloc(api);
    di.registerDependency<SettingsBloc>((_) => settingsBloc);
  });

  testWidgets('Pictogram text is not displayed when false',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: PictogramText(pictogramModel, user)));
    await tester.pumpAndSettle();

    expect(find.byType(Container), findsOneWidget);
    expect(find.text('SomeTitle'), findsNothing);
  });

  testWidgets('Pictogram text is displayed when true',
      (WidgetTester tester) async {
    mockSettings.pictogramText = true;
    await tester
        .pumpWidget(MaterialApp(home: PictogramText(pictogramModel, user)));
    await tester.pumpAndSettle();

    expect(find.byType(AutoSizeText), findsOneWidget);
    //expect(find.text('SomeTitle'), findsOneWidget);
  });
}
