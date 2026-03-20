import 'package:flutter/foundation.dart';
import 'package:weekplanner/features/weekplan/data/repositories/activity_repository.dart';
import 'package:weekplanner/features/weekplan/data/repositories/pictogram_repository.dart';
import 'package:weekplanner/shared/models/activity.dart';
import 'package:weekplanner/shared/utils/date_utils.dart';

class WeekplanViewModel extends ChangeNotifier {
  final ActivityRepository _activityRepository;
  final PictogramRepository _pictogramRepository;
  final int subjectId;
  final bool isCitizen;

  WeekplanViewModel({
    required ActivityRepository activityRepository,
    required PictogramRepository pictogramRepository,
    required this.subjectId,
    required this.isCitizen,
  })  : _activityRepository = activityRepository,
        _pictogramRepository = pictogramRepository {
    _selectedDate = DateTime.now();
    _weekDates = GirafDateUtils.getWeekDates(_selectedDate);
  }

  late DateTime _selectedDate;
  late List<DateTime> _weekDates;
  final Map<int, String?> _pictogramSoundUrls = {};
  final Map<int, String?> _pictogramImageUrls = {};

  DateTime get selectedDate => _selectedDate;
  List<DateTime> get weekDates => _weekDates;
  int get weekNumber => GirafDateUtils.getWeekNumber(_selectedDate);
  List<Activity> get activities => _activityRepository.activities;
  bool get isLoading => _activityRepository.isLoading;
  String? get error => _activityRepository.error;

  /// Get cached sound URL for a pictogram, or null if not yet fetched.
  String? getSoundUrl(int pictogramId) => _pictogramSoundUrls[pictogramId];

  /// Get cached image URL for a pictogram, or null if not yet fetched.
  String? getImageUrl(int pictogramId) => _pictogramImageUrls[pictogramId];

  Future<void> loadActivities() async {
    await _activityRepository.fetchActivities(
      id: subjectId,
      isCitizen: isCitizen,
      date: _selectedDate,
    );
    _fetchPictogramSounds();
  }

  /// Fetch sound URLs for pictograms referenced by current activities.
  Future<void> _fetchPictogramSounds() async {
    final ids = activities
        .where((a) => a.pictogramId != null)
        .map((a) => a.pictogramId!)
        .where((id) => !_pictogramSoundUrls.containsKey(id))
        .toSet();

    for (final id in ids) {
      final pictogram = await _pictogramRepository.fetchPictogram(id);
      _pictogramSoundUrls[id] = pictogram?.soundUrl;
      _pictogramImageUrls[id] = pictogram?.imageUrl;
    }
    if (ids.isNotEmpty) notifyListeners();
  }

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
