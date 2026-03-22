import 'package:equatable/equatable.dart';

import 'package:weekplanner/shared/models/activity.dart';

/// Media URLs cached for a pictogram.
typedef PictogramMedia = ({String? imageUrl, String? soundUrl});

/// State managed by [WeekplanCubit].
sealed class WeekplanState extends Equatable {
  /// Currently selected date.
  final DateTime selectedDate;

  /// All dates in the selected week (Monday–Sunday).
  final List<DateTime> weekDates;

  const WeekplanState({
    required this.selectedDate,
    required this.weekDates,
  });
}

/// Activities are being fetched for the current date.
final class WeekplanLoading extends WeekplanState {
  const WeekplanLoading({
    required super.selectedDate,
    required super.weekDates,
  });

  @override
  List<Object?> get props => [selectedDate, weekDates];
}

/// Activities are loaded and ready for display.
final class WeekplanLoaded extends WeekplanState {
  /// Activities for the selected date.
  final List<Activity> activities;

  /// Cached media URLs keyed by pictogram ID.
  final Map<int, PictogramMedia> pictogramMedia;

  const WeekplanLoaded({
    required super.selectedDate,
    required super.weekDates,
    required this.activities,
    this.pictogramMedia = const {},
  });

  @override
  List<Object?> get props =>
      [selectedDate, weekDates, activities, pictogramMedia];
}

/// An error occurred while fetching activities.
final class WeekplanError extends WeekplanState {
  /// Human-readable error message.
  final String message;

  const WeekplanError({
    required this.message,
    required super.selectedDate,
    required super.weekDates,
  });

  @override
  List<Object?> get props => [message, selectedDate, weekDates];
}
