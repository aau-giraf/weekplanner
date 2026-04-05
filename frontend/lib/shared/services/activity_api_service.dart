import 'package:dio/dio.dart';
import 'package:weekplanner/shared/models/activity.dart';
import 'package:weekplanner/shared/services/token_consumer.dart';

class ActivityApiService implements TokenConsumer {
  final Dio _dio;

  ActivityApiService({required Dio dio}) : _dio = dio;

  @override
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  @override
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

  // Batch-create activities on multiple dates
  Future<List<Activity>> batchCreateForCitizen(
    int citizenId,
    Map<String, dynamic> data,
  ) async {
    final response = await _dio.post(
      '/weekplan/batch/to-citizen/$citizenId',
      data: data,
    );
    final list = response.data as List;
    return list
        .whereType<Map<String, dynamic>>()
        .map(Activity.fromJson)
        .toList();
  }

  Future<List<Activity>> batchCreateForGrade(
    int gradeId,
    Map<String, dynamic> data,
  ) async {
    final response = await _dio.post(
      '/weekplan/batch/to-grade/$gradeId',
      data: data,
    );
    final list = response.data as List;
    return list
        .whereType<Map<String, dynamic>>()
        .map(Activity.fromJson)
        .toList();
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

  // Reorder activities for a citizen or grade
  Future<void> reorderActivities({
    required int id,
    required bool isCitizen,
    required List<Map<String, dynamic>> items,
  }) async {
    final path = isCitizen
        ? '/weekplan/reorder/$id'
        : '/weekplan/reorder/grade/$id';
    await _dio.put(path, data: items);
  }

  // Copy activities to a different date
  Future<void> copyActivities({
    required int id,
    required bool isCitizen,
    required String sourceDate,
    required String targetDate,
    required List<int> activityIds,
  }) async {
    final path = isCitizen
        ? '/weekplan/activity/copy-citizen/$id'
        : '/weekplan/activity/copy-grade/$id';
    await _dio.post(
      path,
      queryParameters: {
        'sourceDate': sourceDate,
        'targetDate': targetDate,
      },
      data: activityIds,
    );
  }

  // Toggle activity completion status
  Future<void> toggleActivityStatus(int activityId, {required bool isComplete}) async {
    await _dio.put(
      '/weekplan/activity/$activityId/iscomplete',
      queryParameters: {'IsComplete': isComplete},
    );
  }
}
