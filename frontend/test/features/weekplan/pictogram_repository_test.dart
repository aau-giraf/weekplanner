import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weekplanner/core/errors/pictogram_failure.dart';
import 'package:weekplanner/features/weekplan/data/repositories/pictogram_repository.dart';
import 'package:weekplanner/features/weekplan/domain/repositories/pictogram_repository.dart';
import 'package:weekplanner/shared/models/paginated_response.dart';
import 'package:weekplanner/shared/models/pictogram.dart';
import 'package:weekplanner/shared/services/pictogram_api_service.dart';

class MockPictogramApiService extends Mock implements PictogramApiService {}

class MockPlatformFile extends Mock implements PlatformFile {}

class FakeMultipartFile extends Fake implements MultipartFile {}

void main() {
  late MockPictogramApiService mockCore;
  late PictogramRepository repo;

  const testPictogram = Pictogram(id: 7, name: 'Bade');

  setUpAll(() {
    registerFallbackValue(FakeMultipartFile());
  });

  setUp(() {
    mockCore = MockPictogramApiService();
    repo = PictogramRepositoryImpl(apiService: mockCore);
  });

  group('searchPictograms', () {
    test('returns Right with list on success', () async {
      when(
        () => mockCore.searchPictograms(
          query: any(named: 'query'),
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        ),
      ).thenAnswer(
        (_) async => const PaginatedResponse(items: [testPictogram], count: 1),
      );

      final result = await repo.searchPictograms('bad');

      expect(result, isA<Right<PictogramFailure, List<Pictogram>>>());
      expect(result.getOrElse((_) => []), [testPictogram]);
      verify(
        () => mockCore.searchPictograms(
          query: 'bad',
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        ),
      ).called(1);
    });

    test('returns Left(SearchPictogramsFailure) on exception', () async {
      when(
        () => mockCore.searchPictograms(
          query: any(named: 'query'),
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        ),
      ).thenThrow(Exception('network error'));

      final result = await repo.searchPictograms('bad');

      expect(result, isA<Left<PictogramFailure, List<Pictogram>>>());
      result.fold(
        (failure) => expect(failure, isA<SearchPictogramsFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  group('fetchPictogram', () {
    test('returns Right with pictogram on success', () async {
      when(() => mockCore.fetchPictogram(7)).thenAnswer(
        (_) async => testPictogram,
      );

      final result = await repo.fetchPictogram(7);

      expect(result, isA<Right<PictogramFailure, Pictogram>>());
      expect(result.getOrElse((_) => const Pictogram(id: -1, name: '')), testPictogram);
      verify(() => mockCore.fetchPictogram(7)).called(1);
    });

    test('returns Left(FetchPictogramFailure) on exception', () async {
      when(() => mockCore.fetchPictogram(7))
          .thenThrow(Exception('not found'));

      final result = await repo.fetchPictogram(7);

      expect(result, isA<Left<PictogramFailure, Pictogram>>());
      result.fold(
        (failure) => expect(failure, isA<FetchPictogramFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  group('createPictogram', () {
    test('returns Right with pictogram on success', () async {
      when(
        () => mockCore.createPictogram(
          name: any(named: 'name'),
          imageUrl: any(named: 'imageUrl'),
          organizationId: any(named: 'organizationId'),
          generateImage: any(named: 'generateImage'),
          generateSound: any(named: 'generateSound'),
        ),
      ).thenAnswer((_) async => testPictogram);

      final result = await repo.createPictogram(name: 'Bade');

      expect(result, isA<Right<PictogramFailure, Pictogram>>());
      expect(result.getOrElse((_) => const Pictogram(id: -1, name: '')), testPictogram);
    });

    test('returns Left(CreatePictogramFailure) on exception', () async {
      when(
        () => mockCore.createPictogram(
          name: any(named: 'name'),
          imageUrl: any(named: 'imageUrl'),
          organizationId: any(named: 'organizationId'),
          generateImage: any(named: 'generateImage'),
          generateSound: any(named: 'generateSound'),
        ),
      ).thenThrow(Exception('server error'));

      final result = await repo.createPictogram(name: 'Bade');

      expect(result, isA<Left<PictogramFailure, Pictogram>>());
      result.fold(
        (failure) => expect(failure, isA<CreatePictogramFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  group('uploadPictogram', () {
    test('returns Right with pictogram on success', () async {
      final mockFile = MockPlatformFile();
      when(() => mockFile.bytes).thenReturn(Uint8List.fromList([1, 2, 3]));
      when(() => mockFile.name).thenReturn('image.png');

      when(
        () => mockCore.uploadPictogram(
          name: any(named: 'name'),
          imageFile: any(named: 'imageFile'),
          soundFile: any(named: 'soundFile'),
          organizationId: any(named: 'organizationId'),
          generateSound: any(named: 'generateSound'),
        ),
      ).thenAnswer((_) async => testPictogram);

      final result = await repo.uploadPictogram(
        name: 'Bade',
        imageFile: mockFile,
      );

      expect(result, isA<Right<PictogramFailure, Pictogram>>());
      expect(result.getOrElse((_) => const Pictogram(id: -1, name: '')), testPictogram);
    });

    test('returns Left(CreatePictogramFailure) on exception', () async {
      final mockFile = MockPlatformFile();
      when(() => mockFile.bytes).thenReturn(Uint8List.fromList([1, 2, 3]));
      when(() => mockFile.name).thenReturn('image.png');

      when(
        () => mockCore.uploadPictogram(
          name: any(named: 'name'),
          imageFile: any(named: 'imageFile'),
          soundFile: any(named: 'soundFile'),
          organizationId: any(named: 'organizationId'),
          generateSound: any(named: 'generateSound'),
        ),
      ).thenThrow(Exception('upload failed'));

      final result = await repo.uploadPictogram(
        name: 'Bade',
        imageFile: mockFile,
      );

      expect(result, isA<Left<PictogramFailure, Pictogram>>());
      result.fold(
        (failure) => expect(failure, isA<CreatePictogramFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns Left when file has neither bytes nor path', () async {
      final mockFile = MockPlatformFile();
      when(() => mockFile.bytes).thenReturn(null);
      when(() => mockFile.path).thenReturn(null);
      when(() => mockFile.name).thenReturn('broken.png');

      final result = await repo.uploadPictogram(
        name: 'Bade',
        imageFile: mockFile,
      );

      expect(result, isA<Left<PictogramFailure, Pictogram>>());
      result.fold(
        (failure) => expect(failure, isA<CreatePictogramFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
