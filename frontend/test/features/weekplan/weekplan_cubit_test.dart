import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:weekplanner/core/errors/activity_failure.dart';
import 'package:weekplanner/features/weekplan/domain/repositories/activity_repository.dart';
import 'package:weekplanner/features/weekplan/domain/repositories/pictogram_repository.dart';
import 'package:weekplanner/features/weekplan/domain/weekplan_state.dart';
import 'package:weekplanner/features/weekplan/presentation/weekplan_cubit.dart';
import 'package:weekplanner/shared/models/activity.dart';
import 'package:weekplanner/shared/models/pictogram.dart';
import 'package:weekplanner/shared/utils/date_utils.dart';

class MockActivityRepository extends Mock implements ActivityRepository {}

class MockPictogramRepository extends Mock implements PictogramRepository {}

void main() {
  late MockActivityRepository mockActivityRepo;
  late MockPictogramRepository mockPictogramRepo;

  // Fixed date for deterministic tests
  final testDate = DateTime(2026, 3, 22);
  final testWeekDates = GirafDateUtils.getWeekDates(testDate);

  final testActivity = Activity(
    activityId: 1,
    date: DateTime(2026, 3, 22),
    startTime: const (hour: 8, minute: 0),
    endTime: const (hour: 9, minute: 0),
  );

  final testActivityWithPictogram = Activity(
    activityId: 2,
    date: DateTime(2026, 3, 22),
    startTime: const (hour: 10, minute: 0),
    endTime: const (hour: 11, minute: 0),
    pictogramId: 42,
  );

  const testPictogram = Pictogram(
    id: 42,
    name: 'test',
    imageUrl: 'http://img',
    soundUrl: 'http://sound',
  );

  setUp(() {
    mockActivityRepo = MockActivityRepository();
    mockPictogramRepo = MockPictogramRepository();
  });

  WeekplanCubit buildCubit() => WeekplanCubit(
        activityRepository: mockActivityRepo,
        pictogramRepository: mockPictogramRepo,
        subjectId: 1,
        isCitizen: true,
        initialDate: testDate,
      );

  group('initial state', () {
    test('is WeekplanLoading with injected date', () {
      final cubit = buildCubit();
      expect(
        cubit.state,
        WeekplanLoading(selectedDate: testDate, weekDates: testWeekDates),
      );
      cubit.close();
    });
  });

  group('loadActivities', () {
    blocTest<WeekplanCubit, WeekplanState>(
      'emits [WeekplanLoading, WeekplanLoaded] on success',
      setUp: () {
        when(
          () => mockActivityRepo.fetchActivities(
            id: any(named: 'id'),
            isCitizen: any(named: 'isCitizen'),
            date: any(named: 'date'),
          ),
        ).thenAnswer((_) async => Right([testActivity]));
      },
      build: buildCubit,
      act: (cubit) => cubit.loadActivities(),
      expect: () => [
        WeekplanLoading(selectedDate: testDate, weekDates: testWeekDates),
        WeekplanLoaded(
          selectedDate: testDate,
          weekDates: testWeekDates,
          activities: [testActivity],
        ),
      ],
    );

    blocTest<WeekplanCubit, WeekplanState>(
      'emits [WeekplanLoading, WeekplanError] on failure',
      setUp: () {
        when(
          () => mockActivityRepo.fetchActivities(
            id: any(named: 'id'),
            isCitizen: any(named: 'isCitizen'),
            date: any(named: 'date'),
          ),
        ).thenAnswer((_) async => const Left(FetchActivitiesFailure()));
      },
      build: buildCubit,
      act: (cubit) => cubit.loadActivities(),
      expect: () => [
        WeekplanLoading(selectedDate: testDate, weekDates: testWeekDates),
        WeekplanError(
          message: 'Kunne ikke hente aktiviteter',
          selectedDate: testDate,
          weekDates: testWeekDates,
        ),
      ],
    );

    blocTest<WeekplanCubit, WeekplanState>(
      'fetches pictogram media for activities with pictogramId',
      setUp: () {
        when(
          () => mockActivityRepo.fetchActivities(
            id: any(named: 'id'),
            isCitizen: any(named: 'isCitizen'),
            date: any(named: 'date'),
          ),
        ).thenAnswer(
          (_) async => Right([testActivityWithPictogram]),
        );
        when(() => mockPictogramRepo.fetchPictogram(42))
            .thenAnswer((_) async => const Right(testPictogram));
      },
      build: buildCubit,
      act: (cubit) => cubit.loadActivities(),
      expect: () => [
        WeekplanLoading(selectedDate: testDate, weekDates: testWeekDates),
        WeekplanLoaded(
          selectedDate: testDate,
          weekDates: testWeekDates,
          activities: [testActivityWithPictogram],
        ),
        WeekplanLoaded(
          selectedDate: testDate,
          weekDates: testWeekDates,
          activities: [testActivityWithPictogram],
          pictogramMedia: const {
            42: (imageUrl: 'http://img', soundUrl: 'http://sound'),
          },
        ),
      ],
      verify: (_) {
        verify(() => mockPictogramRepo.fetchPictogram(42)).called(1);
      },
    );
  });

  group('selectDate', () {
    final newDate = DateTime(2026, 3, 29);
    final newWeekDates = GirafDateUtils.getWeekDates(newDate);

    blocTest<WeekplanCubit, WeekplanState>(
      'emits WeekplanLoading with new date and triggers loadActivities',
      setUp: () {
        when(
          () => mockActivityRepo.fetchActivities(
            id: any(named: 'id'),
            isCitizen: any(named: 'isCitizen'),
            date: any(named: 'date'),
          ),
        ).thenAnswer((_) async => Right([testActivity]));
      },
      build: buildCubit,
      act: (cubit) => cubit.selectDate(newDate),
      expect: () => [
        WeekplanLoading(selectedDate: newDate, weekDates: newWeekDates),
        WeekplanLoaded(
          selectedDate: newDate,
          weekDates: newWeekDates,
          activities: [testActivity],
        ),
      ],
    );
  });

  group('goToNextWeek', () {
    final nextWeekDate = testDate.add(const Duration(days: 7));
    final nextWeekDates = GirafDateUtils.getWeekDates(nextWeekDate);

    blocTest<WeekplanCubit, WeekplanState>(
      'advances date by 7 days',
      setUp: () {
        when(
          () => mockActivityRepo.fetchActivities(
            id: any(named: 'id'),
            isCitizen: any(named: 'isCitizen'),
            date: any(named: 'date'),
          ),
        ).thenAnswer((_) async => const Right([]));
      },
      build: buildCubit,
      act: (cubit) => cubit.goToNextWeek(),
      expect: () => [
        WeekplanLoading(selectedDate: nextWeekDate, weekDates: nextWeekDates),
        WeekplanLoaded(
          selectedDate: nextWeekDate,
          weekDates: nextWeekDates,
          activities: const [],
        ),
      ],
    );
  });

  group('goToPreviousWeek', () {
    final prevWeekDate = testDate.subtract(const Duration(days: 7));
    final prevWeekDates = GirafDateUtils.getWeekDates(prevWeekDate);

    blocTest<WeekplanCubit, WeekplanState>(
      'retreats date by 7 days',
      setUp: () {
        when(
          () => mockActivityRepo.fetchActivities(
            id: any(named: 'id'),
            isCitizen: any(named: 'isCitizen'),
            date: any(named: 'date'),
          ),
        ).thenAnswer((_) async => const Right([]));
      },
      build: buildCubit,
      act: (cubit) => cubit.goToPreviousWeek(),
      expect: () => [
        WeekplanLoading(selectedDate: prevWeekDate, weekDates: prevWeekDates),
        WeekplanLoaded(
          selectedDate: prevWeekDate,
          weekDates: prevWeekDates,
          activities: const [],
        ),
      ],
    );
  });

  group('deleteActivity', () {
    final activityToDelete = Activity(
      activityId: 99,
      date: DateTime(2026, 3, 22),
      startTime: const (hour: 12, minute: 0),
      endTime: const (hour: 13, minute: 0),
    );

    final loadedState = WeekplanLoaded(
      selectedDate: testDate,
      weekDates: testWeekDates,
      activities: [testActivity, activityToDelete],
    );

    blocTest<WeekplanCubit, WeekplanState>(
      'optimistically removes activity from list on success',
      setUp: () {
        when(() => mockActivityRepo.deleteActivity(99))
            .thenAnswer((_) async => const Right(unit));
      },
      build: buildCubit,
      seed: () => loadedState,
      act: (cubit) => cubit.deleteActivity(99),
      expect: () => [
        WeekplanLoaded(
          selectedDate: testDate,
          weekDates: testWeekDates,
          activities: [testActivity],
        ),
      ],
      verify: (_) {
        verify(() => mockActivityRepo.deleteActivity(99)).called(1);
      },
    );

    blocTest<WeekplanCubit, WeekplanState>(
      'rolls back to original list on failure',
      setUp: () {
        when(() => mockActivityRepo.deleteActivity(99))
            .thenAnswer((_) async => const Left(DeleteActivityFailure()));
      },
      build: buildCubit,
      seed: () => loadedState,
      act: (cubit) => cubit.deleteActivity(99),
      expect: () => [
        WeekplanLoaded(
          selectedDate: testDate,
          weekDates: testWeekDates,
          activities: [testActivity],
        ),
        loadedState,
      ],
    );

    blocTest<WeekplanCubit, WeekplanState>(
      'does nothing when state is not WeekplanLoaded',
      build: buildCubit,
      // Initial state is WeekplanLoading
      act: (cubit) => cubit.deleteActivity(1),
      expect: () => <WeekplanState>[],
    );
  });

  group('toggleActivityStatus', () {
    final incompleteActivity = Activity(
      activityId: 5,
      date: DateTime(2026, 3, 22),
      startTime: const (hour: 8, minute: 0),
      endTime: const (hour: 9, minute: 0),
      isCompleted: false,
    );

    final completedActivity = Activity(
      activityId: 5,
      date: DateTime(2026, 3, 22),
      startTime: const (hour: 8, minute: 0),
      endTime: const (hour: 9, minute: 0),
      isCompleted: true,
    );

    final loadedState = WeekplanLoaded(
      selectedDate: testDate,
      weekDates: testWeekDates,
      activities: [incompleteActivity],
    );

    blocTest<WeekplanCubit, WeekplanState>(
      'optimistically flips isCompleted to true on success',
      setUp: () {
        when(
          () => mockActivityRepo.toggleActivityStatus(
            5,
            isComplete: true,
          ),
        ).thenAnswer((_) async => const Right(unit));
      },
      build: buildCubit,
      seed: () => loadedState,
      act: (cubit) => cubit.toggleActivityStatus(5),
      expect: () => [
        WeekplanLoaded(
          selectedDate: testDate,
          weekDates: testWeekDates,
          activities: [completedActivity],
        ),
      ],
      verify: (_) {
        verify(
          () => mockActivityRepo.toggleActivityStatus(5, isComplete: true),
        ).called(1);
      },
    );

    blocTest<WeekplanCubit, WeekplanState>(
      'rolls back isCompleted on failure',
      setUp: () {
        when(
          () => mockActivityRepo.toggleActivityStatus(
            5,
            isComplete: any(named: 'isComplete'),
          ),
        ).thenAnswer((_) async => const Left(ToggleStatusFailure()));
      },
      build: buildCubit,
      seed: () => loadedState,
      act: (cubit) => cubit.toggleActivityStatus(5),
      expect: () => [
        WeekplanLoaded(
          selectedDate: testDate,
          weekDates: testWeekDates,
          activities: [completedActivity],
        ),
        loadedState,
      ],
    );

    blocTest<WeekplanCubit, WeekplanState>(
      'does nothing when activity id is not found',
      build: buildCubit,
      seed: () => loadedState,
      act: (cubit) => cubit.toggleActivityStatus(999),
      expect: () => <WeekplanState>[],
    );

    blocTest<WeekplanCubit, WeekplanState>(
      'does nothing when state is not WeekplanLoaded',
      build: buildCubit,
      // Initial state is WeekplanLoading
      act: (cubit) => cubit.toggleActivityStatus(5),
      expect: () => <WeekplanState>[],
    );
  });
}
