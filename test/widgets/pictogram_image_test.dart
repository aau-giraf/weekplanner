// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';

import 'package:api_client/api/api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/models/enums/access_level_enum.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
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
  late PictogramImageBloc bloc;
  late Api api;
  late MockPictogramApi pictogramApi;

  final PictogramModel pictogramModel = PictogramModel(
      id: 1,
      lastEdit: DateTime(2017, 9, 7, 17, 30),
      title: 'Title',
      accessLevel: AccessLevel.PUBLIC,
      imageUrl: 'http://any.tld',
      imageHash: 'null',
      userId: '1');

  setUp(() {
    api = Api('any');
    pictogramApi = MockPictogramApi();
    api.pictogram = pictogramApi;
    api.user = MockUserApi();
    bloc = PictogramImageBloc(api);

    // when(pictogramApi.getImage(pictogramModel.id!))
    //     .thenAnswer((_) => rx_dart.BehaviorSubject<Image>.seeded(sampleImage));

    when(pictogramApi.getImage(pictogramModel.id!) as Function())
        .thenAnswer((_) => (int id) {
              // Return the Stream<Image> based on the provided ID
              if (id == pictogramModel.id) {
                // Return the stream with the sample image
                return Stream<Image>.fromIterable(<Image>[sampleImage]);
              } else {
                // Handle other cases if needed
                throw Exception('Invalid pictogram ID');
              }
            });

    // when(pictogramApi.getImage(pictogramModel.id!)).thenAnswer((_) =>
    //   (int id) {
    //     // Return the Stream<Image> based on the provided ID
    //     if (id == pictogramModel.id) {
    //       // Return the stream with the sample image
    //       return Stream<Image>.fromIterable([sampleImage]);
    //     } else {
    //       // Handle other cases if needed
    //       throw Exception('Invalid pictogram ID');
    //     }
    //   });

    // when(pictogramApi.getImage(pictogramModel.id!)).thenAnswer((_) =>
    //   (int id) {
    //     // Return the Stream<Image> based on the provided ID
    //     if (id == pictogramModel.id) {
    //       // Return the stream with the sample image
    //       return Stream<Image>.fromIterable([sampleImage]);
    //     } else {
    //       // Handle other cases if needed
    //       throw Exception('Invalid pictogram ID');
    //     }
    //   });

    di.clearAll();
    di.registerDependency<PictogramImageBloc>(() => bloc);
  });

  testWidgets('takes PictogramModel and VoidCallback',
      (WidgetTester tester) async {
    await tester.pumpWidget(PictogramImage(
      pictogram: pictogramModel,
      onPressed: () {},
      key: const ValueKey<String>('pictogramModelKey'),
    ));
  });

  testWidgets('loads renders given image', (WidgetTester tester) async {
    await tester.pumpWidget(PictogramImage(
      pictogram: pictogramModel,
      onPressed: () {},
      key: const ValueKey<String>('pictogramModelKey'),
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
      waiter.complete(true);
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
      key: const ValueKey<String>('callbackKey'),
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
      key: const ValueKey<String>('pictogramModelKey'),
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
      waiter.complete(true);
    }));
    await waiter.future;
  });

  testWidgets('shows delete button when haveRights',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SingleChildScrollView(
        child: PictogramImage(
          pictogram: pictogramModel,
          onPressed: () {},
          haveRights: true,
          key: const ValueKey<String>('haveRightsKey'),
        ),
      ),
    ));

    expect(find.byType(GirafButton), findsOneWidget);
  });

  testWidgets('show delete button when comparing ids',
      (WidgetTester tester) async {
    late String id;
    final Completer<bool> done = Completer<bool>();

    // Listen for updates on the currently authenticated user.
    // The function inside is called every time the given authenticaded user's
    // Information is changed.
    api.user.me().listen((GirafUserModel model) {
      id = model.id!;
      done.complete(true);
    });

    // Wait for the new user to be authenticated,
    // which is done when the stream is updated.
    await done.future;
    // Create a new PictogramImage where the authenticated user's rights are
    // determined by pictogramModel.userId.

    await tester.pumpWidget(MaterialApp(
      home: SingleChildScrollView(
        child: PictogramImage(
          pictogram: pictogramModel,
          onPressed: () {},
          haveRights: pictogramModel.userId == id,
          key: const ValueKey<String>('pictogramImageTestKey'),
        ),
      ),
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
      key: const ValueKey<String>('pictogramImageTestBtnKey'),
    ));

    // Expect that there is no GirafButton when the user does not have rights.
    expect(find.byType(GirafButton), findsNothing);
  });
}
