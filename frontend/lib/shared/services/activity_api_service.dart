import 'package:dio/dio.dart';
import 'package:weekplanner/config/api_config.dart';
import 'package:weekplanner/shared/models/activity.dart';
import 'package:weekplanner/shared/models/paginated_response.dart';

class ActivityApiService {
  final Dio _dio;

  ActivityApiService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: ApiConfig.weekplannerBaseUrl,
              headers: {'Content-Type': 'application/json'},
            ));

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  // Fetch activities for a citizen on a specific date
  Future<PaginatedResponse<Activity>> fetchActivitiesByCitizen(
    int citizenId,
    String date,
  ) async {
    final response = await _dio.get(
      '/citizens/$citizenId/activities/',
      queryParameters: {'date': date},
    );
    return PaginatedResponse.fromJson(
      response.data as Map<String, dynamic>,
      Activity.fromJson,
    );
  }

  // Fetch activities for a grade on a specific date
  Future<PaginatedResponse<Activity>> fetchActivitiesByGrade(
    int gradeId,
    String date,
  ) async {
    final response = await _dio.get(
      '/grades/$gradeId/activities/',
      queryParameters: {'date': date},
    );
    return PaginatedResponse.fromJson(
      response.data as Map<String, dynamic>,
      Activity.fromJson,
    );
  }

  // Get a single activity
  Future<Activity> fetchActivity(int activityId) async {
    final response = await _dio.get('/activities/$activityId/');
    return Activity.fromJson(response.data as Map<String, dynamic>);
  }

  // Create activity for a citizen
  Future<Activity> createActivityForCitizen(
    int citizenId,
    Map<String, dynamic> data,
  ) async {
    final response = await _dio.post(
      '/citizens/$citizenId/activities/',
      data: data,
    );
    return Activity.fromJson(response.data as Map<String, dynamic>);
  }

  // Create activity for a grade
  Future<Activity> createActivityForGrade(
    int gradeId,
    Map<String, dynamic> data,
  ) async {
    final response = await _dio.post(
      '/grades/$gradeId/activities/',
      data: data,
    );
    return Activity.fromJson(response.data as Map<String, dynamic>);
  }

  // Update activity
  Future<Activity> updateActivity(
    int activityId,
    Map<String, dynamic> data,
  ) async {
    final response = await _dio.put('/activities/$activityId/', data: data);
    return Activity.fromJson(response.data as Map<String, dynamic>);
  }

  // Delete activity
  Future<void> deleteActivity(int activityId) async {
    await _dio.delete('/activities/$activityId/');
  }

  // Toggle activity completion status
  Future<Activity> toggleActivityStatus(int activityId) async {
    final response = await _dio.patch('/activities/$activityId/toggle/');
    return Activity.fromJson(response.data as Map<String, dynamic>);
  }
}
