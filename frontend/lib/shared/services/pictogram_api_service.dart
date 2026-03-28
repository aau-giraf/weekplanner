import 'package:dio/dio.dart';

import 'package:weekplanner/config/api_config.dart';
import 'package:weekplanner/shared/models/paginated_response.dart';
import 'package:weekplanner/shared/models/pictogram.dart';
import 'package:weekplanner/shared/services/token_consumer.dart';

class PictogramApiService implements TokenConsumer {
  final Dio _dio;

  PictogramApiService({required Dio dio}) : _dio = dio;

  @override
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  @override
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  Future<PaginatedResponse<Pictogram>> searchPictograms({
    String? query,
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await _dio.get('/api/v1/pictograms', queryParameters: {
      if (query != null && query.isNotEmpty) 'search': query,
      'limit': limit,
      'offset': offset,
    });
    final page = PaginatedResponse.fromJson(
      response.data as Map<String, dynamic>,
      Pictogram.fromJson,
    );
    return PaginatedResponse(
      items: page.items.map(_resolvePictogramUrls).toList(),
      count: page.count,
    );
  }

  Future<Pictogram> fetchPictogram(int id) async {
    final response = await _dio.get('/api/v1/pictograms/$id');
    return _resolvePictogramUrls(
      Pictogram.fromJson(response.data as Map<String, dynamic>),
    );
  }

  Future<Pictogram> createPictogram({
    required String name,
    String? imageUrl,
    int? organizationId,
    bool generateImage = false,
    bool generateSound = true,
  }) async {
    final response = await _dio.post('/api/v1/pictograms', data: {
      'name': name,
      if (imageUrl != null) 'image_url': imageUrl,
      if (organizationId != null) 'organization_id': organizationId,
      'generate_image': generateImage,
      'generate_sound': generateSound,
    });
    return _resolvePictogramUrls(
      Pictogram.fromJson(response.data as Map<String, dynamic>),
    );
  }

  Future<Pictogram> uploadPictogram({
    required String name,
    required MultipartFile imageFile,
    MultipartFile? soundFile,
    int? organizationId,
    bool generateSound = true,
  }) async {
    final formData = FormData.fromMap({
      'name': name,
      'image': imageFile,
      if (soundFile != null) 'sound': soundFile,
      if (organizationId != null) 'organization_id': organizationId,
      'generate_sound': generateSound,
    });
    final response =
        await _dio.post('/api/v1/pictograms/upload', data: formData);
    return _resolvePictogramUrls(
      Pictogram.fromJson(response.data as Map<String, dynamic>),
    );
  }

  Future<Pictogram> uploadPictogramSound({
    required int pictogramId,
    required MultipartFile soundFile,
  }) async {
    final formData = FormData.fromMap({'sound': soundFile});
    final response = await _dio.post(
      '/api/v1/pictograms/$pictogramId/sound',
      data: formData,
    );
    return _resolvePictogramUrls(
      Pictogram.fromJson(response.data as Map<String, dynamic>),
    );
  }

  /// Resolve media URLs on a [Pictogram] to absolute URLs.
  ///
  /// giraf-core may return:
  /// - A relative path (`/media/pictograms/...`) for uploaded/generated files.
  /// - An absolute URL (`https://...`) for externally-provided images.
  /// - An empty string when no media is present (e.g. no sound).
  Pictogram _resolvePictogramUrls(Pictogram p) => p.copyWith(
        imageUrl: _resolveMediaUrl(p.imageUrl),
        soundUrl: _resolveMediaUrl(p.soundUrl),
      );

  String? _resolveMediaUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    final parsed = Uri.tryParse(url);
    if (parsed != null && parsed.hasScheme) return url;
    return '${ApiConfig.coreBaseUrl}$url';
  }
}
