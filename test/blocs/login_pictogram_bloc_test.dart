import 'package:mockito/annotations.dart';
import 'package:rxdart/rxdart.dart' as rx_dart;
import 'package:api_client/api/account_api.dart';
import 'package:api_client/api/api.dart';
import 'package:api_client/api/user_api.dart';
import 'package:api_client/models/enums/role_enum.dart';
import 'package:api_client/models/giraf_user_model.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:async_test/async_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weekplanner/blocs/login_pictogram_bloc.dart';
import 'package:weekplanner/blocs/pictogram_bloc.dart';

import '../mock_data.dart';
void main() {
  MockPictogramApi pictogramApi;
  LoginPictogramBloc bloc;
  Api api;

  setUp(() {
    api = Api('any');
    pictogramApi = MockPictogramApi();

     bloc = LoginPictogramBloc(api);
  });

  test('Test getPictograms adding 1 pictogram from mocked api to stream', async((DoneFn done) {
    const String query = '';
    int count = 0;
    int latestPage = 1;

    when(pictogramApi.getAll(page: latestPage,
        pageSize: pageSize, query: query)).thenAnswer(
            (_) =>
        rx_dart.BehaviorSubject<List<PictogramModel>>
            .seeded(<PictogramModel>[]));

    bloc.pictograms.listen((List<PictogramModel> response) {
      switch (count) {
        case 0:
          expect(response, isNull);
          break;
        case 1:
          verify(pictogramApi.getAll(page: latestPage,
              pageSize: pageSize, query: query));
          done();
          break;
      }
      count++;
    });

    bloc.getPictograms(1);
    }));

  test('Should reset bloc', async((DoneFn done) {
    bloc.pictograms.listen((_) {}, onDone: done);
    bloc.reset();
  }));

  test('Should dispose stream', async((DoneFn done) {
    bloc.pictograms.listen((_) {}, onDone: done);
    bloc.dispose();
  }));


}