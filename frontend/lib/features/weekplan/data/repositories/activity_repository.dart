import 'package:fpdart/fpdart.dart';
import 'package:logging/logging.dart';

import 'package:weekplanner/core/errors/activity_failure.dart';
import 'package:weekplanner/shared/models/activity.dart';
import 'package:weekplanner/shared/services/activity_api_service.dart';
import 'package:weekplanner/shared/utils/date_utils.dart';

final _log = Logger('ActivityRepository');

/// Pure data layer for activity operations.
///
/// All methods return [Either] to communicate success or typed failure.
/// No state management — that responsibility belongs to [WeekplanCubit].
class ActivityRepository {
  final ActivityApiService _apiService;

  ActivityRepository({required ActivityApiService apiService})
      : _apiService = apiService;

  /// Fetch activities for a citizen or grade on a given date.
  Future<Either<ActivityFailure, List<Activity>>> fetchActivities({
    required int id,
    required bool isCitizen,
    required DateTime date,
  }) async {
    try {
      final dateStr = GirafDateUtils.formatQueryDate(date);
      final activities = isCitizen
          ? await _apiService.fetchActivitiesByCitizen(id, dateStr)
          : await _apiService.fetchActivitiesByGrade(id, dateStr);
      return Right(activities);
    } catch (e, stackTrace) {
      _log.severe('Failed to fetch activities', e, stackTrace);
      return Left(const FetchActivitiesFailure());
    }
  }

  /// Create an activity for a citizen or grade.
  Future<Either<ActivityFailure, Activity>> createActivity({
    required int id,
    required bool isCitizen,
    required Map<String, dynamic> data,
  }) async {
    try {
      final activity = isCitizen
          ? await _apiService.createActivityForCitizen(id, data)
          : await _apiService.createActivityForGrade(id, data);
      return Right(activity);
    } catch (e, stackTrace) {
      _log.severe('Failed to create activity', e, stackTrace);
      return Left(const CreateActivityFailure());
    }
  }

  /// Update an existing activity.
  Future<Either<ActivityFailure, Activity>> updateActivity(
    int activityId,
    Map<String, dynamic> data,
  ) async {
    try {
      final updated = await _apiService.updateActivity(activityId, data);
      return Right(updated);
    } catch (e, stackTrace) {
      _log.severe('Failed to update activity', e, stackTrace);
      return Left(const UpdateActivityFailure());
    }
  }

  /// Delete an activity.
  Future<Either<ActivityFailure, Unit>> deleteActivity(int activityId) async {
    try {
      await _apiService.deleteActivity(activityId);
      return const Right(unit);
    } catch (e, stackTrace) {
      _log.severe('Failed to delete activity', e, stackTrace);
      return Left(const DeleteActivityFailure());
    }
  }

  /// Toggle an activity's completion status.
  Future<Either<ActivityFailure, Unit>> toggleActivityStatus(
    int activityId, {
    required bool isComplete,
  }) async {
    try {
      await _apiService.toggleActivityStatus(activityId,
          isComplete: isComplete);
      return const Right(unit);
    } catch (e, stackTrace) {
      _log.severe('Failed to toggle activity status', e, stackTrace);
      return Left(const ToggleStatusFailure());
    }
  }
}
