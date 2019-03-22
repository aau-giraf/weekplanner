import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:weekplanner/di.dart';
import 'package:weekplanner/models/pictogram_model.dart';
import 'package:weekplanner/providers/api/api.dart';
import 'package:weekplanner/widgets/pictogram_image.dart';

import '../blocs/pictogram_bloc_test.dart';
import '../test_image.dart';


void main() {
  PictogramImageBloc bloc;
  Api api;
  MockPictogramApi pictogramApi;

  PictogramModel pictogramModel = PictogramModel(
      id: 1,
      lastEdit: null,
      title: null,
      accessLevel: null,
      imageUrl: "http://any.tld",
      imageHash: null);

  setUp(() {
    api = Api("any");
    pictogramApi = MockPictogramApi();
    api.pictogram = pictogramApi;
    bloc = PictogramImageBloc(api);

    when(pictogramApi.getImage(pictogramModel.id))
        .thenAnswer((_) => BehaviorSubject.seeded(sampleImage));

    di.clearAll();
    di.registerDependency<PictogramImageBloc>((_) => bloc);
  });

  testWidgets('takes PictogramModel and VoidCallback',
      (WidgetTester tester) async {
    await tester.pumpWidget(PictogramImage(
      pictogram: pictogramModel,
      onPressed: () {},
    ));
  });

  testWidgets("loads renders given image", (WidgetTester tester) async {
    await tester.pumpWidget(PictogramImage(
      pictogram: pictogramModel,
      onPressed: () {},
    ));

    Finder f = find.byWidgetPredicate((Widget widget) {
      return widget is Image;
    });

    expect(f, findsNothing);

    bloc.image.listen(expectAsync1((Image image) async {
      await tester.pump();
      expect(f, findsOneWidget);
    }));
  });

  testWidgets("triggers callback on tap", (WidgetTester tester) async {
    final Completer<bool> done = Completer<bool>();

    await tester.pumpWidget(PictogramImage(
      pictogram: pictogramModel,
      onPressed: () {
        done.complete(true);
      },
    ));

    Finder f = find.byWidgetPredicate((Widget widget) {
      return widget is Card;
    });

    bloc.image.listen(expectAsync1((Image image) async {
      await tester.pump();
      await tester.tap(f);
    }));

    await done.future;
  });

  testWidgets("shows spinner on loading", (WidgetTester tester) async {
    await tester.pumpWidget(PictogramImage(
      pictogram: pictogramModel,
      onPressed: () {},
    ));

    Finder f = find.byWidgetPredicate((Widget widget) {
      return widget is CircularProgressIndicator;
    });

    expect(f, findsOneWidget);

    bloc.image.listen(expectAsync1((Image image) async {
      await tester.pump();
      expect(f, findsNothing);
    }));
  });
}
