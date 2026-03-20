import 'package:dio/dio.dart';
import 'package:weekplanner/config/api_config.dart';
import 'package:weekplanner/shared/models/citizen.dart';
import 'package:weekplanner/shared/models/grade.dart';
import 'package:weekplanner/shared/models/organisation.dart';
import 'package:weekplanner/shared/models/paginated_response.dart';
import 'package:weekplanner/shared/models/pictogram.dart';

class CoreApiService {
  final Dio _dio;

  CoreApiService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: ApiConfig.coreBaseUrl,
              headers: {'Content-Type': 'application/json'},
            ));

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  // Organizations
  Future<PaginatedResponse<Organisation>> fetchOrganisations() async {
    final response = await _dio.get('/api/v1/organizations');
    return PaginatedResponse.fromJson(
      response.data as Map<String, dynamic>,
      Organisation.fromJson,
    );
  }

  Future<Organisation> fetchOrganisation(int orgId) async {
    final response = await _dio.get('/api/v1/organizations/$orgId');
    return Organisation.fromJson(response.data as Map<String, dynamic>);
  }

  // Citizens
  Future<PaginatedResponse<Citizen>> fetchCitizens(int orgId) async {
    final response = await _dio.get('/api/v1/organizations/$orgId/citizens');
    return PaginatedResponse.fromJson(
      response.data as Map<String, dynamic>,
      Citizen.fromJson,
    );
  }

  // Grades
  Future<PaginatedResponse<Grade>> fetchGrades(int orgId) async {
    final response = await _dio.get('/api/v1/organizations/$orgId/grades');
    return PaginatedResponse.fromJson(
      response.data as Map<String, dynamic>,
      Grade.fromJson,
    );
  }

  // Pictograms — Read
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
    return PaginatedResponse.fromJson(
      response.data as Map<String, dynamic>,
      Pictogram.fromJson,
    );
  }

  Future<Pictogram> fetchPictogram(int id) async {
    final response = await _dio.get('/api/v1/pictograms/$id');
    return Pictogram.fromJson(response.data as Map<String, dynamic>);
  }

  // Pictograms — Write
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
    return Pictogram.fromJson(response.data as Map<String, dynamic>);
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
    final response = await _dio.post('/api/v1/pictograms/upload', data: formData);
    return Pictogram.fromJson(response.data as Map<String, dynamic>);
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
    return Pictogram.fromJson(response.data as Map<String, dynamic>);
  }
}
