import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:weekplanner/core/errors/activity_failure.dart';
import 'package:weekplanner/features/weekplan/data/repositories/activity_repository.dart';
import 'package:weekplanner/shared/models/activity.dart';
import 'package:weekplanner/shared/services/activity_api_service.dart';

class MockActivityApiService extends Mock implements ActivityApiService {}

void main() {
  late MockActivityApiService mockApiService;
  late ActivityRepository repo;

  const activity = Activity(
    activityId: 1,
    date: '2026-03-22',
    startTime: '08:00:00',
    endTime: '09:00:00',
  );

  final date = DateTime(2026, 3, 22);
  const data = <String, dynamic>{
    'startTime': '08:00:00',
    'endTime': '09:00:00',
  };

  setUp(() {
    mockApiService = MockActivityApiService();
    repo = ActivityRepository(apiService: mockApiService);
  });

  group('fetchActivities', () {
    test('returns Right with list on success (citizen path)', () async {
      when(() => mockApiService.fetchActivitiesByCitizen(1, '2026-03-22'))
          .thenAnswer((_) async => [activity]);

      final result = await repo.fetchActivities(
        id: 1,
        isCitizen: true,
        date: date,
      );

      expect(result, isA<Right<ActivityFailure, List<Activity>>>());
      expect(result.getOrElse((_) => []), [activity]);
      verify(() => mockApiService.fetchActivitiesByCitizen(1, '2026-03-22'))
          .called(1);
    });

    test('returns Right with list on success (grade path)', () async {
      when(() => mockApiService.fetchActivitiesByGrade(2, '2026-03-22'))
          .thenAnswer((_) async => [activity]);

      final result = await repo.fetchActivities(
        id: 2,
        isCitizen: false,
        date: date,
      );

      expect(result, isA<Right<ActivityFailure, List<Activity>>>());
      expect(result.getOrElse((_) => []), [activity]);
      verify(() => mockApiService.fetchActivitiesByGrade(2, '2026-03-22'))
          .called(1);
    });

    test('returns Left(FetchActivitiesFailure) on exception', () async {
      when(() => mockApiService.fetchActivitiesByCitizen(1, '2026-03-22'))
          .thenThrow(Exception('network error'));

      final result = await repo.fetchActivities(
        id: 1,
        isCitizen: true,
        date: date,
      );

      expect(result, isA<Left<ActivityFailure, List<Activity>>>());
      result.fold(
        (failure) => expect(failure, isA<FetchActivitiesFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  group('createActivity', () {
    test('returns Right with activity on success (citizen path)', () async {
      when(() => mockApiService.createActivityForCitizen(1, data))
          .thenAnswer((_) async => activity);

      final result = await repo.createActivity(
        id: 1,
        isCitizen: true,
        data: data,
      );

      expect(result, isA<Right<ActivityFailure, Activity>>());
      result.fold(
        (_) => fail('Expected Right'),
        (a) => expect(a, activity),
      );
      verify(() => mockApiService.createActivityForCitizen(1, data)).called(1);
    });

    test('returns Left(CreateActivityFailure) on exception', () async {
      when(() => mockApiService.createActivityForCitizen(1, data))
          .thenThrow(Exception('server error'));

      final result = await repo.createActivity(
        id: 1,
        isCitizen: true,
        data: data,
      );

      expect(result, isA<Left<ActivityFailure, Activity>>());
      result.fold(
        (failure) => expect(failure, isA<CreateActivityFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  group('updateActivity', () {
    test('returns Right with updated activity on success', () async {
      when(() => mockApiService.updateActivity(1, data))
          .thenAnswer((_) async => activity);

      final result = await repo.updateActivity(1, data);

      expect(result, isA<Right<ActivityFailure, Activity>>());
      result.fold(
        (_) => fail('Expected Right'),
        (a) => expect(a, activity),
      );
      verify(() => mockApiService.updateActivity(1, data)).called(1);
    });

    test('returns Left(UpdateActivityFailure) on exception', () async {
      when(() => mockApiService.updateActivity(1, data))
          .thenThrow(Exception('server error'));

      final result = await repo.updateActivity(1, data);

      expect(result, isA<Left<ActivityFailure, Activity>>());
      result.fold(
        (failure) => expect(failure, isA<UpdateActivityFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  group('deleteActivity', () {
    test('returns Right(unit) on success', () async {
      when(() => mockApiService.deleteActivity(1)).thenAnswer((_) async {});

      final result = await repo.deleteActivity(1);

      expect(result, isA<Right<ActivityFailure, Unit>>());
      expect(result.getOrElse((_) => throw Exception()), unit);
      verify(() => mockApiService.deleteActivity(1)).called(1);
    });

    test('returns Left(DeleteActivityFailure) on exception', () async {
      when(() => mockApiService.deleteActivity(1))
          .thenThrow(Exception('server error'));

      final result = await repo.deleteActivity(1);

      expect(result, isA<Left<ActivityFailure, Unit>>());
      result.fold(
        (failure) => expect(failure, isA<DeleteActivityFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  group('toggleActivityStatus', () {
    test('returns Right(unit) on success', () async {
      when(() => mockApiService.toggleActivityStatus(1, isComplete: true))
          .thenAnswer((_) async {});

      final result = await repo.toggleActivityStatus(1, isComplete: true);

      expect(result, isA<Right<ActivityFailure, Unit>>());
      expect(result.getOrElse((_) => throw Exception()), unit);
      verify(
        () => mockApiService.toggleActivityStatus(1, isComplete: true),
      ).called(1);
    });

    test('returns Left(ToggleStatusFailure) on exception', () async {
      when(() => mockApiService.toggleActivityStatus(1, isComplete: true))
          .thenThrow(Exception('server error'));

      final result = await repo.toggleActivityStatus(1, isComplete: true);

      expect(result, isA<Left<ActivityFailure, Unit>>());
      result.fold(
        (failure) => expect(failure, isA<ToggleStatusFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
