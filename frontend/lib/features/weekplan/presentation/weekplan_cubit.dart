import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logging/logging.dart';

import 'package:weekplanner/features/weekplan/data/repositories/activity_repository.dart';
import 'package:weekplanner/features/weekplan/data/repositories/pictogram_repository.dart';
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
  void selectDate(DateTime date) {
    final weekDates = GirafDateUtils.getWeekDates(date);
    emit(WeekplanLoading(selectedDate: date, weekDates: weekDates));
    loadActivities();
  }

  /// Navigate to the next week.
  void goToNextWeek() {
    selectDate(state.selectedDate.add(const Duration(days: 7)));
  }

  /// Navigate to the previous week.
  void goToPreviousWeek() {
    selectDate(state.selectedDate.subtract(const Duration(days: 7)));
  }

  /// Optimistically delete an activity.
  Future<void> deleteActivity(int activityId) async {
    final current = state;
    if (current is! WeekplanLoaded) return;

    final backup = current.activities;
    final updated =
        backup.where((a) => a.activityId != activityId).toList();

    emit(WeekplanLoaded(
      selectedDate: current.selectedDate,
      weekDates: current.weekDates,
      activities: updated,
      pictogramMedia: current.pictogramMedia,
    ));

    final result = await _activityRepository.deleteActivity(activityId);
    switch (result) {
      case Left(:final value):
        _log.warning('Delete rollback: ${value.message}');
        emit(WeekplanLoaded(
          selectedDate: current.selectedDate,
          weekDates: current.weekDates,
          activities: backup,
          pictogramMedia: current.pictogramMedia,
        ));
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

    emit(WeekplanLoaded(
      selectedDate: current.selectedDate,
      weekDates: current.weekDates,
      activities: updated,
      pictogramMedia: current.pictogramMedia,
    ));

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
        emit(WeekplanLoaded(
          selectedDate: current.selectedDate,
          weekDates: current.weekDates,
          activities: rolledBack,
          pictogramMedia: current.pictogramMedia,
        ));
      case Right():
        break;
    }
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

    emit(WeekplanLoaded(
      selectedDate: afterState.selectedDate,
      weekDates: afterState.weekDates,
      activities: afterState.activities,
      pictogramMedia: updatedMedia,
    ));
  }
}
