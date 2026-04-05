import 'package:fpdart/fpdart.dart';
import 'package:logging/logging.dart';

import 'package:weekplanner/core/errors/activity_failure.dart';
import 'package:weekplanner/core/logging.dart';
import 'package:weekplanner/features/weekplan/domain/repositories/activity_repository.dart';
import 'package:weekplanner/shared/models/activity.dart';
import 'package:weekplanner/shared/services/activity_api_service.dart';
import 'package:weekplanner/shared/utils/date_utils.dart';

final _log = Logger('ActivityRepository');

/// Pure data layer for activity operations.
///
/// All methods return [Either] to communicate success or typed failure.
/// No state management — that responsibility belongs to [WeekplanCubit].
class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityApiService _apiService;

  ActivityRepositoryImpl({required ActivityApiService apiService})
      : _apiService = apiService;

  @override
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
      logServerError(_log,'Failed to fetch activities', e, stackTrace);
      return Left(const FetchActivitiesFailure());
    }
  }

  @override
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
      logServerError(_log,'Failed to create activity', e, stackTrace);
      return Left(const CreateActivityFailure());
    }
  }

  @override
  Future<Either<ActivityFailure, List<Activity>>> batchCreateActivities({
    required int id,
    required bool isCitizen,
    required Map<String, dynamic> data,
  }) async {
    try {
      final activities = isCitizen
          ? await _apiService.batchCreateForCitizen(id, data)
          : await _apiService.batchCreateForGrade(id, data);
      return Right(activities);
    } catch (e, stackTrace) {
      logServerError(_log, 'Failed to batch-create activities', e, stackTrace);
      return Left(const CreateActivityFailure());
    }
  }

  @override
  Future<Either<ActivityFailure, Activity>> updateActivity(
    int activityId,
    Map<String, dynamic> data,
  ) async {
    try {
      final updated = await _apiService.updateActivity(activityId, data);
      return Right(updated);
    } catch (e, stackTrace) {
      logServerError(_log,'Failed to update activity', e, stackTrace);
      return Left(const UpdateActivityFailure());
    }
  }

  @override
  Future<Either<ActivityFailure, Unit>> deleteActivity(int activityId) async {
    try {
      await _apiService.deleteActivity(activityId);
      return const Right(unit);
    } catch (e, stackTrace) {
      logServerError(_log,'Failed to delete activity', e, stackTrace);
      return Left(const DeleteActivityFailure());
    }
  }

  @override
  Future<Either<ActivityFailure, Unit>> toggleActivityStatus(
    int activityId, {
    required bool isComplete,
  }) async {
    try {
      await _apiService.toggleActivityStatus(activityId,
          isComplete: isComplete);
      return const Right(unit);
    } catch (e, stackTrace) {
      logServerError(_log,'Failed to toggle activity status', e, stackTrace);
      return Left(const ToggleStatusFailure());
    }
  }

  @override
  Future<Either<ActivityFailure, Unit>> reorderActivities({
    required int id,
    required bool isCitizen,
    required List<Activity> activities,
  }) async {
    try {
      final items = activities
          .asMap()
          .entries
          .map((e) => {
                'activityId': e.value.activityId,
                'sortOrder': e.key,
              })
          .toList();
      await _apiService.reorderActivities(
        id: id,
        isCitizen: isCitizen,
        items: items,
      );
      return const Right(unit);
    } catch (e, stackTrace) {
      logServerError(_log,'Failed to reorder activities', e, stackTrace);
      return Left(const ReorderActivitiesFailure());
    }
  }

  @override
  Future<Either<ActivityFailure, Unit>> copyActivities({
    required int id,
    required bool isCitizen,
    required DateTime sourceDate,
    required DateTime targetDate,
    required List<int> activityIds,
  }) async {
    try {
      await _apiService.copyActivities(
        id: id,
        isCitizen: isCitizen,
        sourceDate: GirafDateUtils.formatQueryDate(sourceDate),
        targetDate: GirafDateUtils.formatQueryDate(targetDate),
        activityIds: activityIds,
      );
      return const Right(unit);
    } catch (e, stackTrace) {
      logServerError(_log, 'Failed to copy activities', e, stackTrace);
      return Left(const CopyActivitiesFailure());
    }
  }
}
