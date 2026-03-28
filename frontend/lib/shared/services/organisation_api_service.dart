import 'package:dio/dio.dart';

import 'package:weekplanner/shared/models/citizen.dart';
import 'package:weekplanner/shared/models/grade.dart';
import 'package:weekplanner/shared/models/organisation.dart';
import 'package:weekplanner/shared/models/paginated_response.dart';
import 'package:weekplanner/shared/services/token_consumer.dart';

class OrganisationApiService implements TokenConsumer {
  final Dio _dio;

  OrganisationApiService({required Dio dio}) : _dio = dio;

  @override
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  @override
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

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

  Future<PaginatedResponse<Citizen>> fetchCitizens(int orgId) async {
    final response = await _dio.get('/api/v1/organizations/$orgId/citizens');
    return PaginatedResponse.fromJson(
      response.data as Map<String, dynamic>,
      Citizen.fromJson,
    );
  }

  Future<PaginatedResponse<Grade>> fetchGrades(int orgId) async {
    final response = await _dio.get('/api/v1/organizations/$orgId/grades');
    return PaginatedResponse.fromJson(
      response.data as Map<String, dynamic>,
      Grade.fromJson,
    );
  }
}
