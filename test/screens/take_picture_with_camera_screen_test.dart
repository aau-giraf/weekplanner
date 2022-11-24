import 'package:api_client/api/pictogram_api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/api_client.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart' as rx_dart;
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/take_image_with_camera_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/screens/take_picture_with_camera_screen.dart';

class MockPictogramApi extends Mock implements PictogramApi {}

class MockUserApi extends Mock implements UserApi {
  @override
  Stream<GirafUserModel> me() {
    return Stream<GirafUserModel>.value(GirafUserModel(
      id: '1',
      department: 3,
      role: Role.Guardian,
      roleName: 'Guardian',
      displayName: 'Kurt',
      username: 'SpaceLord69',
    ));
  }
}

class MockTakePictureBloc extends TakePictureWithCameraBloc {
  MockTakePictureBloc(Api api) : super(api);

  @override
  Stream<bool> get isInputValid => _isInputValid.stream;

  final rx_dart.BehaviorSubject<bool> _isInputValid =
      rx_dart.BehaviorSubject<bool>.seeded(false);

  void setInputIsValid(bool b) {
    _isInputValid.add(b);
  }
}

void main() {
  MockTakePictureBloc bloc;
  Api api;

  setUp(() {
    api = Api('Any');
    api.pictogram = MockPictogramApi();
    api.user = MockUserApi();
    bloc = MockTakePictureBloc(api);

    di.clearAll();
    di.registerDependency<TakePictureWithCameraBloc>(() => bloc);
    di.registerDependency<ToolbarBloc>(() => ToolbarBloc());
    di.registerDependency<Api>(() => api);
    di.registerDependency<AuthBloc>(() => AuthBloc(api));
  });

  testWidgets('Screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: TakePictureWithCamera()));
    await tester.pumpAndSettle();

    expect(find.text('Tag billede med kamera'), findsOneWidget);
  });
}
