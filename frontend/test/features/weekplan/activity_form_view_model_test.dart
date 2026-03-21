import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekplanner/features/weekplan/data/repositories/activity_repository.dart';
import 'package:weekplanner/features/weekplan/data/repositories/pictogram_repository.dart';
import 'package:weekplanner/features/weekplan/presentation/view_models/activity_form_view_model.dart';
import 'package:weekplanner/shared/models/activity.dart';
import 'package:weekplanner/shared/models/pictogram.dart';
import 'package:weekplanner/shared/services/activity_api_service.dart';
import 'package:weekplanner/shared/services/core_api_service.dart';

class FakeActivityApiService extends ActivityApiService {
  Future<Activity> Function(int citizenId, Map<String, dynamic> data)?
      onCreateCitizen;
  Future<Activity> Function(int activityId, Map<String, dynamic> data)? onUpdate;

  @override
  Future<Activity> createActivityForCitizen(
    int citizenId,
    Map<String, dynamic> data,
  ) async {
    if (onCreateCitizen == null) {
      throw UnimplementedError('onCreateCitizen not configured');
    }
    return onCreateCitizen!(citizenId, data);
  }

  @override
  Future<Activity> updateActivity(
    int activityId,
    Map<String, dynamic> data,
  ) async {
    if (onUpdate == null) {
      throw UnimplementedError('onUpdate not configured');
    }
    return onUpdate!(activityId, data);
  }
}

class FakeCoreApiService extends CoreApiService {
  Future<Pictogram> Function({
    required String name,
    String? imageUrl,
    int? organizationId,
    bool generateImage,
    bool generateSound,
  })? onCreatePictogram;

  @override
  Future<Pictogram> createPictogram({
    required String name,
    String? imageUrl,
    int? organizationId,
    bool generateImage = false,
    bool generateSound = true,
  }) async {
    if (onCreatePictogram == null) {
      throw UnimplementedError('onCreatePictogram not configured');
    }
    return onCreatePictogram!(
      name: name,
      imageUrl: imageUrl,
      organizationId: organizationId,
      generateImage: generateImage,
      generateSound: generateSound,
    );
  }
}

void main() {
  late FakeActivityApiService fakeActivityApi;
  late FakeCoreApiService fakeCoreApi;
  late ActivityRepository activityRepository;
  late PictogramRepository pictogramRepository;
  late ActivityFormViewModel vm;

  const createdActivity = Activity(
    activityId: 1,
    date: '2025-03-17',
    startTime: '08:00:00',
    endTime: '09:00:00',
    isCompleted: false,
    pictogramId: 5,
  );

  const createdPictogram = Pictogram(
    id: 5,
    name: 'Toilet',
    imageUrl: '/media/toilet.png',
    soundUrl: '/media/toilet.mp3',
  );

  setUp(() {
    fakeActivityApi = FakeActivityApiService();
    fakeCoreApi = FakeCoreApiService();
    activityRepository = ActivityRepository(apiService: fakeActivityApi);
    pictogramRepository = PictogramRepository(coreApiService: fakeCoreApi);
    vm = ActivityFormViewModel(
      activityRepository: activityRepository,
      pictogramRepository: pictogramRepository,
      subjectId: 42,
      isCitizen: true,
      initialDate: DateTime(2025, 3, 17),
    );
  });

  group('ActivityFormViewModel', () {
    test('validate returns error when end time is before start time', () {
      vm.setStartTime((hour: 10, minute: 0));
      vm.setEndTime((hour: 9, minute: 0));

      expect(vm.validate(), isNotNull);
    });

    test('save returns true when create succeeds', () async {
      fakeActivityApi.onCreateCitizen = (_, __) async => createdActivity;

      final result = await vm.save();

      expect(result, isTrue);
      expect(vm.error, isNull);
      expect(activityRepository.activities.length, 1);
    });

    test('save returns false and sets error when create fails', () async {
      fakeActivityApi.onCreateCitizen = (_, __) async => throw Exception('fail');

      final result = await vm.save();

      expect(result, isFalse);
      expect(vm.error, isNotNull);
    });

    test('generatePictogram returns false when no name or prompt', () async {
      final result = await vm.generatePictogram();

      expect(result, isFalse);
      expect(vm.error, isNotNull);
    });

    test('generatePictogram selects created pictogram on success', () async {
      fakeCoreApi.onCreatePictogram = ({
        required String name,
        String? imageUrl,
        int? organizationId,
        bool generateImage = false,
        bool generateSound = true,
      }) async => createdPictogram;

      vm.setGeneratePrompt('toilet icon');
      final result = await vm.generatePictogram();

      expect(result, isTrue);
      expect(vm.selectedPictogramId, createdPictogram.id);
      expect(vm.selectedPictogram, createdPictogram);
    });

    test('uploadPictogramFromFile validates missing input', () async {
      final resultMissingAll = await vm.uploadPictogramFromFile();
      expect(resultMissingAll, isFalse);

      vm.setPictogramName('Toilet');
      final resultMissingFile = await vm.uploadPictogramFromFile();
      expect(resultMissingFile, isFalse);

      vm.setSelectedImageFile(
        PlatformFile(
          name: 'toilet.png',
          size: 4,
          bytes: Uint8List.fromList([1, 2, 3, 4]),
        ),
      );
      expect(vm.selectedImageFile, isNotNull);
    });
  });
}
