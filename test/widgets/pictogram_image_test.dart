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

    // Finder that gets all widgets that are PictogramImages.
    final Finder f = find.byWidgetPredicate((Widget widget) {
      return widget is PictogramImage;
    });

    // Verify that only one PictogramImage is found.
    // The test fails if there there is not exactly one PictogramImage.
    expect(f, findsOneWidget);

    final Completer<bool> waiter = Completer<bool>();

    // Listen for updates on the image stream.
    // The function inside is called every time bloc.image is updated.
    bloc.image.listen(expectAsync1((Image image) async {
      // Update the frame.
      await tester.pump();

      // Expect that there is one and only one Image widget.
      // The test fails if there is not exactly one Image widget.
      expect(find.byType(Image), findsOneWidget);
      waiter.complete();
    }));

    await waiter.future;
  });

  testWidgets('Widget triggers callback on tap', (WidgetTester tester) async {
    bool onPressedCallbackTriggered = false;

    //sets up the widget.
    await tester.pumpWidget(PictogramImage(
      key: Key('pictogram_image_key'),
      pictogram: pictogramModel,
      onPressed: () {
        onPressedCallbackTriggered = true;
      },
    ));

    // Finder that gets the PictogramImage widget by key.
    final Finder f = find.byKey(Key('pictogram_image_key'));

    // Tap the PictogramImage widget.
    await tester.tap(f);
    await tester.pump();

    // Expect that the onPressed callback was triggered.
    expect(onPressedCallbackTriggered, true);
  });

  testWidgets('shows spinner on loading', (WidgetTester tester) async {
    await tester.pumpWidget(PictogramImage(
      pictogram: pictogramModel,
      onPressed: () {},
    ));

    // Finder that gets all widgets that are CircularProgressIndicators.
    final Finder f = find.byWidgetPredicate((Widget widget) {
      return widget is CircularProgressIndicator;
    });

    // Verify that only one CircularProgressIndicator is found.
    // The test fails if there there is not exactly one
    // CircularProgressIndicator.
    expect(f, findsOneWidget);

    final Completer<bool> waiter = Completer<bool>();

    // Listen for updates on the image stream.
    // The function inside is called every time bloc.image is updated.
    bloc.image.listen(expectAsync1((Image image) async {
      await tester.pump();
      expect(f, findsNothing);
      waiter.complete();
    }));
    await waiter.future;
  });

  testWidgets('shows delete button when haveRights ',
      (WidgetTester tester) async {
    await tester.pumpWidget(PictogramImage(
      pictogram: pictogramModel,
      onPressed: () {},
      haveRights: true,
    ));

    expect(find.byType(GirafButton), findsOneWidget);
  });

  testWidgets('show delete button when comparing ids',
      (WidgetTester tester) async {
    String id;

    final Completer<bool> done = Completer<bool>();

    // Listen for updates on the currently authenticated user.
    // The function inside is called every time the given authenticaded user's
    // Information is changed.
    api.user.me().listen((GirafUserModel model) {
      id = model.id;
      done.complete();
    });

    // Wait for the new user to be authenticated,
    // which is done when the stream is updated.
    await done.future;

    // Create a new PictogramImage where the authenticated user's rights are
    // determined by pictogramModel.userId.
    await tester.pumpWidget(PictogramImage(
      pictogram: pictogramModel,
      onPressed: () {},
      haveRights: pictogramModel.userId == id,
    ));

    // Expect that there is one and only one GirafButton.
    expect(find.byType(GirafButton), findsOneWidget);
  });

  testWidgets('deletebutton is not shown when image is not owned',
      (WidgetTester tester) async {
    await tester.pumpWidget(PictogramImage(
      pictogram: pictogramModel,
      onPressed: () {},
      haveRights: false,
    ));

    // Expect that there is no GirafButton when the user does not have rights.
    expect(find.byType(GirafButton), findsNothing);
  });
}
