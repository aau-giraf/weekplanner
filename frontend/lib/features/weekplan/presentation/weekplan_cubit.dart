import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logging/logging.dart';

import 'package:weekplanner/features/weekplan/domain/repositories/activity_repository.dart';
import 'package:weekplanner/features/weekplan/domain/repositories/pictogram_repository.dart';
import 'package:weekplanner/features/weekplan/domain/weekplan_state.dart';
import 'package:weekplanner/shared/models/activity.dart';
import 'package:weekplanner/shared/utils/date_utils.dart';

final _log = Logger('WeekplanCubit');

/// Manages state for the weekplan screen.
///
/// Handles activity loading, week navigation, pictogram media caching,
/// and optimistic activity mutations (delete, toggle status).
class WeekplanCubit extends Cubit<WeekplanState> {
  final ActivityRepository _activityRepository;
  final PictogramRepository _pictogramRepository;
  final int subjectId;
  final bool isCitizen;

  WeekplanCubit({
    required ActivityRepository activityRepository,
    required PictogramRepository pictogramRepository,
    required this.subjectId,
    required this.isCitizen,
    DateTime? initialDate,
  })  : _activityRepository = activityRepository,
        _pictogramRepository = pictogramRepository,
        super(WeekplanLoading(
          selectedDate: initialDate ?? DateTime.now(),
          weekDates: GirafDateUtils.getWeekDates(initialDate ?? DateTime.now()),
        ));

  /// Week number for the currently selected date.
  int get weekNumber => GirafDateUtils.getWeekNumber(state.selectedDate);

  /// Load activities for the currently selected date.
  Future<void> loadActivities() async {
    final date = state.selectedDate;
    final weekDates = state.weekDates;

    emit(WeekplanLoading(selectedDate: date, weekDates: weekDates));

    final result = await _activityRepository.fetchActivities(
      id: subjectId,
      isCitizen: isCitizen,
      date: date,
    );

    switch (result) {
      case Left(:final value):
        emit(WeekplanError(
          message: value.message,
          selectedDate: date,
          weekDates: weekDates,
        ));
      case Right(:final value):
        emit(WeekplanLoaded(
          selectedDate: date,
          weekDates: weekDates,
          activities: value,
        ));
        _fetchPictogramMedia(value);
    }
  }

  /// Select a new date and reload activities.
  Future<void> selectDate(DateTime date) async {
    final weekDates = GirafDateUtils.getWeekDates(date);
    emit(WeekplanLoading(selectedDate: date, weekDates: weekDates));
    await loadActivities();
  }

  /// Navigate to the next week.
  Future<void> goToNextWeek() =>
      selectDate(state.selectedDate.add(const Duration(days: 7)));

  /// Navigate to the previous week.
  Future<void> goToPreviousWeek() =>
      selectDate(state.selectedDate.subtract(const Duration(days: 7)));

  /// Navigate to today.
  Future<void> goToToday() => selectDate(DateTime.now());

  /// Remove an activity from the UI without calling the server.
  ///
  /// Returns the removed [Activity] so the caller can undo or confirm.
  /// Returns null if the activity was not found or state is not loaded.
  Activity? hideActivity(int activityId) {
    final current = state;
    if (current is! WeekplanLoaded) return null;

    final index =
        current.activities.indexWhere((a) => a.activityId == activityId);
    if (index == -1) return null;

    final removed = current.activities[index];
    final updated =
        current.activities.where((a) => a.activityId != activityId).toList();
    emit(current.copyWith(activities: updated));
    return removed;
  }

  /// Restore a previously hidden activity to the list.
  void restoreActivity(Activity activity) {
    final current = state;
    if (current is! WeekplanLoaded) return;

    final restored = [...current.activities, activity]
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    emit(current.copyWith(activities: restored));
  }

  /// Permanently delete an activity on the server.
  ///
  /// Call after the undo window has passed. If the server call fails,
  /// the activity is restored to the list.
  Future<void> confirmDelete(int activityId, Activity backup) async {
    final result = await _activityRepository.deleteActivity(activityId);
    switch (result) {
      case Left(:final value):
        _log.warning('Delete failed, restoring: ${value.message}');
        restoreActivity(backup);
      case Right():
        break;
    }
  }

  /// Optimistically toggle an activity's completion status.
  Future<void> toggleActivityStatus(int activityId) async {
    final current = state;
    if (current is! WeekplanLoaded) return;

    final index =
        current.activities.indexWhere((a) => a.activityId == activityId);
    if (index == -1) return;

    final newValue = !current.activities[index].isCompleted;
    final updated = current.activities.map((a) {
      if (a.activityId == activityId) {
        return a.copyWith(isCompleted: newValue);
      }
      return a;
    }).toList();

    emit(current.copyWith(activities: updated));

    final result = await _activityRepository.toggleActivityStatus(
      activityId,
      isComplete: newValue,
    );
    switch (result) {
      case Left(:final value):
        _log.warning('Toggle rollback: ${value.message}');
        final rolledBack = updated.map((a) {
          if (a.activityId == activityId) {
            return a.copyWith(isCompleted: !newValue);
          }
          return a;
        }).toList();
        emit(current.copyWith(activities: rolledBack));
      case Right():
        break;
    }
  }

  /// Optimistically reorder activities after a drag-and-drop.
  Future<void> reorderActivities(int oldIndex, int newIndex) async {
    final current = state;
    if (current is! WeekplanLoaded) return;

    // ReorderableListView adjusts index when moving down
    final adjustedNew = oldIndex < newIndex ? newIndex - 1 : newIndex;
    if (oldIndex == adjustedNew) return;

    final backup = current.activities;
    final reordered = List<Activity>.from(backup);
    final item = reordered.removeAt(oldIndex);
    reordered.insert(adjustedNew, item);

    // Update sortOrder to match new positions
    final withSortOrder = [
      for (var i = 0; i < reordered.length; i++)
        reordered[i].copyWith(sortOrder: i),
    ];

    emit(current.copyWith(activities: withSortOrder));

    final result = await _activityRepository.reorderActivities(
      id: subjectId,
      isCitizen: isCitizen,
      activities: withSortOrder,
    );
    switch (result) {
      case Left(:final value):
        _log.warning('Reorder rollback: ${value.message}');
        emit(current.copyWith(activities: backup));
      case Right():
        break;
    }
  }

  /// Load activities for all 7 days in the current week.
  ///
  /// Stores results in [WeekplanLoaded.weekActivities] keyed by date string.
  Future<void> loadWeekActivities() async {
    final current = state;
    if (current is! WeekplanLoaded) return;

    final results = await Future.wait(
      current.weekDates.map((date) async {
        final result = await _activityRepository.fetchActivities(
          id: subjectId,
          isCitizen: isCitizen,
          date: date,
        );
        final dateKey = GirafDateUtils.formatQueryDate(date);
        return (dateKey, result);
      }),
    );

    // Re-check state hasn't changed during async gap
    final afterState = state;
    if (afterState is! WeekplanLoaded) return;

    final weekMap = <String, List<Activity>>{};
    for (final (dateKey, result) in results) {
      switch (result) {
        case Left():
          weekMap[dateKey] = const [];
        case Right(:final value):
          weekMap[dateKey] = value;
      }
    }

    emit(afterState.copyWith(weekActivities: weekMap));
  }

  /// Copy all current day's activities to a target date.
  ///
  /// Returns an error message on failure, or null on success.
  Future<String?> copyDayToDate(DateTime targetDate) async {
    final current = state;
    if (current is! WeekplanLoaded) return null;
    if (current.activities.isEmpty) return null;

    final activityIds =
        current.activities.map((a) => a.activityId).toList();

    final result = await _activityRepository.copyActivities(
      id: subjectId,
      isCitizen: isCitizen,
      sourceDate: current.selectedDate,
      targetDate: targetDate,
      activityIds: activityIds,
    );

    return switch (result) {
      Left(:final value) => value.message,
      Right() => null,
    };
  }

  /// Fetch image and sound URLs for pictograms in the given activities.
  Future<void> _fetchPictogramMedia(List<Activity> activities) async {
    final current = state;
    if (current is! WeekplanLoaded) return;

    final existingMedia = current.pictogramMedia;
    final ids = activities
        .where((a) => a.pictogramId != null)
        .map((a) => a.pictogramId!)
        .where((id) => !existingMedia.containsKey(id))
        .toSet();

    if (ids.isEmpty) return;

    final results = await Future.wait(
      ids.map((id) async {
        final result = await _pictogramRepository.fetchPictogram(id);
        return (id, result);
      }),
    );

    // Re-check state hasn't changed during async gap
    final afterState = state;
    if (afterState is! WeekplanLoaded) return;

    final updatedMedia =
        Map<int, PictogramMedia>.from(afterState.pictogramMedia);
    for (final (id, result) in results) {
      switch (result) {
        case Left():
          updatedMedia[id] = (imageUrl: null, soundUrl: null);
        case Right(:final value):
          updatedMedia[id] =
              (imageUrl: value.imageUrl, soundUrl: value.soundUrl);
      }
    }

    emit(afterState.copyWith(pictogramMedia: updatedMedia));
  }
}
