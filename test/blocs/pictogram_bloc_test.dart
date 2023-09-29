import 'package:api_client/api/api.dart';
import 'package:api_client/api/pictogram_api.dart';
import 'package:api_client/models/enums/access_level_enum.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:async_test/async_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart' as rx_dart;
import 'package:weekplanner/blocs/pictogram_bloc.dart';

class MockPictogramApi extends Mock implements PictogramApi {
  @override
  Stream<PictogramModel> get(int id) async* {
    final PictogramModel mockModel =
        PictogramModel(id: -1, title: 'test1', accessLevel: AccessLevel.PUBLIC);
    yield mockModel;
  }
}

void main() {
  late PictogramBloc bloc;
  late Api api;
  late MockPictogramApi pictogramApi;

  setUp(() {
    api = Api('any');
    pictogramApi = MockPictogramApi();
    api.pictogram = pictogramApi;
    bloc = PictogramBloc(api);
  });

  test('Should be able to search for pictograms', async((DoneFn done) {
    const String query = 'Kat';
    int count = 0;

    when(pictogramApi.getAll(
            page: bloc.latestPage, pageSize: pageSize, query: query))
        .thenAnswer((_) => rx_dart.BehaviorSubject<List<PictogramModel>>.seeded(
            <PictogramModel>[]));

    bloc.pictograms.listen((List<PictogramModel> response) {
      switch (count) {
        case 0:
          expect(response, isNull);
          break;
        case 1:
          verify(pictogramApi.getAll(
              page: bloc.latestPage, pageSize: pageSize, query: query));
          done();
          break;
      }
      count++;
    });

    bloc.search(query);
  }));

  test('Should dispose stream', async((DoneFn done) {
    bloc.pictograms.listen((_) {}, onDone: done);
    bloc.dispose();
  }));
}
