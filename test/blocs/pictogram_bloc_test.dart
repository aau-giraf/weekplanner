import 'package:api_client/api/api.dart';
import 'package:api_client/api/pictogram_api.dart';
import 'package:api_client/models/enums/access_level_enum.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:async_test/async_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
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
  Api api = Api('baseUrl');
  PictogramBloc bloc = PictogramBloc(api);
  MockPictogramApi pictogramApi = MockPictogramApi();

  setUp(() {
    api = Api('any');
    pictogramApi = MockPictogramApi();
    api.pictogram = pictogramApi;
    bloc = PictogramBloc(api);
  });

  test('Should be able to search for pictograms', async((DoneFn done) {
    const String query = 'Kat';
    int count = 0;

    // Make a mock call to the api.
    // It deposes the result and returns with an empty, seeded list.
    when(pictogramApi.getAll(

            page: bloc.latestPage, pageSize: pageSize, query: query))
        .thenAnswer((_) => rx_dart.BehaviorSubject<List<PictogramModel>>.seeded(
            <PictogramModel>[]));

    // Validate behaviour of the stream. bloc.search adds two objects to
    // bloc.pictograms: one null and one placeholder PictogramModel.
    // The listener below is called every time bloc.pictograms is updated.
    bloc.pictograms.listen((List<PictogramModel> response) {

      switch (count) {
        case 0:
          // If the stream is empty, ie. no results,
          // the response should be null, since bloc.search adds a null object
          // to the stream first. Otherwise, the test fails.
          expect(response, isNull);
          done();
          break;
        case 1:
          // If the stream is not empty, the 'getAll' method must have been run.
          // 'verify' makes the test fail if 'getAll' was not called.
          verify(pictogramApi.getAll(

              page: bloc.latestPage, pageSize: pageSize, query: query));
          done();
          break;
      }

      count++;
    });

    bloc.search(query);
  }));
  /*Closes streams for the pictogram bloc
  test does not return anything on its own (see lack of expect function)
  but the dispose function should throw an error if something goes wrong within
  itself. It may however still be relevant to keep this test as it ensures the
  streams are actually closed at the end of the test file.
  */
  test('Should dispose stream', async((DoneFn done) {
    bloc.pictograms.listen((_) {}, onDone: done);
    bloc.dispose();
  }));
}
