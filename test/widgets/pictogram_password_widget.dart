import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/routes.dart';
import 'package:weekplanner/widgets/loading_spinner_widget.dart';
import 'package:weekplanner/widgets/pictogram_image.dart';
import 'package:weekplanner/widgets/pictogram_password_widget.dart';
import 'package:api_client/api/api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/models/activity_model.dart';
import 'package:api_client/models/displayname_model.dart';
import 'package:api_client/models/enums/activity_state_enum.dart';
import 'package:api_client/models/enums/complete_mark_enum.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weekplanner/blocs/activity_bloc.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/settings_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/enums/weekplan_mode.dart';
import 'package:weekplanner/widgets/pictogram_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/di.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:weekplanner/widgets/pictogram_image.dart';
import 'package:api_client/api/api.dart';

import '../blocs/pictogram_bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart' as rx_dart;
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:mockito/mockito.dart';
import 'package:api_client/api/api.dart';
import 'package:api_client/api/pictogram_api.dart';
import 'package:async_test/async_test.dart';

import '../test_image.dart';

SettingsModel mockSettings;

class MockUserApi extends Mock implements UserApi {
  @override
  Stream<GirafUserModel> me() {
    return Stream<GirafUserModel>.value(
        GirafUserModel(id: '1', username: 'test', role: Role.Guardian));
  }

  @override
  Stream<SettingsModel> getSettings(String id) {
    return Stream<SettingsModel>.value(mockSettings);
  }
}

void main(){
  Api api;
  MockPictogramApi pictogramApi;
  setUp(() {
    di.clearAll();
    api = Api('any');
    di.registerDependency((_) => api);
    pictogramApi = MockPictogramApi();
    api.pictogram = pictogramApi;
  });

  testWidgets('Shows 10 "pictogram" options', (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home:
        PictogramChoices(
            api: api)
        )
    );
    await tester.pumpAndSettle();
    // Because of dependencies it shows 10 text boxes when testing
    expect(find.byKey(const Key('TestPictogram')),findsNWidgets(10));
    // Shows 4 empty boxes because no password has been input yet
    expect(find.byKey(const Key('Empty password container')), findsNWidgets(4));
  });

  testWidgets('Adds pictogram to login when "Pictogram is pressed',
          (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home:
        PictogramChoices(
            api: api)
        )
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('TestPictogram')).first);
    // Because of dependencies it shows 10 text boxes when testing
    expect(find.byKey(const Key('LoginPictogram')),findsNWidgets(1));
  });
}