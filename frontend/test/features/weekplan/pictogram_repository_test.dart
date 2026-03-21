import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/features/weekplan/data/repositories/pictogram_repository.dart';
import 'package:weekplanner/shared/models/paginated_response.dart';
import 'package:weekplanner/shared/models/pictogram.dart';
import 'package:weekplanner/shared/services/core_api_service.dart';

class FakeCoreApiService extends CoreApiService {
  Future<PaginatedResponse<Pictogram>> Function(String? query)? onSearch;
  Future<Pictogram> Function(int id)? onFetchPictogram;

  @override
  Future<PaginatedResponse<Pictogram>> searchPictograms({
    String? query,
    int limit = 20,
    int offset = 0,
  }) async {
    if (onSearch == null) {
      throw UnimplementedError('onSearch not configured');
    }
    return onSearch!(query);
  }

  @override
  Future<Pictogram> fetchPictogram(int id) async {
    if (onFetchPictogram == null) {
      throw UnimplementedError('onFetchPictogram not configured');
    }
    return onFetchPictogram!(id);
  }
}

void main() {
  late FakeCoreApiService fakeCore;
  late PictogramRepository repo;

  const testPictogram = Pictogram(
    id: 7,
    name: 'Bade',
    imageUrl: '/media/bade.png',
    soundUrl: '/media/bade.mp3',
  );

  setUp(() {
    fakeCore = FakeCoreApiService();
    repo = PictogramRepository(coreApiService: fakeCore);
  });

  group('PictogramRepository', () {
    test('searchPictograms stores results on success', () async {
      fakeCore.onSearch = (_) async => const PaginatedResponse(
            items: [testPictogram],
            count: 1,
          );

      await repo.searchPictograms('bad');

      expect(repo.error, isNull);
      expect(repo.isLoading, isFalse);
      expect(repo.pictograms.length, 1);
      expect(repo.pictograms.first.id, 7);
    });

    test('searchPictograms sets error on failure', () async {
      fakeCore.onSearch = (_) async => throw Exception('network fail');

      await repo.searchPictograms('bad');

      expect(repo.isLoading, isFalse);
      expect(repo.error, isNotNull);
    });

    test('fetchPictogram returns null on failure', () async {
      fakeCore.onFetchPictogram = (_) async => throw Exception('not found');

      final result = await repo.fetchPictogram(123);

      expect(result, isNull);
    });
  });
}
