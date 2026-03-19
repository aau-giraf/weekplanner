import 'package:flutter/foundation.dart';
import 'package:weekplanner/features/weekplan/data/repositories/activity_repository.dart';
import 'package:weekplanner/shared/models/activity.dart';
import 'package:weekplanner/shared/utils/date_utils.dart';

class WeekplanViewModel extends ChangeNotifier {
  final ActivityRepository _activityRepository;
  final int subjectId;
  final bool isCitizen;

  WeekplanViewModel({
    required ActivityRepository activityRepository,
    required this.subjectId,
    required this.isCitizen,
  }) : _activityRepository = activityRepository {
    _selectedDate = DateTime.now();
    _weekDates = GirafDateUtils.getWeekDates(_selectedDate);
  }

  late DateTime _selectedDate;
  late List<DateTime> _weekDates;

  DateTime get selectedDate => _selectedDate;
  List<DateTime> get weekDates => _weekDates;
  int get weekNumber => GirafDateUtils.getWeekNumber(_selectedDate);
  List<Activity> get activities => _activityRepository.activities;
  bool get isLoading => _activityRepository.isLoading;
  String? get error => _activityRepository.error;

  Future<void> loadActivities() => _activityRepository.fetchActivities(
        id: subjectId,
        isCitizen: isCitizen,
        date: _selectedDate,
      );

  void selectDate(DateTime date) {
    _selectedDate = date;
    _weekDates = GirafDateUtils.getWeekDates(date);
    notifyListeners();
    loadActivities();
  }

  void goToNextWeek() {
    selectDate(_selectedDate.add(const Duration(days: 7)));
  }

  void goToPreviousWeek() {
    selectDate(_selectedDate.subtract(const Duration(days: 7)));
  }

  Future<void> deleteActivity(int activityId) =>
      _activityRepository.deleteActivity(activityId);

  Future<void> toggleActivityStatus(int activityId) =>
      _activityRepository.toggleActivityStatus(activityId);
}
