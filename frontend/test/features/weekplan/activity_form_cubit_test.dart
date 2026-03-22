import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:weekplanner/core/errors/activity_failure.dart';
import 'package:weekplanner/core/errors/pictogram_failure.dart';
import 'package:weekplanner/features/weekplan/data/repositories/activity_repository.dart';
import 'package:weekplanner/features/weekplan/data/repositories/pictogram_repository.dart';
import 'package:weekplanner/features/weekplan/domain/activity_form_state.dart';
import 'package:weekplanner/features/weekplan/presentation/activity_form_cubit.dart';
import 'package:weekplanner/shared/models/activity.dart';
import 'package:weekplanner/shared/models/pictogram.dart';

class MockActivityRepository extends Mock implements ActivityRepository {}

class MockPictogramRepository extends Mock implements PictogramRepository {}

class FakePlatformFile extends Fake implements PlatformFile {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakePlatformFile());
  });
  late MockActivityRepository mockActivityRepo;
  late MockPictogramRepository mockPictogramRepo;

  final testDate = DateTime(2026, 3, 22);

  const testActivity = Activity(
    activityId: 1,
    date: '2026-03-22',
    startTime: '08:00:00',
    endTime: '09:00:00',
  );

  const testActivityWithPictogram = Activity(
    activityId: 2,
    date: '2026-03-15',
    startTime: '10:30:00',
    endTime: '11:45:00',
    pictogramId: 42,
  );

  const testPictogram = Pictogram(id: 1, name: 'test');

  setUp(() {
    mockActivityRepo = MockActivityRepository();
    mockPictogramRepo = MockPictogramRepository();
  });

  ActivityFormCubit buildCubit({Activity? existingActivity}) =>
      ActivityFormCubit(
        activityRepository: mockActivityRepo,
        pictogramRepository: mockPictogramRepo,
        subjectId: 1,
        isCitizen: true,
        initialDate: testDate,
        existingActivity: existingActivity,
      );

  group('initial state', () {
    test('is ActivityFormReady with default times for new activity', () {
      final cubit = buildCubit();
      expect(cubit.state, isA<ActivityFormReady>());
      expect(cubit.state.startTime, const (hour: 8, minute: 0));
      expect(cubit.state.endTime, const (hour: 9, minute: 0));
      expect(cubit.state.date, testDate);
      expect(cubit.state.existingActivity, isNull);
      cubit.close();
    });

    test('parses existing activity times and date in edit mode', () {
      final cubit = buildCubit(existingActivity: testActivityWithPictogram);
      expect(cubit.state, isA<ActivityFormReady>());
      expect(cubit.state.startTime, const (hour: 10, minute: 30));
      expect(cubit.state.endTime, const (hour: 11, minute: 45));
      expect(cubit.state.date, DateTime(2026, 3, 15));
      expect(cubit.state.selectedPictogramId, 42);
      expect(cubit.state.existingActivity, testActivityWithPictogram);
      cubit.close();
    });
  });

  group('setStartTime', () {
    blocTest<ActivityFormCubit, ActivityFormState>(
      'emits updated ActivityFormReady with new start time',
      build: buildCubit,
      act: (cubit) => cubit.setStartTime(const (hour: 10, minute: 30)),
      expect: () => [
        isA<ActivityFormReady>().having(
          (s) => s.startTime,
          'startTime',
          const (hour: 10, minute: 30),
        ),
      ],
    );
  });

  group('setEndTime', () {
    blocTest<ActivityFormCubit, ActivityFormState>(
      'emits updated ActivityFormReady with new end time',
      build: buildCubit,
      act: (cubit) => cubit.setEndTime(const (hour: 11, minute: 0)),
      expect: () => [
        isA<ActivityFormReady>().having(
          (s) => s.endTime,
          'endTime',
          const (hour: 11, minute: 0),
        ),
      ],
    );
  });

  group('setPictogramMode', () {
    blocTest<ActivityFormCubit, ActivityFormState>(
      'emits updated ActivityFormReady with new pictogram mode',
      build: buildCubit,
      act: (cubit) => cubit.setPictogramMode(PictogramMode.upload),
      expect: () => [
        isA<ActivityFormReady>().having(
          (s) => s.pictogramMode,
          'pictogramMode',
          PictogramMode.upload,
        ),
      ],
    );
  });

  group('selectPictogram', () {
    blocTest<ActivityFormCubit, ActivityFormState>(
      'emits ActivityFormReady with pictogram ID and object',
      build: buildCubit,
      act: (cubit) => cubit.selectPictogram(testPictogram),
      expect: () => [
        isA<ActivityFormReady>()
            .having((s) => s.selectedPictogramId, 'selectedPictogramId', 1)
            .having(
              (s) => s.selectedPictogram,
              'selectedPictogram',
              testPictogram,
            ),
      ],
    );
  });

  group('searchPictograms', () {
    blocTest<ActivityFormCubit, ActivityFormState>(
      'emits [isSearching=true, searchResults, isSearching=false] on success',
      setUp: () {
        when(() => mockPictogramRepo.searchPictograms(any()))
            .thenAnswer((_) async => const Right([testPictogram]));
      },
      build: buildCubit,
      act: (cubit) => cubit.searchPictograms('test'),
      expect: () => [
        isA<ActivityFormReady>().having(
          (s) => s.isSearching,
          'isSearching',
          true,
        ),
        isA<ActivityFormReady>()
            .having((s) => s.isSearching, 'isSearching', false)
            .having(
              (s) => s.searchResults,
              'searchResults',
              const [testPictogram],
            ),
      ],
    );

    blocTest<ActivityFormCubit, ActivityFormState>(
      'emits [isSearching=true, isSearching=false] on failure',
      setUp: () {
        when(() => mockPictogramRepo.searchPictograms(any()))
            .thenAnswer((_) async => const Left(SearchPictogramsFailure()));
      },
      build: buildCubit,
      act: (cubit) => cubit.searchPictograms('test'),
      expect: () => [
        isA<ActivityFormReady>().having(
          (s) => s.isSearching,
          'isSearching',
          true,
        ),
        isA<ActivityFormReady>().having(
          (s) => s.isSearching,
          'isSearching',
          false,
        ),
      ],
    );
  });

  group('uploadPictogramFromFile', () {
    test('returns false and emits error when name or file is missing', () async {
      final cubit = buildCubit();
      final result = await cubit.uploadPictogramFromFile();
      expect(result, isFalse);
      expect(cubit.state, isA<ActivityFormReady>());
      expect((cubit.state as ActivityFormReady).error,
          'Angiv navn og vælg et billede');
      cubit.close();
    });

    test('returns true and selects pictogram on success', () async {
      when(
        () => mockPictogramRepo.uploadPictogram(
          name: any(named: 'name'),
          imageFile: any(named: 'imageFile'),
          soundFile: any(named: 'soundFile'),
          organizationId: any(named: 'organizationId'),
          generateSound: any(named: 'generateSound'),
        ),
      ).thenAnswer((_) async => const Right(testPictogram));

      final cubit = buildCubit();
      // Seed state with name and image file
      cubit.setPictogramName('test');
      final fakeFile = PlatformFile(name: 'image.png', size: 0, bytes: Uint8List(0));
      cubit.setSelectedImageFile(fakeFile);

      final result = await cubit.uploadPictogramFromFile();
      expect(result, isTrue);
      expect(cubit.state, isA<ActivityFormReady>());
      expect(cubit.state.selectedPictogramId, 1);
      expect(cubit.state.selectedPictogram, testPictogram);
      cubit.close();
    });

    test('returns false and emits error message on failure', () async {
      when(
        () => mockPictogramRepo.uploadPictogram(
          name: any(named: 'name'),
          imageFile: any(named: 'imageFile'),
          soundFile: any(named: 'soundFile'),
          organizationId: any(named: 'organizationId'),
          generateSound: any(named: 'generateSound'),
        ),
      ).thenAnswer((_) async => const Left(CreatePictogramFailure()));

      final cubit = buildCubit();
      cubit.setPictogramName('test');
      final fakeFile = PlatformFile(name: 'image.png', size: 0, bytes: Uint8List(0));
      cubit.setSelectedImageFile(fakeFile);

      final result = await cubit.uploadPictogramFromFile();
      expect(result, isFalse);
      expect((cubit.state as ActivityFormReady).error,
          'Kunne ikke oprette piktogram');
      cubit.close();
    });
  });

  group('generatePictogram', () {
    test('returns false and emits error when prompt is empty', () async {
      final cubit = buildCubit();
      final result = await cubit.generatePictogram();
      expect(result, isFalse);
      expect((cubit.state as ActivityFormReady).error,
          'Angiv et navn eller en beskrivelse');
      cubit.close();
    });

    test('returns true and selects pictogram on success', () async {
      when(
        () => mockPictogramRepo.createPictogram(
          name: any(named: 'name'),
          organizationId: any(named: 'organizationId'),
          generateImage: any(named: 'generateImage'),
          generateSound: any(named: 'generateSound'),
        ),
      ).thenAnswer((_) async => const Right(testPictogram));

      final cubit = buildCubit();
      cubit.setPictogramName('cat');

      final result = await cubit.generatePictogram();
      expect(result, isTrue);
      expect(cubit.state.selectedPictogramId, 1);
      expect(cubit.state.selectedPictogram, testPictogram);
      cubit.close();
    });

    test('returns false and emits error message on failure', () async {
      when(
        () => mockPictogramRepo.createPictogram(
          name: any(named: 'name'),
          organizationId: any(named: 'organizationId'),
          generateImage: any(named: 'generateImage'),
          generateSound: any(named: 'generateSound'),
        ),
      ).thenAnswer((_) async => const Left(CreatePictogramFailure()));

      final cubit = buildCubit();
      cubit.setGeneratePrompt('a cat playing');

      final result = await cubit.generatePictogram();
      expect(result, isFalse);
      expect((cubit.state as ActivityFormReady).error,
          'Kunne ikke oprette piktogram');
      cubit.close();
    });
  });

  group('validate', () {
    test('returns error when endTime <= startTime', () {
      final cubit = buildCubit();
      cubit.setStartTime(const (hour: 10, minute: 0));
      cubit.setEndTime(const (hour: 9, minute: 0));
      expect(cubit.validate(), 'Sluttid skal være efter starttid');
      cubit.close();
    });

    test('returns error when endTime == startTime', () {
      final cubit = buildCubit();
      cubit.setStartTime(const (hour: 10, minute: 0));
      cubit.setEndTime(const (hour: 10, minute: 0));
      expect(cubit.validate(), 'Sluttid skal være efter starttid');
      cubit.close();
    });

    test('returns null when times are valid', () {
      final cubit = buildCubit();
      cubit.setStartTime(const (hour: 8, minute: 0));
      cubit.setEndTime(const (hour: 9, minute: 0));
      expect(cubit.validate(), isNull);
      cubit.close();
    });
  });

  group('save', () {
    blocTest<ActivityFormCubit, ActivityFormState>(
      'emits [ActivityFormSaving, ActivityFormSaved] on successful create',
      setUp: () {
        when(
          () => mockActivityRepo.createActivity(
            id: any(named: 'id'),
            isCitizen: any(named: 'isCitizen'),
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async => const Right(testActivity));
      },
      build: buildCubit,
      act: (cubit) => cubit.save(),
      expect: () => [
        isA<ActivityFormSaving>(),
        isA<ActivityFormSaved>(),
      ],
      verify: (_) {
        verify(
          () => mockActivityRepo.createActivity(
            id: any(named: 'id'),
            isCitizen: any(named: 'isCitizen'),
            data: any(named: 'data'),
          ),
        ).called(1);
      },
    );

    blocTest<ActivityFormCubit, ActivityFormState>(
      'emits [ActivityFormSaving, ActivityFormReady(error)] on failure',
      setUp: () {
        when(
          () => mockActivityRepo.createActivity(
            id: any(named: 'id'),
            isCitizen: any(named: 'isCitizen'),
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async => const Left(CreateActivityFailure()));
      },
      build: buildCubit,
      act: (cubit) => cubit.save(),
      expect: () => [
        isA<ActivityFormSaving>(),
        isA<ActivityFormReady>().having(
          (s) => s.error,
          'error',
          isNotNull,
        ),
      ],
    );

    blocTest<ActivityFormCubit, ActivityFormState>(
      'calls updateActivity when editing an existing activity',
      setUp: () {
        when(
          () => mockActivityRepo.updateActivity(
            any(),
            any(),
          ),
        ).thenAnswer((_) async => const Right(testActivity));
      },
      build: () => buildCubit(existingActivity: testActivity),
      act: (cubit) => cubit.save(),
      expect: () => [
        isA<ActivityFormSaving>(),
        isA<ActivityFormSaved>(),
      ],
      verify: (_) {
        verify(
          () => mockActivityRepo.updateActivity(any(), any()),
        ).called(1);
      },
    );

    blocTest<ActivityFormCubit, ActivityFormState>(
      'emits ActivityFormReady with error and no Saving when validation fails',
      build: buildCubit,
      act: (cubit) async {
        // Start time moved forward to 10:00, making it after the default end of 9:00
        cubit.setStartTime(const (hour: 10, minute: 0));
        await cubit.save();
      },
      expect: () => [
        // setStartTime emits
        isA<ActivityFormReady>().having(
          (s) => s.startTime,
          'startTime',
          const (hour: 10, minute: 0),
        ),
        // save emits error (no ActivityFormSaving)
        isA<ActivityFormReady>().having(
          (s) => s.error,
          'error',
          'Sluttid skal være efter starttid',
        ),
      ],
    );
  });

  group('close', () {
    test('cancels search debounce timer without throwing', () async {
      final cubit = buildCubit();
      cubit.onSearchQueryChanged('test');
      // Closing before the 400ms debounce fires should not throw
      await expectLater(cubit.close(), completes);
    });
  });
}
