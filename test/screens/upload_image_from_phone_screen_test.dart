import 'package:api_client/api/api.dart';
import 'package:api_client/api/pictogram_api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/api_client.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/auth_bloc.dart';
import 'package:weekplanner/blocs/toolbar_bloc.dart';
import 'package:weekplanner/blocs/upload_from_gallery_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/screens/upload_image_from_phone_screen.dart';

class MockPictogramApi extends Mock implements PictogramApi {}

class MockUserApi extends Mock implements UserApi {
  @override
  Observable<GirafUserModel> me() {
    return Observable<GirafUserModel>.just(GirafUserModel(
      id: '1',
      department: 3,
      role: Role.Guardian,
      roleName: 'Guardian',
      screenName: 'Kurt',
      username: 'SpaceLord69',
    ));
  }
}

void main() {
  UploadFromGalleryBloc bloc;
  Api api;

  setUp(() {
    api = Api('Any');
    api.pictogram = MockPictogramApi();
    api.user = MockUserApi();
    bloc = UploadFromGalleryBloc(api);

    di.clearAll();
    di.registerDependency<UploadFromGalleryBloc>((_) => bloc);
    di.registerDependency<ToolbarBloc>((_) => ToolbarBloc());
    di.registerDependency<AuthBloc>((_) => AuthBloc(api));
  });

  testWidgets('Tests error dialog pops up on upload error',
      (WidgetTester tester) async {
    when(api.pictogram.create(any))
        .thenAnswer((_) => Observable<PictogramModel>.error(Exception()));

    await tester.pumpWidget(MaterialApp(home: UploadImageFromPhone()));
    await tester.pumpAndSettle();

    // ignore: always_specify_types
    bloc.isInputValid.mergeWith([Observable<bool>.just(true)]);

    await tester.tap(find.byKey(const Key('SavePictogramButtonKey')));
    await tester.pumpAndSettle();
    expect(find.text('Fejl'), findsOneWidget);
  });
}