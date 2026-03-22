/// Typed failures for activity operations.
sealed class ActivityFailure {
  /// Human-readable error message.
  final String message;

  const ActivityFailure(this.message);
}

/// Failed to fetch activities.
final class FetchActivitiesFailure extends ActivityFailure {
  const FetchActivitiesFailure()
      : super('Kunne ikke hente aktiviteter');
}

/// Failed to create an activity.
final class CreateActivityFailure extends ActivityFailure {
  const CreateActivityFailure()
      : super('Kunne ikke oprette aktivitet');
}

/// Failed to update an activity.
final class UpdateActivityFailure extends ActivityFailure {
  const UpdateActivityFailure()
      : super('Kunne ikke opdatere aktivitet');
}

/// Failed to delete an activity.
final class DeleteActivityFailure extends ActivityFailure {
  const DeleteActivityFailure()
      : super('Kunne ikke slette aktivitet');
}

/// Failed to toggle activity completion status.
final class ToggleStatusFailure extends ActivityFailure {
  const ToggleStatusFailure()
      : super('Kunne ikke ændre status');
}
