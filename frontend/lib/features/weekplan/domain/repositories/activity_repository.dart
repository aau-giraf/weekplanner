import 'package:fpdart/fpdart.dart';

import 'package:weekplanner/core/errors/activity_failure.dart';
import 'package:weekplanner/shared/models/activity.dart';

/// Contract for activity data operations.
abstract interface class ActivityRepository {
  /// Fetch activities for a citizen or grade on a given date.
  Future<Either<ActivityFailure, List<Activity>>> fetchActivities({
    required int id,
    required bool isCitizen,
    required DateTime date,
  });

  /// Create an activity for a citizen or grade.
  Future<Either<ActivityFailure, Activity>> createActivity({
    required int id,
    required bool isCitizen,
    required Map<String, dynamic> data,
  });

  /// Update an existing activity.
  Future<Either<ActivityFailure, Activity>> updateActivity(
    int activityId,
    Map<String, dynamic> data,
  );

  /// Delete an activity.
  Future<Either<ActivityFailure, Unit>> deleteActivity(int activityId);

  /// Toggle an activity's completion status.
  Future<Either<ActivityFailure, Unit>> toggleActivityStatus(
    int activityId, {
    required bool isComplete,
  });
}
