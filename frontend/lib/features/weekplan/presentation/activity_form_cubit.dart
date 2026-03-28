import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logging/logging.dart';

import 'package:weekplanner/core/errors/activity_failure.dart';
import 'package:weekplanner/features/weekplan/domain/repositories/activity_repository.dart';
import 'package:weekplanner/features/weekplan/domain/repositories/pictogram_repository.dart';
import 'package:weekplanner/features/weekplan/domain/activity_form_state.dart';
import 'package:weekplanner/shared/models/activity.dart';
import 'package:weekplanner/shared/models/pictogram.dart';
import 'package:weekplanner/shared/utils/date_utils.dart';

final _log = Logger('ActivityFormCubit');

/// Manages state for the activity create/edit form.
///
/// Handles form field updates, pictogram search with debounce,
/// pictogram creation (upload + AI generation), and activity save.
class ActivityFormCubit extends Cubit<ActivityFormState> {
  final ActivityRepository _activityRepository;
  final PictogramRepository _pictogramRepository;
  final int subjectId;
  final bool isCitizen;
  final int? organizationId;

  Timer? _searchDebounce;

  ActivityFormCubit({
    required ActivityRepository activityRepository,
    required PictogramRepository pictogramRepository,
    required this.subjectId,
    required this.isCitizen,
    this.organizationId,
    Activity? existingActivity,
    required DateTime initialDate,
  })  : _activityRepository = activityRepository,
        _pictogramRepository = pictogramRepository,
        super(ActivityFormReady(
          date: existingActivity?.date ?? initialDate,
          startTime: existingActivity?.startTime ?? const (hour: 8, minute: 0),
          endTime: existingActivity?.endTime ?? const (hour: 9, minute: 0),
          selectedPictogramId: existingActivity?.pictogramId,
          existingActivity: existingActivity,
        ));

  // ── Form field setters ────────────────────────────────────

  void setStartTime(TimeValue time) {
    _emitReady(startTime: time);
  }

  void setEndTime(TimeValue time) {
    _emitReady(endTime: time);
  }

  void setPictogramMode(PictogramMode mode) {
    _emitReady(pictogramMode: mode);
  }

  void setPictogramName(String name) {
    _emitReady(pictogramName: name);
  }

  void setGeneratePrompt(String prompt) {
    _emitReady(generatePrompt: prompt);
  }

  void setSelectedImageFile(PlatformFile? file) {
    _emitReady(selectedImageFile: file);
  }

  void setSelectedSoundFile(PlatformFile? file) {
    _emitReady(selectedSoundFile: file);
  }

  void setGenerateSound(bool value) {
    _emitReady(generateSound: value);
  }

  void selectPictogram(Pictogram pictogram) {
    _emitReady(
      selectedPictogramId: pictogram.id,
      selectedPictogram: pictogram,
    );
  }

  // ── Pictogram search ─────────────────────────────────────

  /// Debounced search — call on every keystroke.
  void onSearchQueryChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      searchPictograms(query);
    });
  }

  /// Execute a pictogram search immediately.
  Future<void> searchPictograms(String query) async {
    _emitReady(isSearching: true);

    final result = await _pictogramRepository.searchPictograms(query);
    switch (result) {
      case Left(:final value):
        _log.warning('Pictogram search failed: ${value.message}');
        _emitReady(isSearching: false);
      case Right(:final value):
        _emitReady(searchResults: value, isSearching: false);
    }
  }

  // ── Pictogram creation ───────────────────────────────────

  /// Upload a local image as a new pictogram and select it.
  Future<bool> uploadPictogramFromFile() async {
    if (state.selectedImageFile == null || state.pictogramName.isEmpty) {
      _emitReady(error: 'Angiv navn og vælg et billede');
      return false;
    }

    _emitReady(isCreatingPictogram: true, error: null);

    final result = await _pictogramRepository.uploadPictogram(
      name: state.pictogramName,
      imageFile: state.selectedImageFile!,
      soundFile: state.selectedSoundFile,
      organizationId: organizationId,
      generateSound: state.generateSound,
    );

    switch (result) {
      case Left(:final value):
        _emitReady(isCreatingPictogram: false, error: value.message);
        return false;
      case Right(:final value):
        _emitReady(
          isCreatingPictogram: false,
          selectedPictogramId: value.id,
          selectedPictogram: value,
        );
        return true;
    }
  }

  /// Create a pictogram via AI generation and select it.
  Future<bool> generatePictogram() async {
    final prompt =
        state.generatePrompt.isNotEmpty ? state.generatePrompt : state.pictogramName;
    if (prompt.isEmpty) {
      _emitReady(error: 'Angiv et navn eller en beskrivelse');
      return false;
    }

    _emitReady(isCreatingPictogram: true, error: null);

    final result = await _pictogramRepository.createPictogram(
      name: prompt,
      organizationId: organizationId,
      generateImage: true,
      generateSound: state.generateSound,
    );

    switch (result) {
      case Left(:final value):
        _emitReady(isCreatingPictogram: false, error: value.message);
        return false;
      case Right(:final value):
        _emitReady(
          isCreatingPictogram: false,
          selectedPictogramId: value.id,
          selectedPictogram: value,
        );
        return true;
    }
  }

  // ── Validation and save ──────────────────────────────────

  /// Validate the form and return an error message, or null if valid.
  String? validate() {
    final startMinutes = state.startTime.hour * 60 + state.startTime.minute;
    final endMinutes = state.endTime.hour * 60 + state.endTime.minute;
    if (endMinutes <= startMinutes) {
      return 'Sluttid skal være efter starttid';
    }
    return null;
  }

  /// Save the activity (create or update). Returns true on success.
  Future<bool> save() async {
    final validationError = validate();
    if (validationError != null) {
      _emitReady(error: validationError);
      return false;
    }

    final s = state;
    emit(ActivityFormSaving(
      startTime: s.startTime,
      endTime: s.endTime,
      date: s.date,
      selectedPictogramId: s.selectedPictogramId,
      selectedPictogram: s.selectedPictogram,
      existingActivity: s.existingActivity,
      pictogramMode: s.pictogramMode,
      pictogramName: s.pictogramName,
      generatePrompt: s.generatePrompt,
      selectedImageFile: s.selectedImageFile,
      selectedSoundFile: s.selectedSoundFile,
      generateSound: s.generateSound,
      isCreatingPictogram: s.isCreatingPictogram,
      searchResults: s.searchResults,
      isSearching: s.isSearching,
    ));

    final data = {
      'date': GirafDateUtils.formatQueryDate(s.date),
      'startTime': formatTimeValueForApi(s.startTime),
      'endTime': formatTimeValueForApi(s.endTime),
      if (s.selectedPictogramId != null) 'pictogramId': s.selectedPictogramId,
    };

    final Either<ActivityFailure, Activity> result;
    if (s.isEditing) {
      result = await _activityRepository.updateActivity(
          s.existingActivity!.activityId, data);
    } else {
      result = await _activityRepository.createActivity(
        id: subjectId,
        isCitizen: isCitizen,
        data: data,
      );
    }

    switch (result) {
      case Left(:final value):
        _emitReady(error: value.message);
        return false;
      case Right():
        emit(ActivityFormSaved(
          startTime: s.startTime,
          endTime: s.endTime,
          date: s.date,
          selectedPictogramId: s.selectedPictogramId,
          selectedPictogram: s.selectedPictogram,
          existingActivity: s.existingActivity,
          pictogramMode: s.pictogramMode,
          pictogramName: s.pictogramName,
          generatePrompt: s.generatePrompt,
          selectedImageFile: s.selectedImageFile,
          selectedSoundFile: s.selectedSoundFile,
          generateSound: s.generateSound,
          searchResults: s.searchResults,
          isSearching: s.isSearching,
        ));
        return true;
    }
  }

  // ── Helpers ──────────────────────────────────────────────

  /// Emit an [ActivityFormReady] state, carrying forward all fields
  /// from the current state unless explicitly overridden.
  ///
  /// Note: nullable fields (selectedPictogramId, selectedPictogram,
  /// selectedImageFile, selectedSoundFile) cannot be cleared back to null
  /// through this helper — the `??` pattern preserves the old value when
  /// null is passed. This is acceptable because the current UI does not
  /// support deselecting these fields. If deselection is needed in the
  /// future, use a sentinel wrapper or a dedicated clear method.
  void _emitReady({
    String? error,
    TimeValue? startTime,
    TimeValue? endTime,
    int? selectedPictogramId,
    Pictogram? selectedPictogram,
    PictogramMode? pictogramMode,
    String? pictogramName,
    String? generatePrompt,
    PlatformFile? selectedImageFile,
    PlatformFile? selectedSoundFile,
    bool? generateSound,
    bool? isCreatingPictogram,
    List<Pictogram>? searchResults,
    bool? isSearching,
  }) {
    final s = state;
    emit(ActivityFormReady(
      error: error,
      startTime: startTime ?? s.startTime,
      endTime: endTime ?? s.endTime,
      date: s.date,
      selectedPictogramId: selectedPictogramId ?? s.selectedPictogramId,
      selectedPictogram: selectedPictogram ?? s.selectedPictogram,
      existingActivity: s.existingActivity,
      pictogramMode: pictogramMode ?? s.pictogramMode,
      pictogramName: pictogramName ?? s.pictogramName,
      generatePrompt: generatePrompt ?? s.generatePrompt,
      selectedImageFile: selectedImageFile ?? s.selectedImageFile,
      selectedSoundFile: selectedSoundFile ?? s.selectedSoundFile,
      generateSound: generateSound ?? s.generateSound,
      isCreatingPictogram: isCreatingPictogram ?? s.isCreatingPictogram,
      searchResults: searchResults ?? s.searchResults,
      isSearching: isSearching ?? s.isSearching,
    ));
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}
