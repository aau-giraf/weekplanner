import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weekplanner/features/weekplan/data/repositories/activity_repository.dart';
import 'package:weekplanner/shared/models/activity.dart';
import 'package:weekplanner/shared/services/activity_api_service.dart';

@GenerateNiceMocks([MockSpec<ActivityApiService>()])
import 'activity_repository_test.mocks.dart';

void main() {
  late MockActivityApiService mockApi;
  late ActivityRepository repo;

  const testActivity = Activity(
    activityId: 1,
    date: '2025-03-17',
    startTime: '08:00:00',
    endTime: '09:00:00',
    isCompleted: false,
    pictogramId: 5,
  );

  setUp(() {
    mockApi = MockActivityApiService();
    repo = ActivityRepository(apiService: mockApi);
  });

  group('ActivityRepository', () {
    test('fetchActivities loads citizen activities', () async {
      when(mockApi.fetchActivitiesByCitizen(42, '2025-03-17'))
          .thenAnswer((_) async => [testActivity]);

      await repo.fetchActivities(
        id: 42,
        isCitizen: true,
        date: DateTime(2025, 3, 17),
      );

      expect(repo.activities.length, 1);
      expect(repo.activities[0].activityId, 1);
      expect(repo.isLoading, false);
      expect(repo.error, null);
    });

    test('fetchActivities loads grade activities', () async {
      when(mockApi.fetchActivitiesByGrade(10, '2025-03-17'))
          .thenAnswer((_) async => [testActivity]);

      await repo.fetchActivities(
        id: 10,
        isCitizen: false,
        date: DateTime(2025, 3, 17),
      );

      expect(repo.activities.length, 1);
      verify(mockApi.fetchActivitiesByGrade(10, '2025-03-17')).called(1);
    });

    test('fetchActivities sets error on failure', () async {
      when(mockApi.fetchActivitiesByCitizen(any, any))
          .thenThrow(Exception('Network error'));

      await repo.fetchActivities(
        id: 42,
        isCitizen: true,
        date: DateTime(2025, 3, 17),
      );

      expect(repo.error, isNotNull);
      expect(repo.isLoading, false);
    });

    test('createActivity adds to list', () async {
      when(mockApi.createActivityForCitizen(42, any))
          .thenAnswer((_) async => testActivity);

      await repo.createActivity(
        id: 42,
        isCitizen: true,
        data: {'date': '2025-03-17'},
      );

      expect(repo.activities.length, 1);
    });

    test('deleteActivity removes optimistically', () async {
      when(mockApi.fetchActivitiesByCitizen(42, '2025-03-17'))
          .thenAnswer((_) async => [testActivity]);
      await repo.fetchActivities(
        id: 42,
        isCitizen: true,
        date: DateTime(2025, 3, 17),
      );
      expect(repo.activities.length, 1);

      when(mockApi.deleteActivity(1)).thenAnswer((_) async {});
      await repo.deleteActivity(1);

      expect(repo.activities, isEmpty);
    });

    test('deleteActivity rolls back on failure', () async {
      when(mockApi.fetchActivitiesByCitizen(42, '2025-03-17'))
          .thenAnswer((_) async => [testActivity]);
      await repo.fetchActivities(
        id: 42,
        isCitizen: true,
        date: DateTime(2025, 3, 17),
      );

      when(mockApi.deleteActivity(1)).thenThrow(Exception('fail'));

      try {
        await repo.deleteActivity(1);
      } catch (_) {}

      expect(repo.activities.length, 1);
    });

    test('toggleActivityStatus toggles optimistically', () async {
      when(mockApi.fetchActivitiesByCitizen(42, '2025-03-17'))
          .thenAnswer((_) async => [testActivity]);
      await repo.fetchActivities(
        id: 42,
        isCitizen: true,
        date: DateTime(2025, 3, 17),
      );
      expect(repo.activities[0].isCompleted, false);

      when(mockApi.toggleActivityStatus(1))
          .thenAnswer((_) async => testActivity.copyWith(isCompleted: true));

      await repo.toggleActivityStatus(1);
      expect(repo.activities[0].isCompleted, true);
    });

    test('notifies listeners on changes', () async {
      int notifyCount = 0;
      repo.addListener(() => notifyCount++);

      when(mockApi.fetchActivitiesByCitizen(42, '2025-03-17'))
          .thenAnswer((_) async => [testActivity]);

      await repo.fetchActivities(
        id: 42,
        isCitizen: true,
        date: DateTime(2025, 3, 17),
      );

      expect(notifyCount, greaterThanOrEqualTo(2));
    });
  });
}
