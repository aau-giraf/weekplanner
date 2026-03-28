import 'package:fpdart/fpdart.dart';

import 'package:weekplanner/core/errors/activity_failure.dart';
import 'package:weekplanner/shared/models/activity.dart';

/// Contract for activity data operations.
abstract class ActivityRepository {
  Future<Either<ActivityFailure, List<Activity>>> fetchActivities({
    required int id,
    required bool isCitizen,
    required DateTime date,
  });
  Future<Either<ActivityFailure, Activity>> createActivity({
    required int id,
    required bool isCitizen,
    required Map<String, dynamic> data,
  });
  Future<Either<ActivityFailure, Activity>> updateActivity(
    int activityId,
    Map<String, dynamic> data,
  );
  Future<Either<ActivityFailure, Unit>> deleteActivity(int activityId);
  Future<Either<ActivityFailure, Unit>> toggleActivityStatus(
    int activityId, {
    required bool isComplete,
  });
}
