import 'package:test_api/test_api.dart';
import 'package:weekplanner/models/enums/access_level_enum.dart';
import 'package:weekplanner/models/pictogram_model.dart';
import 'package:weekplanner/providers/api/pictogram_api.dart';
import 'package:weekplanner/providers/http/http_mock.dart';

void main() {
  PictogramApi pictogramApi;
  HttpMock httpMock;

  final List<PictogramModel> grams = <PictogramModel>[
    PictogramModel(
        id: 1,
        title: 'Cat#1',
        accessLevel: AccessLevel.PUBLIC,
        imageHash: '#',
        imageUrl: 'http://any',
        lastEdit: DateTime.now()),
    PictogramModel(
        id: 2,
        title: 'Cat#2',
        accessLevel: AccessLevel.PRIVATE,
        imageHash: '#',
        imageUrl: 'http://any',
        lastEdit: DateTime.now()),
  ];

  setUp(() {
    httpMock = HttpMock();
    pictogramApi = PictogramApi(httpMock);
  });

  test('Should be able to search pictograms', () {
    pictogramApi
        .getAll(query: 'Cat', page: 0, pageSize: 10)
        .listen(expectAsync1((List<PictogramModel> pictograms) {
      expect(pictograms.map((PictogramModel gram) => gram.toJson()),
          grams.map((PictogramModel gram) => gram.toJson()));
    }));

    httpMock
        .expectOne(
            url: '?query=Cat&page=0&pageSize=10', method: Method.get)
        .flush(<String, dynamic>{
      'data': grams.map((PictogramModel gram) => gram.toJson()).toList(),
      'success': true,
      'errorProperties': <dynamic>[],
      'errorKey': 'NoError',
    });
  });

  test('Get Pictogram with specific ID', () {
    pictogramApi.get(grams[0].id).listen(expectAsync1((PictogramModel model) {
      expect(model.toJson(), grams[0].toJson());
    }));

    httpMock
        .expectOne(url: '/${grams[0].id}', method: Method.get)
        .flush(<String, dynamic>{
      'data': grams[0].toJson(),
      'success': true,
      'errorProperties': <dynamic>[],
      'errorKey': 'NoError',
    });
  });

  test('Create pictogram', () {
    pictogramApi.create(grams[0]).listen(expectAsync1((PictogramModel model) {
      expect(model.toJson(), grams[0].toJson());
    }));

    httpMock.expectOne(url: '/', method: Method.post).flush(<String, dynamic>{
      'data': grams[0].toJson(),
      'success': true,
      'errorProperties': <dynamic>[],
      'errorKey': 'NoError',
    });
  });

  test('Update pictogram', () {
    pictogramApi.update(grams[0]).listen(expectAsync1((PictogramModel model) {
      expect(model.toJson(), grams[0].toJson());
    }));

    httpMock
        .expectOne(url: '/${grams[0].id}', method: Method.put)
        .flush(<String, dynamic>{
      'data': grams[0].toJson(),
      'success': true,
      'errorProperties': <dynamic>[],
      'errorKey': 'NoError',
    });
  });

  test('Delete pictogram', () {
    pictogramApi.delete(grams[0].id).listen(expectAsync1((bool success) {
      expect(success, isTrue);
    }));

    httpMock
        .expectOne(url: '/${grams[0].id}', method: Method.delete)
        .flush(<String, dynamic>{
      'success': true,
      'errorProperties': <dynamic>[],
      'errorKey': 'NoError',
    });
  });

  tearDown(() {
    httpMock.verify();
  });
}
