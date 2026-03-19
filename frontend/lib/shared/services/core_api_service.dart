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

  // Organisations
  Future<PaginatedResponse<Organisation>> fetchOrganisations() async {
    final response = await _dio.get('/organisations/');
    return PaginatedResponse.fromJson(
      response.data as Map<String, dynamic>,
      Organisation.fromJson,
    );
  }

  Future<Organisation> fetchOrganisation(int orgId) async {
    final response = await _dio.get('/organisations/$orgId/');
    return Organisation.fromJson(response.data as Map<String, dynamic>);
  }

  // Citizens
  Future<PaginatedResponse<Citizen>> fetchCitizens(int orgId) async {
    final response = await _dio.get('/organisations/$orgId/citizens/');
    return PaginatedResponse.fromJson(
      response.data as Map<String, dynamic>,
      Citizen.fromJson,
    );
  }

  // Grades
  Future<PaginatedResponse<Grade>> fetchGrades(int orgId) async {
    final response = await _dio.get('/organisations/$orgId/grades/');
    return PaginatedResponse.fromJson(
      response.data as Map<String, dynamic>,
      Grade.fromJson,
    );
  }

  // Pictograms
  Future<PaginatedResponse<Pictogram>> searchPictograms({
    String? query,
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await _dio.get('/pictograms/', queryParameters: {
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
    final response = await _dio.get('/pictograms/$id/');
    return Pictogram.fromJson(response.data as Map<String, dynamic>);
  }
}
