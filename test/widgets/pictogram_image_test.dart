import 'dart:async';

import 'package:api_client/api/api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart' as rx_dart;
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/widgets/giraf_button_widget.dart';
import 'package:weekplanner/widgets/pictogram_image.dart';

import '../blocs/pictogram_bloc_test.dart';
import '../test_image.dart';

class MockUserApi extends Mock implements UserApi {
  @override
  Stream<GirafUserModel> me() {
    return Stream<GirafUserModel>.value(
        GirafUserModel(id: '1', username: 'test', role: Role.Guardian));
  }
}
void main() {
  PictogramImageBloc bloc;
  Api api;
  MockPictogramApi pictogramApi;

  final PictogramModel pictogramModel = PictogramModel(
      id: 1,
      lastEdit: null,
      title: null,
      accessLevel: null,
      imageUrl: 'http://any.tld',
      imageHash: null,
      userId: '1');

  setUp(() {
    api = Api('any');
    pictogramApi = MockPictogramApi();
    api.pictogram = pictogramApi;
    api.user = MockUserApi();
    bloc = PictogramImageBloc(api);

    when(pictogramApi.getImage(pictogramModel.id))
        .thenAnswer((_) => rx_dart.BehaviorSubject<Image>.seeded(sampleImage));

    di.clearAll();
    di.registerDependency<PictogramImageBloc>(() => bloc);
  });

  testWidgets('takes PictogramModel and VoidCallback',
          (WidgetTester tester) async {
        await tester.pumpWidget(PictogramImage(
          pictogram: pictogramModel,
          onPressed: () {},
        ));
      });

  testWidgets('loads renders given image', (WidgetTester tester) async {
    await tester.pumpWidget(PictogramImage(
      pictogram: pictogramModel,
      onPressed: () {},
    ));

    final Finder f = find.byWidgetPredicate((Widget widget) {
      return widget is PictogramImage;
    });

    expect(f, findsOneWidget);

    final Completer<bool> waiter = Completer<bool>();
    bloc.image.listen(expectAsync1((Image image) async {
      await tester.pump();
      expect(find.byType(Image), findsOneWidget);
      waiter.complete();
    }));
    await waiter.future;
  });

  testWidgets('triggers callback on tap', (WidgetTester tester) async {
    final Completer<bool> done = Completer<bool>();

     await tester.pumpWidget(PictogramImage(
      pictogram: pictogramModel,
      onPressed: () {
        done.complete(true);
      },
    ));

    final Finder f = find.byWidgetPredicate((Widget widget) {
      return widget is StreamBuilder;
    });

    bloc.image.listen(expectAsync1((Image image) async {
      await tester.pump();
      await tester.tap(f);
    }));
    await done.future;
  });

  testWidgets('shows spinner on loading', (WidgetTester tester) async {
    await tester.pumpWidget(PictogramImage(
      pictogram: pictogramModel,
      onPressed: () {},
    ));

    final Finder f = find.byWidgetPredicate((Widget widget) {
      return widget is CircularProgressIndicator;
    });

    expect(f, findsOneWidget);

    final Completer<bool> waiter = Completer<bool>();
    bloc.image.listen(expectAsync1((Image image) async {
      await tester.pump();
      expect(f, findsNothing);
      waiter.complete();
    }));
    await waiter.future;
  });

  testWidgets('shows delete button when haveRights ', (WidgetTester tester)
  async{
    await tester.pumpWidget(PictogramImage(
      pictogram: pictogramModel,
      onPressed: () {  },
      haveRights: true,
    ));
    expect(find.byType(GirafButton),findsOneWidget);

  });

  testWidgets('show delete button when comparing ids', (WidgetTester tester)
  async {
    String id;
    final Completer<bool> done = Completer<bool>();
    api.user.me().listen((GirafUserModel model) {
      id = model.id;
      done.complete();
    });

    await done.future;
    await tester.pumpWidget(PictogramImage(
      pictogram: pictogramModel,
      onPressed: () {  },
      haveRights: pictogramModel.userId == id,
    ));
    expect(find.byType(GirafButton),findsOneWidget);

  });

  testWidgets('deletebutton is not shown when image is not owned',
          (WidgetTester tester) async {
    await tester.pumpWidget(PictogramImage(
      pictogram: pictogramModel,
      onPressed: () {  },
      haveRights: false,
    ));
    expect(find.byType(GirafButton),findsNothing);
  });


}
