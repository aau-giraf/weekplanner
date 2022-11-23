import 'package:api_client/api/api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:api_client/models/settings_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/widgets/pictogram_password_widget.dart';
import '../blocs/pictogram_bloc_test.dart';

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

void main() {
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
    void onPasswordChangeDummy(String pass){
      return;
    }
    await tester.pumpWidget(MaterialApp(home: PictogramChoices(
      api: api, onPasswordChanged: (String pass) {
      onPasswordChangeDummy(pass);
      },
    )));
    await tester.pumpAndSettle();
    // Because of dependencies it shows 10 text boxes when testing
    expect(find.byKey(const Key('TestPictogram')), findsNWidgets(10));
    // Shows 4 empty boxes because no password has been input yet
    expect(find.byKey(const Key('InputPasswordContainer')), findsNWidgets(1));
  });

  testWidgets('Adds pictogram to login when "Pictogram" is pressed',
      (WidgetTester tester) async {
    void onPasswordChangeDummy(String pass){
      return;
    }
    await tester.pumpWidget(MaterialApp(home: PictogramChoices(
      api: api, onPasswordChanged: (String pass) {
        onPasswordChangeDummy(pass);
      },
    )));

    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('TestPictogram')).first);

    //await tester.pumpAndSettle();
    // Because of dependencies it shows 10 text boxes when testing
    expect(find.byWidget(const Text('LoginPictogram')), findsNWidgets(1));
  });
}
