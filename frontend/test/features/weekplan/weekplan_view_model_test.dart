import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weekplanner/features/weekplan/data/repositories/activity_repository.dart';
import 'package:weekplanner/features/weekplan/presentation/view_models/weekplan_view_model.dart';
import 'package:weekplanner/shared/models/activity.dart';

@GenerateNiceMocks([MockSpec<ActivityRepository>()])
import 'weekplan_view_model_test.mocks.dart';

void main() {
  late MockActivityRepository mockRepo;
  late WeekplanViewModel vm;

  final testActivities = [
    const Activity(
      activityId: 1,
      date: '2025-03-17',
      startTime: '08:00:00',
      endTime: '09:00:00',
      isCompleted: false,
    ),
    const Activity(
      activityId: 2,
      date: '2025-03-17',
      startTime: '10:00:00',
      endTime: '11:00:00',
      isCompleted: true,
    ),
  ];

  setUp(() {
    mockRepo = MockActivityRepository();
    when(mockRepo.activities).thenReturn([]);
    when(mockRepo.isLoading).thenReturn(false);
    when(mockRepo.error).thenReturn(null);
    when(mockRepo.fetchActivities(
      id: anyNamed('id'),
      isCitizen: anyNamed('isCitizen'),
      date: anyNamed('date'),
    )).thenAnswer((_) async {});

    vm = WeekplanViewModel(
      activityRepository: mockRepo,
      subjectId: 42,
      isCitizen: true,
    );
  });

  group('WeekplanViewModel', () {
    test('initial state has 7 week dates', () {
      expect(vm.weekDates.length, 7);
      expect(vm.weekDates[0].weekday, DateTime.monday);
    });

    test('loadActivities fetches from repository', () async {
      await vm.loadActivities();
      verify(mockRepo.fetchActivities(
        id: 42,
        isCitizen: true,
        date: anyNamed('date'),
      )).called(1);
    });

    test('goToNextWeek advances by 7 days', () {
      final initialDate = vm.selectedDate;
      vm.goToNextWeek();
      expect(
        vm.selectedDate.difference(initialDate).inDays,
        7,
      );
    });

    test('goToPreviousWeek goes back by 7 days', () {
      final initialDate = vm.selectedDate;
      vm.goToPreviousWeek();
      expect(
        initialDate.difference(vm.selectedDate).inDays,
        7,
      );
    });

    test('selectDate updates selected date and reloads', () {
      final newDate = DateTime(2025, 6, 15);
      vm.selectDate(newDate);
      expect(vm.selectedDate, newDate);
      verify(mockRepo.fetchActivities(
        id: 42,
        isCitizen: true,
        date: anyNamed('date'),
      )).called(1);
    });

    test('deleteActivity delegates to repository', () async {
      when(mockRepo.deleteActivity(1)).thenAnswer((_) async {});
      await vm.deleteActivity(1);
      verify(mockRepo.deleteActivity(1)).called(1);
    });

    test('toggleActivityStatus delegates to repository', () async {
      when(mockRepo.toggleActivityStatus(1)).thenAnswer((_) async {});
      await vm.toggleActivityStatus(1);
      verify(mockRepo.toggleActivityStatus(1)).called(1);
    });

    test('exposes activities from repository', () {
      when(mockRepo.activities).thenReturn(testActivities);
      expect(vm.activities, testActivities);
    });

    test('week number is consistent with selected date', () {
      expect(vm.weekNumber, isPositive);
      expect(vm.weekNumber, lessThanOrEqualTo(53));
    });
  });
}
