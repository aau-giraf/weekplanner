import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:weekplanner/shared/models/activity.dart';
import 'package:weekplanner/shared/services/activity_api_service.dart';
import 'package:weekplanner/shared/utils/date_utils.dart';

final _log = Logger('ActivityRepository');

class ActivityRepository extends ChangeNotifier {
  final ActivityApiService _apiService;

  ActivityRepository({required ActivityApiService apiService})
      : _apiService = apiService;

  List<Activity> _activities = [];
  bool _isLoading = false;
  String? _error;

  List<Activity> get activities => _activities;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchActivities({
    required int id,
    required bool isCitizen,
    required DateTime date,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final dateStr = GirafDateUtils.formatQueryDate(date);
      final response = isCitizen
          ? await _apiService.fetchActivitiesByCitizen(id, dateStr)
          : await _apiService.fetchActivitiesByGrade(id, dateStr);
      _activities = response;
    } catch (e, stackTrace) {
      _log.severe('Failed to fetch activities', e, stackTrace);
      _error = 'Kunne ikke hente aktiviteter';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createActivity({
    required int id,
    required bool isCitizen,
    required Map<String, dynamic> data,
  }) async {
    try {
      final activity = isCitizen
          ? await _apiService.createActivityForCitizen(id, data)
          : await _apiService.createActivityForGrade(id, data);
      _activities = [..._activities, activity];
      notifyListeners();
    } catch (e, stackTrace) {
      _log.severe('Failed to create activity', e, stackTrace);
      _error = 'Kunne ikke oprette aktivitet';
      notifyListeners();
    }
  }

  Future<void> updateActivity(int activityId, Map<String, dynamic> data) async {
    try {
      final updated = await _apiService.updateActivity(activityId, data);
      _activities = _activities.map((a) {
        return a.activityId == activityId ? updated : a;
      }).toList();
      notifyListeners();
    } catch (e, stackTrace) {
      _log.severe('Failed to update activity', e, stackTrace);
      _error = 'Kunne ikke opdatere aktivitet';
      notifyListeners();
    }
  }

  Future<void> deleteActivity(int activityId) async {
    final backup = List<Activity>.from(_activities);
    // Optimistic delete
    _activities = _activities.where((a) => a.activityId != activityId).toList();
    notifyListeners();

    try {
      await _apiService.deleteActivity(activityId);
    } catch (e, stackTrace) {
      _log.severe('Failed to delete activity', e, stackTrace);
      _activities = backup;
      _error = 'Kunne ikke slette aktivitet';
      notifyListeners();
    }
  }

  Future<void> toggleActivityStatus(int activityId) async {
    try {
      final index = _activities.indexWhere((a) => a.activityId == activityId);
      if (index == -1) {
        _log.warning('toggleActivityStatus called for unknown activity $activityId');
        return;
      }
      final newValue = !_activities[index].isCompleted;

      // Optimistic toggle
      _activities = _activities.map((a) {
        if (a.activityId == activityId) {
          return a.copyWith(isCompleted: newValue);
        }
        return a;
      }).toList();
      notifyListeners();

      await _apiService.toggleActivityStatus(activityId, isComplete: newValue);
    } catch (e, stackTrace) {
      _log.severe('Failed to toggle activity status', e, stackTrace);
      // Rollback
      _activities = _activities.map((a) {
        if (a.activityId == activityId) {
          return a.copyWith(isCompleted: !a.isCompleted);
        }
        return a;
      }).toList();
      _error = 'Kunne ikke ændre status';
      notifyListeners();
    }
  }
}
