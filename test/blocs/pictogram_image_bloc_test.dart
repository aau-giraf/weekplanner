import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/blocs/pictogram_image_bloc.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:mockito/mockito.dart';
import 'package:api_client/api/api.dart';
import 'package:api_client/api/pictogram_api.dart';
import 'package:async_test/async_test.dart';

import '../test_image.dart';

class MockPictogramApi extends Mock implements PictogramApi {}

void main() {
  PictogramImageBloc bloc;
  Api api;
  MockPictogramApi pictogramApi;

  setUp(() {
    api = Api('any');
    pictogramApi = MockPictogramApi();
    api.pictogram = pictogramApi;
    bloc = PictogramImageBloc(api);
  });

  test('Should be able load pictogram', async((DoneFn done) {
    final PictogramModel model = PictogramModel(
        id: 1,
        lastEdit: null,
        title: null,
        accessLevel: null,
        imageUrl: null,
        imageHash: null);

    when(pictogramApi.getImage(model.id))
        .thenAnswer((_) => BehaviorSubject<Image>.seeded(sampleImage));

    bloc.image.listen((Image response) {
      expect(response, isNotNull);
      expect(response, equals(sampleImage));
      done();
    });

    bloc.load(model);
  }));

  test('Should dispose stream', async((DoneFn done) {
    bloc.image.listen((_) {}, onDone: done);
    bloc.dispose();
  }));
}
