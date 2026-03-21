import 'package:dio/dio.dart';
import 'package:weekplanner/config/api_config.dart';
import 'package:weekplanner/shared/models/activity.dart';

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
  Future<List<Activity>> fetchActivitiesByCitizen(
    int citizenId,
    String date,
  ) async {
    final response = await _dio.get(
      '/weekplan/$citizenId',
      queryParameters: {'date': date},
    );
    final data = response.data;
    if (data is! List) return [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(Activity.fromJson)
        .toList();
  }

  // Fetch activities for a grade on a specific date
  Future<List<Activity>> fetchActivitiesByGrade(
    int gradeId,
    String date,
  ) async {
    final response = await _dio.get(
      '/weekplan/grade/$gradeId',
      queryParameters: {'date': date},
    );
    final data = response.data;
    if (data is! List) return [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(Activity.fromJson)
        .toList();
  }

  // Get a single activity
  Future<Activity> fetchActivity(int activityId) async {
    final response = await _dio.get('/weekplan/activity/$activityId');
    return Activity.fromJson(response.data! as Map<String, dynamic>);
  }

  Future<Activity> createActivityForCitizen(
    int citizenId,
    Map<String, dynamic> data,
  ) async {
    final response = await _dio.post(
      '/weekplan/to-citizen/$citizenId',
      data: data,
    );
    return Activity.fromJson(response.data! as Map<String, dynamic>);
  }

  Future<Activity> createActivityForGrade(
    int gradeId,
    Map<String, dynamic> data,
  ) async {
    final response = await _dio.post(
      '/weekplan/to-grade/$gradeId',
      data: data,
    );
    return Activity.fromJson(response.data! as Map<String, dynamic>);
  }

  Future<Activity> updateActivity(
    int activityId,
    Map<String, dynamic> data,
  ) async {
    final response = await _dio.put('/weekplan/activity/$activityId', data: data);
    return Activity.fromJson(response.data! as Map<String, dynamic>);
  }

  // Delete activity
  Future<void> deleteActivity(int activityId) async {
    await _dio.delete('/weekplan/activity/$activityId');
  }

  // Toggle activity completion status
  Future<void> toggleActivityStatus(int activityId, {required bool isComplete}) async {
    await _dio.put(
      '/weekplan/activity/$activityId/iscomplete',
      queryParameters: {'IsComplete': isComplete},
    );
  }
}
